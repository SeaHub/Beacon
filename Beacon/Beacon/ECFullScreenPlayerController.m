//
//  ECPlayerController.m
//  iQiYiPrototype
//
//  Created by SeaHub on 2017/5/20.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECFullScreenPlayerController.h"
#import "QYPlayerController.h"
#import "ECPlayerViewModel.h"
#import "ECReturningVideo.h"
#import "IQActivityIndicatorView.h"
#import "ECAPIManager.h"
#import <Masonry.h>

@interface ECFullScreenPlayerController () <QYPlayerControllerDelegate>

@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL isMute;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isControlHidden;
@property (nonatomic, assign) BOOL isTimeUsed;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval totalTime;
@property (nonatomic, strong) IQActivityIndicatorView *indicator;

// Following are IBOutlet properties
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeLabelBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *toolBgImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *videoProgressView;

@end

@implementation ECFullScreenPlayerController

#pragma mark - Life Cycle
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _setupVariables];
    [self _setupPlayerView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[QYPlayerController sharedInstance] stopPlayer];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(fullScreenController:viewWillDisappearWithModel:)]) {
            
            ECPlayerViewModel *viewModel = [[ECPlayerViewModel alloc] initWithReturningVideo:self.viewModel.videoSource
                                                                             withCurrentTime:self.currentTime
                                                                               withTotalTime:self.totalTime
                                                                               withMuteStaus:self.isMute
                                                                           withPlayingStatus:self.isPlaying];
            
            [self.delegate fullScreenController:self viewWillDisappearWithModel:viewModel];
        }
    }
    
    [self.indicator removeFromSuperview]; // indicator should be remove because player is a singleton
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup
- (void)_setupVariables {
    self.isFullScreen    = NO;
    self.isMute          = NO;
    self.isControlHidden = NO;
    self.currentTime     = self.viewModel.currentTime;
    self.totalTime       = self.viewModel.totalTime;
    self.isTimeUsed      = NO;
}

- (void)_setupIndicatorOnView:(UIView *)view {
    self.indicator = [[IQActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self.indicator startAnimating];
    [view addSubview:self.indicator];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
        make.width.height.equalTo(@40);
    }];
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
    ECPlayerViewModel *viewModel = self.viewModel;
    [self _showControl];
    
    QYPlayerController *playerController  = [QYPlayerController sharedInstance];
    [self _setupIndicatorOnView:playerController.view];
    [_playerView addSubview:playerController.view];
    [playerController setPlayerFrame:_playerView.bounds];
    [playerController setDelegate:self];
    [playerController openPlayerByAlbumId:viewModel.videoSource.a_id
                                     tvId:viewModel.videoSource.tv_id
                                    isVip:viewModel.videoSource.is_vip];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(_videoViewDidClicked)];
    tapGR.numberOfTapsRequired    = 1;
    [playerController.view addGestureRecognizer:tapGR];
   
    // Following code guarantee self status to be the same as Mini-Screen status
    self.timeLabel.text = [ECUtil jointPlayTimeString:viewModel.currentTime withTotalTime:viewModel.totalTime];
    [self.videoProgressView setProgress:viewModel.currentTime / viewModel.totalTime];
    
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

#pragma mark - Private Methods
- (void)_presentViewControllerWithTitle:(NSString *)title withMsg:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction            = [UIAlertAction actionWithTitle:@"确定"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_videoViewDidClicked {
    if (!self.isControlHidden) {
        [self _hideControl];
    } else {
        [self _showControl];
    }
    
    self.isControlHidden = !self.isControlHidden;
}

- (void)_showControl {
    [UIView animateWithDuration:0.5 animations:^{
        self.playButton.alpha           = 1.0;
        self.muteButton.alpha           = 1.0;
        self.fullScreenButton.alpha     = 1.0;
        self.dislikeButton.alpha        = 1.0;
        self.likeButton.alpha           = 1.0;
        self.timeLabel.alpha            = 1.0;
        self.timeLabelBgImageView.alpha = 1.0;
        self.videoProgressView.alpha    = 1.0;
    }];
    
    // Auto hide control 5s after
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _hideControl];
    });
}

- (void)_hideControl {
    [UIView animateWithDuration:0.5 animations:^{
        self.playButton.alpha           = 0.0;
        self.muteButton.alpha           = 0.0;
        self.fullScreenButton.alpha     = 0.0;
        self.dislikeButton.alpha        = 0.0;
        self.likeButton.alpha           = 0.0;
        self.timeLabel.alpha            = 0.0;
        self.timeLabelBgImageView.alpha = 0.0;
        self.videoProgressView.alpha    = 0.0;
    }];
}

- (void)_updateTimeStatusWithCurrentPlayer:(QYPlayerController *)player {
    if (self.isTimeUsed) { // Guarantee the time of view model is used before update
        self.currentTime    = player.currentPlaybackTime;
        self.totalTime      = player.duration;
        self.timeLabel.text = [ECUtil jointPlayTimeString:player.currentPlaybackTime withTotalTime:player.duration];
    }
}

#pragma mark - IBAction
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
}

- (IBAction)fullScreenButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)likeButtoClicked:(id)sender {
    [[ECAPIManager sharedManager] addLikedVideoWithVideoID:self.viewModel.videoSource.a_id
                                          withSuccessBlock:^(BOOL status) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if (status) {
                                                      [self _presentViewControllerWithTitle:@"提示"
                                                                                    withMsg:@"成功添加至喜爱列表"];
                                                  }
                                              });
                                              
                                          } withFailureBlock:^(NSError * _Nonnull error) {
                                              debugLog(@"%@", [error description]);
                                          }];
}

- (IBAction)dislikeButtonClicked:(id)sender {
    [[ECAPIManager sharedManager] delLikedVideoWithVideoID:self.viewModel.videoSource.a_id
                                          withSuccessBlock:^(BOOL status) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if (status) {
                                                      [self _presentViewControllerWithTitle:@"提示"
                                                                                    withMsg:@"成功操作"];
                                                  }
                                              });
                                              
                                          } withFailureBlock:^(NSError * _Nonnull error) {
                                              debugLog(@"%@", [error description]);
                                          }];
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
    debugLog(@"Delegate: Network changed..."); // TODO
}

- (void)onPlayerError:(NSDictionary *)error_no {
    debugLog(@"Delegate: An error occured when start playing..."); // TODO
}

- (void)onAdStartPlay:(QYPlayerController *)player {
    [[QYPlayerController sharedInstance] pause];
}

- (void)onContentStartPlay:(QYPlayerController *)player {
    debugLog(@"Delegate: The content starts playing");
    self.isTimeUsed = YES;
    [[QYPlayerController sharedInstance] seekToTime:self.viewModel.currentTime];
    
    if (self.viewModel.isPlaying) {
        [self.playButton setImage:[UIImage imageNamed:@"toolStop"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] play];
        [self _indicatorStopAnimation];
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"toolPlay"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] pause];
        [self _indicatorStartAnimation];
    }
}

@end
