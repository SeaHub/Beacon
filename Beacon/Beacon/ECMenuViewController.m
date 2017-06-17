//
//  ECMenuViewController.m
//  Beacon
//
//  Created by 段昊宇 on 2017/6/8.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECMenuViewController.h"
#import "ECMenuItemTableViewCell.h"
#import "ECAPIManager.h"
#import "ECReturningVideo.h"
#import "IQActivityIndicatorView.h"
#import "ECReturningWatchedVideo.h"
#import "ECVideoTableViewController.h"
#import "ECMainViewController.h"

#import "UITableView+EmptyData.h"
#import "Masonry.h"

@interface ECMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *bakView;
@property (nonatomic, strong) UIView *menuCard;
@property (nonatomic, strong) UIButton *favourite;
@property (nonatomic, strong) UIButton *history;
@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, strong) IQActivityIndicatorView *indicator;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)   NSArray<ECReturningVideo *> *dataSource;

@end

@implementation ECMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialViews];
    [self initialDatas];
    [self addViews];
    [self setLayouts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.bakView.alpha = 0.42;
    }];
}

- (void)initialDatas {
    [[ECAPIManager sharedManager] getLikedVideoWithSuccessBlock:^(NSArray<ECReturningVideo *> * datas) {
        self.likedVideos = datas;
        if (self.type == ECMenuFavouriteType) {
            [self updateTableData];
            [self stopUpdateAnimation];
        }
    } withFailureBlock:^(NSError * error) {
        debugLog(@"%@", error);
    }];
    [[ECAPIManager sharedManager] getPlayedHistroyWithSuccessBlock:^(NSArray<ECReturningWatchedVideo *> * _Nonnull watchedVideos) {
        self.watchedVideos = watchedVideos;
        if (self.type == ECMenuHistoryType) {
            [self updateTableData];
            [self stopUpdateAnimation];
        }
    } withFailureBlock:^(NSError * _Nonnull error) {
        debugLog(@"%@", error);
    }];
    if (self.likedVideos.count > 0) {
        self.dataSource = self.likedVideos;
    } else {
        [[ECAPIManager sharedManager] getLikedVideoWithSuccessBlock:^(NSArray<ECReturningVideo *> * datas) {
            self.dataSource = datas;
            [self.tableView reloadData];
        } withFailureBlock:^(NSError * error) {
            debugLog(@"%@", error);
        }] ;
    }
}

- (void)initialViews {
    self.type = ECMenuFavouriteType;
    self.bakView                 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bakView.frame           = self.view.bounds;
    self.bakView.backgroundColor = [UIColor blackColor];
    self.bakView.alpha           = 0;
    [self.bakView addTarget:self action:@selector(exitMenu) forControlEvents:UIControlEventTouchUpInside];
    
    self.menuCard                     = [[UIView alloc] init];
    self.menuCard.backgroundColor     = [UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1];
    self.menuCard.layer.masksToBounds = YES;
    self.menuCard.layer.cornerRadius  = 12;
    
    self.indicator = [[IQActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self.indicator startAnimating];
    
    self.loadingLabel = [[UILabel alloc] init];
    self.loadingLabel.text = @"Loading";
    self.loadingLabel.textAlignment = NSTextAlignmentRight;
    self.loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
    self.loadingLabel.textColor = [UIColor grayColor];
    
    self.favourite                 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.favourite.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    [self.favourite setTitle:@"Favourite" forState:UIControlStateNormal];
    [self.favourite setTitleColor:[UIColor colorWithRed:2 / 255.0 green:173 / 255.0 blue:88 / 255.0 alpha:1]
                         forState:UIControlStateNormal];
    [self.favourite addTarget:self action:@selector(filterType:) forControlEvents:UIControlEventTouchUpInside];
    
    self.history                 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.history.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    [self.history setTitle:@"History" forState:UIControlStateNormal];
    [self.history setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.history addTarget:self action:@selector(filterType:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView                    = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor    = [UIColor clearColor];
    self.tableView.dataSource         = self;
    self.tableView.delegate           = self;
    self.tableView.estimatedRowHeight = 40.f;
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    self.tableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ECMenuItemTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"ECMenuItemTableViewCell"];
}

- (void)addViews {
    [self.view addSubview:self.bakView];
    [self.view addSubview:self.menuCard];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.favourite];
    [self.view addSubview:self.history];
    [self.view addSubview:self.indicator];
    [self.view addSubview:self.loadingLabel];
}

- (void)setLayouts {
    [self.bakView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.menuCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(12);
        make.top.equalTo(self.view.mas_top).with.offset(130);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.menuCard.mas_bottom).with.offset(10);
        make.top.equalTo(self.menuCard.mas_top).with.offset(45);
        make.left.right.equalTo(self.menuCard);
    }];
    
    [self.favourite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.menuCard.mas_centerX).with.offset(-10);
        make.top.equalTo(self.menuCard.mas_top).with.offset(12);
    }];
    
    [self.history mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuCard.mas_centerX).with.offset(10);
        make.top.equalTo(self.menuCard.mas_top).with.offset(12);
    }];
    
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuCard.mas_top).with.offset(20);
        make.right.equalTo(self.menuCard.mas_right).with.offset(-20);
        make.width.height.equalTo(@15);
    }];
    [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.indicator);
        make.right.equalTo(self.indicator.mas_left).with.offset(-10);
    }];
}

