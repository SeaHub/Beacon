//
//  ECPlayerController.m
//  iQiYiPrototype
//
//  Created by SeaHub on 2017/5/20.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECPlayerController.h"
#import "QYPlayerController.h"

static NSString *const kAlbumIDKey = @"a_id";
static NSString *const kTVIDKey    = @"tv_id";
static NSString *const kIsVipKey   = @"is_vip";

@interface ECPlayerController () <QYPlayerControllerDelegate> {
    BOOL   _isFullScreen;
    BOOL   _isMute;
    CGRect _originalPlayerViewFrame;
    CGRect _originalPlayerFrame;
    __weak IBOutlet UIProgressView *_videoProgressBar;
    __weak IBOutlet UIProgressView *_cacheProgressBar;
    __weak IBOutlet UIView *_playerView;
}
@end

@implementation ECPlayerController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup
- (void)_setupVariables {
    _isFullScreen            = NO;
    _isMute                  = NO;
    _originalPlayerViewFrame = _playerView.frame;
    _originalPlayerFrame     = CGRectMake(0,
                                          0,
                                          CGRectGetWidth(_playerView.bounds),
                                          CGRectGetHeight(_playerView.bounds));
}

- (void)_setupPlayerView {
    QYPlayerController *playerController  = [QYPlayerController sharedInstance];
    playerController.view.backgroundColor = UIColor.redColor;
    [playerController setPlayerFrame:_originalPlayerFrame];
    [playerController setDelegate:self];
    [_playerView addSubview:playerController.view];
    [[QYPlayerController sharedInstance] openPlayerByAlbumId:_video.a_id
                                                        tvId:_video.tv_id
                                                       isVip:_video.is_vip];
    [_videoProgressBar setProgress:0.0 animated:NO];
    [_cacheProgressBar setProgress:0.0 animated:NO];
}

#pragma mark - IBAction
- (IBAction)stopButtonClicked:(id)sender {
    [[QYPlayerController sharedInstance] pause];
}

- (IBAction)startButtonClicked:(id)sender {
    [[QYPlayerController sharedInstance] play];
}

- (IBAction)fullScreenButtonClicked:(id)sender {
    [self _playerTransfromIntoFullScreen];
}

- (IBAction)muteButtonClicked:(id)sender {
    _isMute = !_isMute;
    [[QYPlayerController sharedInstance] setMute:_isMute];
}

#pragma mark - QYPlayControllerDelegate
- (void)startLoading:(QYPlayerController *)player {
    debugLog(@"Delegate: Start Loading...");
    [_cacheProgressBar setProgress:player.playableDuration / player.duration animated:YES];
}

- (void)stopLoading:(QYPlayerController *)player {
    debugLog(@"Delegate: Stop Loading...");
    [_cacheProgressBar setProgress:1.0 animated:YES];
}

- (void)playbackTimeChanged:(QYPlayerController *)player {
    debugLog(@"Delegate: Time Changed...");
     [_videoProgressBar setProgress:player.currentPlaybackTime / player.duration animated:YES];
}

- (void)playbackFinshed:(QYPlayerController *)player {
    debugLog(@"Delegate: Finished watching...");
     [_videoProgressBar setProgress:1.0 animated:YES];
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
    [[QYPlayerController sharedInstance] pause];
}

#pragma mark - Player Control
- (void)_playerTransfromIntoFullScreen {
    CGRect newPlayerFrame     = _isFullScreen ? _originalPlayerFrame     : self.view.frame;
    CGRect newPlayerViewFrame = _isFullScreen ? _originalPlayerViewFrame : self.view.frame;
    _isFullScreen             = !_isFullScreen;
    
    [UIView animateWithDuration:0.5 animations:^{
        _playerView.frame     = newPlayerViewFrame;
        [[QYPlayerController sharedInstance] setPlayerFrame:newPlayerFrame];
    }];
}

@end
