//
//  ECPlayerController.m
//  iQiYiPrototype
//
//  Created by SeaHub on 2017/5/20.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECPlayerController.h"
#import "QYPlayerController.h"

@interface ECPlayerController () <QYPlayerControllerDelegate> {
    BOOL   _isFullScreen;
    CGRect _originalPlayerViewFrame;
    CGRect _originalPlayerFrame;
    __weak IBOutlet UIView *_playerView;
}
@end

@implementation ECPlayerController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self _setupVariables];
    [self _setupPlayerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup
- (void)_setupVariables {
    _isFullScreen            = NO;
    _originalPlayerViewFrame = _playerView.frame;
    _originalPlayerFrame     = CGRectMake(0,
                                          0,
                                          CGRectGetWidth(_playerView.frame),
                                          CGRectGetHeight(_playerView.frame));
}

- (void)_setupPlayerView {
    QYPlayerController *playerController  = [QYPlayerController sharedInstance];
    playerController.view.backgroundColor = UIColor.redColor;
    [playerController  setPlayerFrame:_originalPlayerFrame];
    [playerController setDelegate:self];
    [_playerView addSubview:playerController.view];
    
}

#pragma mark - IBAction
- (IBAction)stopButtonClicked:(id)sender {
#warning TODO
    debugLog(@"It hasn't been implemented yet");
}

- (IBAction)startButtonClicked:(id)sender {
#warning TODO
    debugLog(@"It hasn't been implemented yet");
}

- (IBAction)fullScreenButtonClicked:(id)sender {
    [self _playerTransfromIntoFullScreen];
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