- (void)stopUpdateAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.loadingLabel.alpha = 0;
        self.indicator.alpha    = 0;
    }];
}

- (void)startUpdateAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.loadingLabel.alpha = 1;
        self.indicator.alpha    = 1;
    }];
}

- (void)updateTableData {
    switch (self.type) {
        case ECMenuFavouriteType:
            self.dataSource = self.likedVideos;
            [self.tableView reloadData];
            break;
        case ECMenuHistoryType:
            self.dataSource = self.watchedVideos;
            [self.tableView reloadData];
            break;
    }
}
# pragma mark: Exit Action
- (void)exitMenu {
    [UIView animateWithDuration:0.3 animations:^{
        self.bakView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:^{
            debugLog(@"Exit menu view controller. ");
        }];
    }];
}

# pragma mark: Filter
- (void)filterType: (id)sender {
    UIButton *filterBtn = (UIButton *)sender;
    if (filterBtn == self.favourite) {
        if (self.type == ECMenuHistoryType) {
            [self.favourite setTitleColor:[UIColor colorWithRed:2 / 255.0 green:173 / 255.0 blue:88 / 255.0 alpha:1] forState:UIControlStateNormal];
            [self.history setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.type = ECMenuFavouriteType;
            [self updateTableData];
        }
    }
    if (filterBtn == self.history) {
        if (self.type == ECMenuFavouriteType) {
            [self.history setTitleColor:[UIColor colorWithRed:2 / 255.0 green:173 / 255.0 blue:88 / 255.0 alpha:1] forState:UIControlStateNormal];
            [self.favourite setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.type = ECMenuHistoryType;
            [self updateTableData];
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitMsg:@"No Videos. 🎬" ifNecessaryForRowCount:self.dataSource.count];
    if (self.dataSource.count == 0) {
        return 0;
    }
    return self.dataSource.count + 1;
}

#pragma mark - UITableDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        ECMenuItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECMenuItemTableViewCell" forIndexPath:indexPath];
        [cell configureCellByModel:self.dataSource[indexPath.row]];
        cell.bottomLine.alpha = 0;
        if (indexPath.row == self.dataSource.count - 1) {
            cell.bottomLine.alpha = 0.1;
        }
        return cell;
    } else {
        UITableViewCell *cell = [UITableViewCell new];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.rootVC performSegueWithIdentifier:kSegueOfECVideoController sender:self.dataSource[indexPath.row]];
    }];
}

@end
