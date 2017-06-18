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
#import "IQActivityIndicatorView.h"
#import <Masonry.h>
#import <MediaPlayer/MediaPlayer.h>

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
@property (nonatomic, strong) IQActivityIndicatorView *indicator;
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UITapGestureRecognizer   *indicatorTapGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *upSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *downSwipeGestureRecognizer;

// Following are IBOutlet properties
@property (weak, nonatomic) IBOutlet UIView *playerScreen;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resourceTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *resourceTypeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *resourceWatchTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *remenuButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIProgressView *videoProgressView;

@end

@implementation ECVideoPlayerTableViewCell

#pragma mark - Public methods
- (void)awakeFromNib {
    [super awakeFromNib];
    self.resourceTypeCollectionView.delegate   = self;
    self.resourceTypeCollectionView.dataSource = self;
    self.resourceTypes                         = @[];
}

- (void)dealloc {
    [self.indicator removeFromSuperview];
    UIView *player = [QYPlayerController sharedInstance].view;
    [player removeGestureRecognizer:self.rightSwipeGestureRecognizer];
    [player removeGestureRecognizer:self.leftSwipeGestureRecognizer];
    [player removeGestureRecognizer:self.upSwipeGestureRecognizer];
    [player removeGestureRecognizer:self.downSwipeGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithVideo:(ECReturningVideo *)video {
    if (!self.video || ![self.video isEqual:video]) {
        self.video = video;
        [self _setupPlayer];
    
        self.resourceTitleLabel.text      = video.short_title;
        self.resourceTypes                = @[@"iQiYi"];
        self.resourceWatchTimeLabel.text  = [NSString stringWithFormat:@"%@%@", video.play_count, @" 次"];
        [self.resourceTypeCollectionView reloadData];
    }
}

- (void)updateCurrentPlayingStatusWithViewModel:(ECPlayerViewModel *)viewModel {
    // Following code guarantee self status to be the same as Full-Screen status
    [self.videoProgressView setProgress:viewModel.currentTime / viewModel.totalTime animated:NO];
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
        [self _indicatorStopAnimation];
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"toolPlay"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] pause];
        [self _indicatorStartAnimation];
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
        self.menuButton.alpha   = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.dislikeButton.alpha  = 1;
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
        [self _indicatorStopAnimation];
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"toolPlay"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] pause];
        [self _indicatorStartAnimation];
    }
    
    self.isPlaying = !self.isPlaying;
    [[ECAPIManager sharedManager] addPlayedHistoryWithVideoID:self.video.a_id
                                             withSuccessBlock:nil
                                             withFailureBlock:nil];
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
    [self.indicator removeFromSuperview];
    [self _setFullScreen];
}

- (IBAction)likeButtonClicked:(id)sender {
    [[ECAPIManager sharedManager] addLikedVideoWithVideoID:self.video.a_id
                                          withSuccessBlock:^(BOOL status) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if (status) {
                                                      [ECUtil showCancelAlertWithTitle:@"提示"
                                                                               withMsg:@"成功添加至喜爱列表"
                                                                        withCompletion:nil];
                                                  }
                                              });
                                              
                                          } withFailureBlock:^(NSError * _Nonnull error) {
                                              debugLog(@"%@", [error description]);
                                          }];
}

- (IBAction)dislikeButtonClicked:(id)sender {
    [[ECAPIManager sharedManager] delLikedVideoWithVideoID:self.video.a_id
                                          withSuccessBlock:^(BOOL status) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if (status) {
                                                      [ECUtil showCancelAlertWithTitle:@"提示"
                                                                               withMsg:@"成功操作"
                                                                        withCompletion:nil];
                                                  }
                                              });
                                              
                                          } withFailureBlock:^(NSError * _Nonnull error) {
                                              debugLog(@"%@", [error description]);
                                          }];
}

#pragma mark - Player Related
- (void)_setupPlayer {
    [self _setupPlayerVariables];
    [self _setupPlayerView];
    [self _setUpGestures];
    [self _setupIndicator];
}

- (void)_setupPlayerVariables {
    self.isPlaying                  = NO;
    self.isFullScreen               = NO;
    self.isMute                     = NO;
    self.isTimeUsed                 = YES;
    self.loveButton.alpha           = 0;
    self.remenuButton.alpha         = 0;
    self.dislikeButton.alpha        = 0;
    self.videoProgressView.progress = 0;
    self.currentTime                = 0;
    self.totalTime                  = 0;
}

- (void)_setupIndicator {
    [self.indicator removeGestureRecognizer:self.indicatorTapGestureRecognizer];
    [self.indicator removeFromSuperview];
    UIView *player = [QYPlayerController sharedInstance].view;
    self.indicator = [[IQActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self.indicator startAnimating];
    [player addSubview:self.indicator];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(player.mas_centerX);
        make.centerY.equalTo(player.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    
    self.indicatorTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(playButtonClicked:)];
    self.indicatorTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.indicator addGestureRecognizer:self.indicatorTapGestureRecognizer];
}

- (void)_indicatorStopAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.indicator.alpha = 0;
    }];
}

