//
//  ECVideoPlayerTableViewCell.m
//  Beacon
//
//  Created by SeaHub on 2017/6/7.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoPlayerTableViewCell.h"
#import "ECVideoResourceTypeCollectionViewCell.h"
#import "QYPlayerController.h"
#import "ECReturningVideo.h"
#import "ECAPIManager.h"
#import "ECPlayerViewModel.h"
#import "ECFullScreenPlayerController.h"

static NSString *const kECVideoPlayerCellCollectionReuseIdentifier = @"kECVideoPlayerCellCollectionReuseIdentifier";
@interface ECVideoPlayerTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, QYPlayerControllerDelegate>

@property (copy, nonatomic) NSArray <NSString *> *resourceTypes;
@property (nonatomic, strong) ECReturningVideo *video;
@property (nonatomic, assign) BOOL   isFullScreen;
@property (nonatomic, assign) BOOL   isMute;
@property (nonatomic, assign) BOOL   isPlaying;
@property (nonatomic, assign) BOOL   isTimeUsed;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval totalTime;

// Following are IBOutlet properties
@property (weak, nonatomic) IBOutlet UIView *playerScreen;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resourceTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *resourceTypeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *resourceLikeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *remenuButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;

@end

@implementation ECVideoPlayerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    debugLog(@"playerScreen needs to set up");
    debugLog(@"timeLabel needs to set up");
    self.resourceTypeCollectionView.delegate   = self;
    self.resourceTypeCollectionView.dataSource = self;
    self.resourceTypes                         = @[];
    
    self.loveButton.alpha    = 0;
    self.remenuButton.alpha  = 0;
    self.dislikeButton.alpha = 0;
    
    self.currentTime = 0;
    self.totalTime   = 0;
    self.isTimeUsed  = YES;
}

- (void)cellWillAppear {
    [self _setupPlayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithVideo:(ECReturningVideo *)video {
    self.video                   = video;
    self.resourceTitleLabel.text = video.title;
    self.resourceTypes           = @[@"iQiYi"];
    self.resourceLikeLabel.text  = [NSString stringWithFormat:@"%@%@", video.play_count, @"次"];
    [self.resourceTypeCollectionView reloadData];
}

- (void)updateCurrentPlayingStatusWithViewModel:(ECPlayerViewModel *)viewModel {
    // Following code guarantee self status to be the same as Full-Screen status
    
//    [self.videoProgressView setProgress:viewModel.currentTime / viewModel.totalTime animated:NO];
    [self _setupPlayer];
    [self configureCellWithVideo:viewModel.videoSource];
    
    self.isPlaying      = viewModel.isPlaying;
    self.isMute         = viewModel.isMute;
    self.currentTime    = viewModel.currentTime;
    self.totalTime      = viewModel.totalTime;
    self.timeLabel.text = [ECUtil jointPlayTimeString:viewModel.currentTime withTotalTime:viewModel.totalTime];
    self.isTimeUsed     = NO;
    
    if (viewModel.isPlaying) {
        [self.playButton setImage:[UIImage imageNamed:@"toolStop"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] play];
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"toolPlay"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] pause];
    }
    
    if (viewModel.isMute) {
        [self.muteButton setImage:[UIImage imageNamed:@"toolMute"] forState:UIControlStateNormal];
    } else {
        [self.muteButton setImage:[UIImage imageNamed:@"toolNoneMute"] forState:UIControlStateNormal];
    }
}

#pragma mark - IBActions
- (IBAction)showMenu:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.remenuButton.alpha = 1;
        self.menuButton.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.dislikeButton.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.loveButton.alpha = 1;
            }];
        }];
    }];
}

- (IBAction)closeMenu:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.loveButton.alpha    = 0;
        self.dislikeButton.alpha = 0;
        self.remenuButton.alpha  = 0;
        self.menuButton.alpha    = 1;
    }];
}

- (IBAction)playButtonClicked:(id)sender {
    if (!self.isPlaying) {
        [self.playButton setImage:[UIImage imageNamed:@"toolStop"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] play];
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"toolPlay"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] pause];
    }
    
    self.isPlaying = !self.isPlaying;
}

- (IBAction)muteButtonClicked:(id)sender {
    if (!self.isMute) {
        [self.muteButton setImage:[UIImage imageNamed:@"toolMute"] forState:UIControlStateNormal];
    } else {
        [self.muteButton setImage:[UIImage imageNamed:@"toolNoneMute"] forState:UIControlStateNormal];
    }
    
    self.isMute = !self.isMute;
    [[QYPlayerController sharedInstance] setMute:self.isMute];
}

- (IBAction)fullScreenButtonClicked:(id)sender {
    [self _setFullScreen];
}

