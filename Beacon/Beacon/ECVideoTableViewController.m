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

static NSString *const kECVideoTablePlayerReuseIdentifier          = @"kECVideoTablePlayerReuseIdentifier";
static NSString *const kECVideoTableIntroductReuseIdentifier       = @"kECVideoTableIntroductReuseIdentifier";
static NSString *const kECVideoTableGuessingLabelReuseIdentifier   = @"kECVideoTableGuessingLabelReuseIdentifier";
static NSString *const kECVideoTableGuessingContentReuseIdentifier = @"kECVideoTableGuessingContentReuseIdentifier";

@interface ECVideoTableViewController () <ECVideoGuessingContentCellDelegate>

@property (nonatomic, strong, nullable) NSMutableArray<ECReturningVideo *> *guessingDatas;

@end

@implementation ECVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initialGuessingDatas];
}

- (void)_initialGuessingDatas {
    self.guessingDatas     = [@[] mutableCopy];
    [ECCacheAPIHelper getTop5VideosFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideo *> * _Nullable cachedVideos) {
        
        for (ECReturningVideo *video in cachedVideos) {
            if (![video isEqual:self.videoOfUserChosen]) {
                [self.guessingDatas addObject:video];
            }
        }
    
        [self.tableView reloadData];
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
    return 3 + self.guessingDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        ECVideoPlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:kECVideoTablePlayerReuseIdentifier forIndexPath:indexPath];
        [playerCell configureCellWithTitle:self.videoOfUserChosen.short_title withTypes:@[@"iQiYi"]
                            withLikeNumber:self.videoOfUserChosen.play_count];
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

#pragma mark - Button Action
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)likeButtonClicked:(id)sender {
    debugLog(@"Like Button Clicked");
    
    [[ECAPIManager sharedManager] addLikedVideoWithVideoID:self.videoOfUserChosen.a_id
                                          withSuccessBlock:^(BOOL status) {
                                              if (status) {
                                                  [ECUtil showCancelAlertController:self
                                                                          withTitle:@"提示"
                                                                            withMsg:@"成功添加至喜爱列表"];
                                              }
                                          } withFailureBlock:^(NSError * _Nonnull error) {
                                              debugLog(@"%@", [error description]);
                                          }];
}

- (IBAction)dislikeButtonClicked:(id)sender {
    debugLog(@"Dislike Button Clicked");
}

- (IBAction)moreButtonClicked:(id)sender {
    debugLog(@"More Button Clicked");
}

- (IBAction)playButtonClicked:(id)sender {
    debugLog(@"Play Button Clicked");
}

- (IBAction)shareButtonClicked:(id)sender {
    debugLog(@"Share Button Clicked");
}

- (IBAction)fullScreenButtonClicked:(id)sender {
    debugLog(@"FullScreen Button Clicked");
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

@end