- (void)_indicatorStartAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.indicator.alpha = 1;
    }];
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

- (void)_setUpGestures {
    self.leftSwipeGestureRecognizer  = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(_leftSwipeGestureAction)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(_rightSwipeGestureAction)];
    self.upSwipeGestureRecognizer    = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(_upSwipeGestureAction:)];
    self.downSwipeGestureRecognizer  = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(_downSwipeGestureAction:)];
    
    self.leftSwipeGestureRecognizer.direction              = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction             = UISwipeGestureRecognizerDirectionRight;
    self.upSwipeGestureRecognizer.direction                = UISwipeGestureRecognizerDirectionUp;
    self.downSwipeGestureRecognizer.direction              = UISwipeGestureRecognizerDirectionDown;
    
    UIView *playerView = [QYPlayerController sharedInstance].view;
    [playerView addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [playerView addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [playerView addGestureRecognizer:self.upSwipeGestureRecognizer];
    [playerView addGestureRecognizer:self.downSwipeGestureRecognizer];
}

- (void)_updateTimeStatusWithCurrentPlayer:(QYPlayerController *)player {
    if (self.isTimeUsed) { // Guarantee the time of view model is used before update
        self.currentTime    = player.currentPlaybackTime;
        self.totalTime      = player.duration;
        self.timeLabel.text = [ECUtil jointPlayTimeString:player.currentPlaybackTime withTotalTime:player.duration];
    }
}

- (void)_changeVolume:(CGFloat)changedValue {
    UISlider *volumeViewSlider = nil;
    for (UIView *view in [self.volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    if (volumeViewSlider.value + changedValue > 1.0 || volumeViewSlider.value - changedValue < 0) {
        return;
    }
    
    [volumeViewSlider setValue:volumeViewSlider.value + changedValue animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)transformPlayerIntoFullScreen {
    [self _indicatorStopAnimation];
    [self _setFullScreen];
}

#pragma mark - QYPlayControllerDelegate
- (void)startLoading:(QYPlayerController *)player {
    [self _updateTimeStatusWithCurrentPlayer:player];
}

- (void)stopLoading:(QYPlayerController *)player {
    [self _updateTimeStatusWithCurrentPlayer:player];
}

- (void)playbackTimeChanged:(QYPlayerController *)player {
    [self _updateTimeStatusWithCurrentPlayer:player];
    [self.videoProgressView setProgress:player.currentPlaybackTime / player.duration];
}

- (void)playbackFinshed:(QYPlayerController *)player {
    [self _updateTimeStatusWithCurrentPlayer:player];
    [self.videoProgressView setProgress:1.0 animated:YES];
}

- (void)playerNetworkChanged:(QYPlayerController *)player {
    [ECUtil checkNetworkStatusWithErrorBlock:nil withSuccessBlock:nil];
}

- (void)onPlayerError:(NSDictionary *)error_no {
    debugLog(@"Delegate: An error %@ occured when start playing...", error_no);
    [ECUtil showCancelAlertWithTitle:@"提示" withMsg:@"发生未知错误, 请稍后重试" withCompletion:nil];
}

- (void)onAdStartPlay:(QYPlayerController *)player {

    [[QYPlayerController sharedInstance] pause];
}

- (void)onContentStartPlay:(QYPlayerController *)player {
    if (!self.isTimeUsed) {
        [[QYPlayerController sharedInstance] seekToTime:self.currentTime];
    }
    self.isTimeUsed = YES;
    
    if (self.isPlaying) {
        [self.playButton setImage:[UIImage imageNamed:@"toolStop"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] play];
        [self _indicatorStopAnimation];
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"toolPlay"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] pause];
        [self _indicatorStartAnimation];
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

#pragma mark - Gesture Actions
- (void)_leftSwipeGestureAction {
    [[QYPlayerController sharedInstance] seekToTime:self.currentTime + kTimeIntervalOfSwipe];
    [[QYPlayerController sharedInstance] play];
    [self _indicatorStopAnimation];
}

- (void)_rightSwipeGestureAction {
    [[QYPlayerController sharedInstance] seekToTime:self.currentTime - kTimeIntervalOfSwipe];
    [[QYPlayerController sharedInstance] play];
    [self _indicatorStopAnimation];
}

- (void)_upSwipeGestureAction:(UIGestureRecognizer *)gr {
    CGPoint point       = [gr locationInView:[QYPlayerController sharedInstance].view];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (point.x > screenWidth / 2) { // Tapping on the right
        [self _changeVolume:+0.1];
        
    } else { // Tapping on the left
        if ([UIScreen mainScreen].brightness < 1) {
            [UIScreen mainScreen].brightness += 0.1;
        }
    }
}

- (void)_downSwipeGestureAction:(UIGestureRecognizer *)gr {
    CGPoint point = [gr locationInView:[QYPlayerController sharedInstance].view];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (point.x > screenWidth / 2) { // Tapping on the right
        [self _changeVolume:-0.1];
        
    } else { // Tapping on the left
        if ([UIScreen mainScreen].brightness > 0) {
            [UIScreen mainScreen].brightness -= 0.1;
        }
    }
}

@end
