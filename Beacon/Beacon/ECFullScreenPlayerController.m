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

@interface ECFullScreenPlayerController () <QYPlayerControllerDelegate>

@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL isMute;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isControlHidden;
@property (nonatomic, assign) BOOL isTimeUsed;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval totalTime;

// Following are IBOutlet properties
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *videoProgressView;

@end

@implementation ECFullScreenPlayerController

#pragma mark - Life Cycle
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

- (void)_setupPlayerView {
    ECPlayerViewModel *viewModel = self.viewModel;
    
    QYPlayerController *playerController  = [QYPlayerController sharedInstance];
    [_playerView addSubview:playerController.view];
    [playerController setPlayerFrame:_playerView.frame];
    [playerController setDelegate:self];
    [playerController openPlayerByAlbumId:viewModel.videoSource.a_id
                                     tvId:viewModel.videoSource.tv_id
                                    isVip:viewModel.videoSource.is_vip];
    
    UITapGestureRecognizer *tapGR =  [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(_videoViewDidClicked)];
    tapGR.numberOfTapsRequired    = 1;
    [playerController.view addGestureRecognizer:tapGR];
   
    // Following code guarantee self status to be the same as Mini-Screen status
    self.timeLabel.text = [ECUtil jointPlayTimeString:viewModel.currentTime withTotalTime:viewModel.totalTime];
    [self.videoProgressView setProgress:viewModel.currentTime / viewModel.totalTime animated:NO];
    
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

#pragma mark - Private Methods
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
        self.timeLabel.alpha         = 1.0;
        self.muteButton.alpha        = 1.0;
        self.playButton.alpha        = 1.0;
        self.fullScreenButton.alpha  = 1.0;
        self.videoProgressView.alpha = 1.0;
    }];
}

- (void)_hideControl {
    [UIView animateWithDuration:0.5 animations:^{
        self.timeLabel.alpha         = 0.0;
        self.muteButton.alpha        = 0.0;
        self.playButton.alpha        = 0.0;
        self.fullScreenButton.alpha  = 0.0;
        self.videoProgressView.alpha = 0.0;
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
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"toolPlay"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] pause];
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

#pragma mark - QYPlayControllerDelegate
- (void)startLoading:(QYPlayerController *)player {
    debugLog(@"Delegate: Start Loading...");
    [self _updateTimeStatusWithCurrentPlayer:player];

//    [_cacheProgressBar setProgress:player.playableDuration / player.duration animated:YES];
}

- (void)stopLoading:(QYPlayerController *)player {
    debugLog(@"Delegate: Stop Loading...");
//    [_cacheProgressBar setProgress:1.0 animated:YES];
    [self _updateTimeStatusWithCurrentPlayer:player];
}

- (void)playbackTimeChanged:(QYPlayerController *)player {
    [self _updateTimeStatusWithCurrentPlayer:player];
}

- (void)playbackFinshed:(QYPlayerController *)player {
    debugLog(@"Delegate: Finished watching...");
    [self _updateTimeStatusWithCurrentPlayer:player];
    [self.videoProgressView setProgress:1.0 animated:YES];
}

- (void)playerNetworkChanged:(QYPlayerController *)player {
    debugLog(@"Delegate: Network changed...");
}

- (void)onPlayerError:(NSDictionary *)error_no {
    debugLog(@"Delegate: An error occured when start playing...");
}

- (void)onAdStartPlay:(QYPlayerController *)player {
    debugLog(@"Delegate: The advertisement starts playing");
    [[QYPlayerController sharedInstance] pause];
}

- (void)onContentStartPlay:(QYPlayerController *)player {
    debugLog(@"Delegate: The content starts playing");
    self.isTimeUsed = YES;
    [[QYPlayerController sharedInstance] seekToTime:self.viewModel.currentTime];
    
    if (self.viewModel.isPlaying) {
        [self.playButton setImage:[UIImage imageNamed:@"toolStop"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] play];
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"toolPlay"] forState:UIControlStateNormal];
        [[QYPlayerController sharedInstance] pause];
    }
}

@end