- (IBAction)likeButtonClicked:(id)sender {
    [[ECAPIManager sharedManager] addLikedVideoWithVideoID:self.video.a_id
                                          withSuccessBlock:^(BOOL status) {
                                              if (status) {
                                                  [ECUtil showCancelAlertWithTitle:@"提示"
                                                                           withMsg:@"成功添加至喜爱列表"];
                                              }
                                          } withFailureBlock:^(NSError * _Nonnull error) {
                                              debugLog(@"%@", [error description]);
                                          }];
}

- (IBAction)dislikeButtonClicked:(id)sender {
    debugLog(@"dislikeButtonClicked");
}

#pragma mark - Player Related
- (void)_setupPlayer {
    [self _setupPlayerVariables];
    [self _setupPlayerView];
}

- (void)_setupPlayerVariables {
    self.isPlaying               = NO;
    self.isFullScreen            = NO;
    self.isMute                  = NO;
}

- (void)_setupPlayerView {
    QYPlayerController *playerController  = [QYPlayerController sharedInstance];
    playerController.view.backgroundColor = UIColor.redColor;
    CGRect playerFrame                    = CGRectMake(0,
                                                       0,
                                                       CGRectGetWidth(self.playerScreen.bounds),
                                                       CGRectGetHeight(self.playerScreen.bounds));
    [playerController setDelegate:self];
    [playerController setPlayerFrame:playerFrame];
    [self.playerScreen addSubview:playerController.view];
    [[QYPlayerController sharedInstance] openPlayerByAlbumId:self.video.a_id
                                                        tvId:self.video.tv_id
                                                       isVip:self.video.is_vip];
}

- (void)_setFullScreen {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(videoPlayerCell:withPlayerModel:)]) {
            
            ECPlayerViewModel *viewModel = [[ECPlayerViewModel alloc] initWithReturningVideo:self.video
                                                                             withCurrentTime:self.currentTime
                                                                               withTotalTime:self.totalTime
                                                                               withMuteStaus:self.isMute
                                                                           withPlayingStatus:self.isPlaying];
            
            [self.delegate videoPlayerCell:self withPlayerModel:viewModel];
            [[QYPlayerController sharedInstance] stopPlayer];
            self.isFullScreen = !self.isFullScreen;
        }
    }
}

- (void)_updateTimeStatusWithCurrentPlayer:(QYPlayerController *)player {
    if (self.isTimeUsed) { // Guarantee the time of view model is used before update
        self.currentTime    = player.currentPlaybackTime;
        self.totalTime      = player.duration;
        self.timeLabel.text = [ECUtil jointPlayTimeString:player.currentPlaybackTime withTotalTime:player.duration];
    }
}

#pragma mark - QYPlayControllerDelegate
- (void)startLoading:(QYPlayerController *)player {
    debugLog(@"Delegate: Start Loading...");
//    [_cacheProgressBar setProgress:player.playableDuration / player.duration animated:YES];
    [self _updateTimeStatusWithCurrentPlayer:player];
}

- (void)stopLoading:(QYPlayerController *)player {
    debugLog(@"Delegate: Stop Loading...");
    [self _updateTimeStatusWithCurrentPlayer:player];
//    [_cacheProgressBar setProgress:1.0 animated:YES];
}

- (void)playbackTimeChanged:(QYPlayerController *)player {
    debugLog(@"Delegate: Time Changed...");
    [self _updateTimeStatusWithCurrentPlayer:player];
    //    [_videoProgressBar setProgress:player.currentPlaybackTime / player.duration animated:YES];
}

- (void)playbackFinshed:(QYPlayerController *)player {
    debugLog(@"Delegate: Finished watching...");
    [self _updateTimeStatusWithCurrentPlayer:player];
    
//    [_videoProgressBar setProgress:1.0 animated:YES];
}

- (void)playerNetworkChanged:(QYPlayerController *)player {
    debugLog(@"Delegate: Network changed...");
}

- (void)onPlayerError:(NSDictionary *)error_no {
    debugLog(@"Delegate: An error %@ occured when start playing...", error_no);
}

- (void)onAdStartPlay:(QYPlayerController *)player {
    debugLog(@"Delegate: The advertisement starts playing");
    [[QYPlayerController sharedInstance] pause];
}

- (void)onContentStartPlay:(QYPlayerController *)player {
    debugLog(@"Delegate: The content starts playing");
    self.isTimeUsed = YES;
    [[QYPlayerController sharedInstance] seekToTime:self.currentTime];
    
    if (self.isPlaying) {
        [self.playButton setImage:[UIImage imageNamed:@"toolStop"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] play];
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"toolPlay"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] pause];
    }
}

#pragma mark - UICollectionView Related
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ECVideoResourceTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kECVideoPlayerCellCollectionReuseIdentifier
                                                                                            forIndexPath:indexPath];
    [cell configureCellWithTitle:self.resourceTypes[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resourceTypes.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    debugLog(@"section: %ld, row: %ld selected", (long)indexPath.section, (long)indexPath.row);
}

@end
