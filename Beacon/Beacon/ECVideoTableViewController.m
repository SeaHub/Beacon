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

static NSString *const kECVideoTablePlayerReuseIdentifier          = @"kECVideoTablePlayerReuseIdentifier";
static NSString *const kECVideoTableIntroductReuseIdentifier       = @"kECVideoTableIntroductReuseIdentifier";
static NSString *const kECVideoTableGuessingLabelReuseIdentifier   = @"kECVideoTableGuessingLabelReuseIdentifier";
static NSString *const kECVideoTableGuessingContentReuseIdentifier = @"kECVideoTableGuessingContentReuseIdentifier";

@interface ECVideoTableViewController ()

@property (nonatomic, copy, nullable) NSArray<ECReturningVideo *> *guessingDatas;

@end

@implementation ECVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initialGuessingDatas];
}

- (void)_initialGuessingDatas {
    self.guessingDatas     = @[];
    [ECCacheAPIHelper getTop5VideosFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideo *> * _Nullable cachedVideos) {
        self.guessingDatas = cachedVideos;
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
            ECReturningVideo *cellData = self.guessingDatas[indexPath.row - 3];
            [guessingContentCell configureCellWithTitle:cellData.title
                                     withImageURLString:cellData.img
                                              withTypes:@[@"iQiYi"]];
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
        case 1:
            height = 150.0;
            break;
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

@end
