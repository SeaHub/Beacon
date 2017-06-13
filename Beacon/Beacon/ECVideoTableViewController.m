//
//  ECVideoTableViewController.m
//  Beacon
//
//  Created by SeaHub on 2017/6/6.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoTableViewController.h"
#import "ECReturningVideo.h"
#import "ECVideoPlayerTableViewCell.h"
#import "ECVideoIntroductTableViewCell.h"
#import "ECVideoGuessingLabelTableViewCell.h"
#import "ECVideoGuessingContentTableViewCell.h"
#import "ECCacheAPIHelper.h"
#import "ECAPIManager.h"
#import "ECVideo.h"
#import <AFNetworkReachabilityManager.h>
#import "QYPlayerController.h"
#import "ECFullScreenPlayerController.h"
#import "ECPlayerViewModel.h"

static NSString *const kECVideoTablePlayerReuseIdentifier          = @"kECVideoTablePlayerReuseIdentifier";
static NSString *const kECVideoTableIntroductReuseIdentifier       = @"kECVideoTableIntroductReuseIdentifier";
static NSString *const kECVideoTableGuessingLabelReuseIdentifier   = @"kECVideoTableGuessingLabelReuseIdentifier";
static NSString *const kECVideoTableGuessingContentReuseIdentifier = @"kECVideoTableGuessingContentReuseIdentifier";

@interface ECVideoTableViewController () <ECVideoGuessingContentCellDelegate, ECVideoPlayerTableViewCellDelegate>

@property (nonatomic, strong, nullable) NSMutableArray<ECReturningVideo *> *guessingDatas;
@property (nonatomic, strong, nullable) UIView *fullScreenView;
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;
@property (nonatomic, assign) NSInteger numberOfRowsInSectionZero;
@property (nonatomic, assign) CGRect playerOriginFrame;

@end

@implementation ECVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfRowsInSectionZero = 3;
    [self _checkNetworkStatus];
    [self _initialGuessingDatas];
}

- (void)_initialGuessingDatas {
    self.guessingDatas = [@[] mutableCopy];
    [ECCacheAPIHelper getTop5VideosFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideo *> * _Nullable cachedVideos) {
        
        for (ECReturningVideo *video in cachedVideos) {
            if (![video isEqual:self.videoOfUserChosen]) {
                [self.guessingDatas addObject:video];
            }
        }
        self.numberOfRowsInSectionZero = 3 + self.guessingDatas.count;
        [self.tableView reloadData];
    }];
}

- (void)_checkNetworkStatus {
    [ECUtil monitoringNetworkWithErrorBlock:^{
        [ECUtil showCancelAlertWithTitle:@"提示" withMsg:@"网络不可用，请连接 WiFi"];
        self.networkStatus = AFNetworkReachabilityStatusUnknown;
    } withWWANBlock:^{
        [ECUtil showCancelAlertWithTitle:@"提示" withMsg:@"目前使用蜂窝数据，建议使用 WiFi 观看视频]"];
        self.networkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
    } withWiFiBlock:^{
        self.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
        debugLog(@"Current network status is WiFi");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRowsInSectionZero;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        ECVideoPlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:kECVideoTablePlayerReuseIdentifier forIndexPath:indexPath];
        playerCell.delegate                    = self;
        [playerCell configureCellWithVideo:self.videoOfUserChosen];
        return playerCell;
    
    } else if (indexPath.row == 1) {
        ECVideoIntroductTableViewCell *introductCell = [tableView dequeueReusableCellWithIdentifier:kECVideoTableIntroductReuseIdentifier forIndexPath:indexPath];
        [introductCell configureCellWithIntroductionContent:self.videoOfUserChosen.title];
        return introductCell;
        
    } else if (indexPath.row == 2) {
        ECVideoGuessingLabelTableViewCell *guessingLabelCell = [tableView dequeueReusableCellWithIdentifier:kECVideoTableGuessingLabelReuseIdentifier forIndexPath:indexPath];
        return guessingLabelCell;
        
    } else {
        ECVideoGuessingContentTableViewCell *guessingContentCell = [tableView dequeueReusableCellWithIdentifier:kECVideoTableGuessingContentReuseIdentifier forIndexPath:indexPath];
        if (self.guessingDatas.count > 0) {
            ECReturningVideo *cellData   = self.guessingDatas[indexPath.row - 3];
            guessingContentCell.delegate = self;
            [guessingContentCell configureCellWithVideo:cellData];
        }
        
        return guessingContentCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case 0:
            height = 390.0;
            break;
        case 1: {
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGSize newSize      = [ECUtil calculateLabelSize:self.videoOfUserChosen.title
                                                    withFont:[UIFont systemFontOfSize:15]
                                                 withMaxSize:CGSizeMake(screenWidth - 42, CGFLOAT_MAX)];
            height = 60 + newSize.height;
        } break;
        case 2:
            height = 31.5;
            break;
        default:
            height = 120.0;
            break;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [(ECVideoPlayerTableViewCell *)cell cellWillAppear];
    }
}

#pragma mark - Button Action
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[QYPlayerController sharedInstance] stopPlayer];
}

#pragma mark - ECVideoGuessingContentCellDelegate
- (void)videoGuessingContentCell:(ECVideoGuessingContentTableViewCell *)cell
    imageViewDidClickedWithVideo:(ECReturningVideo *)video {
    
    NSIndexPath *indexPath            =  [self.tableView indexPathForCell:cell];
    NSIndexPath *playerIndexPath      = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *descriptionIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    // Swap data source
    self.guessingDatas[indexPath.row - 3] = self.videoOfUserChosen;
    self.videoOfUserChosen                = video;
    
    // Reload data with animation and scroll to top
    [self.tableView reloadRowsAtIndexPaths:@[indexPath, playerIndexPath, descriptionIndexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:playerIndexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

#pragma mark - ECVideoPlayerTableViewCellDelegate
- (void)videoPlayerCell:(ECVideoPlayerTableViewCell *)cell withPlayerModel:(ECPlayerViewModel *)playerViewModel {
    UIStoryboard *storyBoard                       = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ECFullScreenPlayerController *playerController = [storyBoard instantiateViewControllerWithIdentifier:kFullScreenPlayerStoryboardIdentifier];
    playerController.viewModel                     = playerViewModel;
    [self presentViewController:playerController animated:YES completion:nil];
}

- (void)videoPlayerCell:(ECVideoPlayerTableViewCell *)cell closeLightWithCurrentState:(BOOL)isLightClosed {
    // Calculate which cell should be reload, don't reload player cell or it will miss all status of player cell
    NSMutableArray<NSIndexPath *> *indexPaths = [@[] mutableCopy];
    for (int i = 1; i < self.guessingDatas.count + 3; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    if (!isLightClosed) {
        self.numberOfRowsInSectionZero = 1;
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.backgroundColor = [UIColor blackColor];
        }];
    } else {
        self.numberOfRowsInSectionZero = 3 + self.guessingDatas.count;
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.backgroundColor = [UIColor whiteColor];
        }];
    }
}

@end
