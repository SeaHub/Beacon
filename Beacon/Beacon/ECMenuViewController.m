//
//  ECMenuViewController.m
//  Beacon
//
//  Created by 段昊宇 on 2017/6/8.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECMenuViewController.h"
#import "ECMenuItemTableViewCell.h"

#import "Masonry.h"

@interface ECMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *bakView;
@property (nonatomic, strong) UIView *menuCard;
@property (nonatomic, strong) UIButton *favourite;
@property (nonatomic, strong) UIButton *history;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ECMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialDatas];
    [self initialViews];
    [self addViews];
    [self setLayouts];
}

- (void)initialDatas {
    
}

- (void)initialViews {
    self.bakView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bakView.frame = self.view.bounds;
    self.bakView.backgroundColor = [UIColor blackColor];
    self.bakView.alpha = 0.42;
    [self.bakView addTarget:self action:@selector(exitMenu) forControlEvents:UIControlEventTouchUpInside];
    
    self.menuCard = [[UIView alloc] init];
    self.menuCard.backgroundColor = [UIColor whiteColor];
    self.menuCard.layer.masksToBounds = YES;
    self.menuCard.layer.cornerRadius = 12;
    
    self.favourite = [UIButton buttonWithType:UIButtonTypeCustom];
    self.favourite.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    [self.favourite setTitle:@"Favourite" forState:UIControlStateNormal];
    [self.favourite setTitleColor:[UIColor colorWithRed:2 / 255.0 green:173 / 255.0 blue:88 / 255.0 alpha:1] forState:UIControlStateNormal];
    [self.favourite addTarget:self action:@selector(filterType:) forControlEvents:UIControlEventTouchUpInside];
    
    self.history = [UIButton buttonWithType:UIButtonTypeCustom];
    self.history.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    [self.history setTitle:@"History" forState:UIControlStateNormal];
    [self.history setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.history addTarget:self action:@selector(filterType:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 40.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ECMenuItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"ECMenuItemTableViewCell"];
}

- (void)addViews {
    [self.view addSubview:self.bakView];
    [self.view addSubview:self.menuCard];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.favourite];
    [self.view addSubview:self.history];
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
}

# pragma mark: Exit Action
- (void)exitMenu {
    [self dismissViewControllerAnimated:YES completion:^{
        debugLog(@"Exit menu view controller. ");
    }];
}

# pragma mark: Filter
- (void)filterType: (id)sender {
    UIButton *filterBtn = (UIButton *)sender;
    if (filterBtn == self.favourite) {
        [self.favourite setTitleColor:[UIColor colorWithRed:2 / 255.0 green:173 / 255.0 blue:88 / 255.0 alpha:1] forState:UIControlStateNormal];
        [self.history setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (filterBtn == self.history) {
        [self.history setTitleColor:[UIColor colorWithRed:2 / 255.0 green:173 / 255.0 blue:88 / 255.0 alpha:1] forState:UIControlStateNormal];
        [self.favourite setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    return 5;
}

#pragma mark - UITableDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 4) {
        ECMenuItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECMenuItemTableViewCell" forIndexPath:indexPath];
        if (indexPath.row != 3) {
            cell.bottomLine.alpha = 0;
        }
        return cell;
    } else {
        return [UITableViewCell new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
