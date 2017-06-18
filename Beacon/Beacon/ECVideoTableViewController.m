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

static const NSUInteger kNumberOfNoneGuessingContentCell           = 3;
static NSString *const kECVideoTablePlayerReuseIdentifier          = @"kECVideoTablePlayerReuseIdentifier";
static NSString *const kECVideoTableEmptyCellReuseIdentifier       = @"kECVideoTableEmptyCellReuseIdentifier";
static NSString *const kECVideoTableIntroductReuseIdentifier       = @"kECVideoTableIntroductReuseIdentifier";
static NSString *const kECVideoTableGuessingLabelReuseIdentifier   = @"kECVideoTableGuessingLabelReuseIdentifier";
static NSString *const kECVideoTableGuessingContentReuseIdentifier = @"kECVideoTableGuessingContentReuseIdentifier";

@interface ECVideoTableViewController () <ECVideoGuessingContentCellDelegate, ECVideoPlayerTableViewCellDelegate, ECFullScreenPlayerControllerDelegate>

@property (nonatomic, assign) BOOL isLightClosed;
@property (nonatomic, assign) BOOL isVideoSwapped;
@property (nonatomic, strong) UIColor *originSeparatorColor;
@property (nonatomic, assign) NSInteger numberOfRowsInSectionZero;
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;
@property (nonatomic, strong) NSMutableArray<ECReturningVideo *> *guessingDatas;
@property (nonatomic, strong) ECVideoPlayerTableViewCell *playerCell; // Retain and not reuse it

@end

@implementation ECVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupShaking];
    [self _setupDoubleTapGesture];
    [self _initialGuessingDatas];
    [ECUtil checkNetworkStatusWithErrorBlock:nil withSuccessBlock:nil];
}

- (void)_initialPropertyStatus {
    self.numberOfRowsInSectionZero = kNumberOfNoneGuessingContentCell;
    self.isLightClosed             = NO;
    self.isVideoSwapped            = NO;
    self.originSeparatorColor      = self.tableView.separatorColor;
}

- (void)_initialGuessingDatas {
    self.guessingDatas = [@[] mutableCopy];
    [ECCacheAPIHelper getTop5VideosFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideo *> * _Nullable cachedVideos) {
        
        for (ECReturningVideo *video in cachedVideos) {
            if (![video isEqual:self.videoOfUserChosen]) {
                [self.guessingDatas addObject:video];
            }
        }
        self.numberOfRowsInSectionZero = kNumberOfNoneGuessingContentCell + self.guessingDatas.count;
        [self.tableView reloadData];
    }];
}

- (void)_setupShaking {
    [self becomeFirstResponder];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
}

- (void)_setupDoubleTapGesture {
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(_viewDidDoubleClicked)];
    tapGR.numberOfTapsRequired    = 2;
    [self.tableView addGestureRecognizer:tapGR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Related
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRowsInSectionZero; // The value will be different in Normal Status、Light-Closed Status
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (!self.isLightClosed) { // Normal Status
        if (indexPath.row == 0) {
            if (!self.playerCell || self.isVideoSwapped) {
                self.playerCell = [tableView dequeueReusableCellWithIdentifier:kECVideoTablePlayerReuseIdentifier
                                                                  forIndexPath:indexPath];
                self.playerCell.delegate = self;
                self.isVideoSwapped      = NO;
            }
            
            [self.playerCell configureCellWithVideo:self.videoOfUserChosen];
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                debugLog(@"3d touch");
            }
            
            return self.playerCell;
            
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
                ECReturningVideo *cellData   = self.guessingDatas[indexPath.row - kNumberOfNoneGuessingContentCell];
                guessingContentCell.delegate = self;
                [guessingContentCell configureCellWithVideo:cellData];
            }
            
            return guessingContentCell;
        }
        
    } else { // Light-Closed Status
        if (indexPath.row == 0) {
            UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:kECVideoTableEmptyCellReuseIdentifier forIndexPath:indexPath];
            return emptyCell;
            
        } else if (indexPath.row == 1) {
            if (!self.playerCell || self.isVideoSwapped) {
                self.playerCell = [tableView dequeueReusableCellWithIdentifier:kECVideoTablePlayerReuseIdentifier
                                                                  forIndexPath:indexPath];
                self.playerCell.delegate = self;
                self.isVideoSwapped      = NO;
            }
            
            [self.playerCell configureCellWithVideo:self.videoOfUserChosen];
            return self.playerCell;
        }   
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    if (!self.isLightClosed) { // Normal Status
        switch (indexPath.row) {
            case 0:
                height = 366 + [self _calculateSizeWithString:self.videoOfUserChosen.short_title
                                                 withFontSize:20];
                break;
            case 1:
                height = 60.0 + [self _calculateSizeWithString:self.videoOfUserChosen.title
                                                  withFontSize:15];
                break;
            case 2:
                height = 31.5;
                break;
            default:
                height = 120.0;
                break;
        }
        
    } else { // Light-Closed Status
        switch (indexPath.row) {
            case 0:
                height = 0.23 * [UIScreen mainScreen].bounds.size.height; // 0.23 is a magic number testing constantly
                break;
            case 1:
                height = 366 + [self _calculateSizeWithString:self.videoOfUserChosen.short_title
                                                 withFontSize:20];
                break;
        }
    }
    
    return height;
}

- (CGFloat)_calculateSizeWithString:(NSString *)string withFontSize:(CGFloat)fontSize {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize newSize      = [ECUtil calculateLabelSize:string
                                            withFont:[UIFont systemFontOfSize:fontSize]
                                         withMaxSize:CGSizeMake(screenWidth - 42, CGFLOAT_MAX)];
    return newSize.height;
}

#pragma mark - Button Action
- (IBAction)backButtonClicked:(id)sender {
    [[QYPlayerController sharedInstance] stopPlayer];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ECVideoGuessingContentCellDelegate
- (void)videoGuessingContentCell:(ECVideoGuessingContentTableViewCell *)cell
    imageViewDidClickedWithVideo:(ECReturningVideo *)video {
    
    NSIndexPath *indexPathOfClickedCell   = [self.tableView indexPathForCell:cell];
    NSIndexPath *indexPathOfPlayerCell    = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPathOfIntroductCell = [NSIndexPath indexPathForRow:1 inSection:0];
    
    // Swap data source and change flag
    self.guessingDatas[indexPathOfClickedCell.row - kNumberOfNoneGuessingContentCell] = self.videoOfUserChosen;
    self.videoOfUserChosen                                                            = video;
    self.isVideoSwapped                                                               = YES;
    
    // Reload data with animation and scroll to top (Not use pushing controller because we afraid stack overflow happens)
    [self.tableView reloadRowsAtIndexPaths:@[indexPathOfClickedCell, indexPathOfPlayerCell, indexPathOfIntroductCell]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPathOfPlayerCell
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

#pragma mark - ECVideoPlayerTableViewCellDelegate
- (void)videoPlayerCell:(ECVideoPlayerTableViewCell *)cell withPlayerModel:(ECPlayerViewModel *)playerViewModel {
    UIStoryboard *storyBoard                       = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ECFullScreenPlayerController *playerController = [storyBoard instantiateViewControllerWithIdentifier:kFullScreenPlayerStoryboardIdentifier];
    playerController.viewModel                     = playerViewModel;
    playerController.delegate                      = self;
    [self presentViewController:playerController animated:YES completion:nil];
}

#pragma mark - ECFullScreenPlayerControllerDelegate
- (void)fullScreenController:(UIViewController *)controller
  viewWillDisappearWithModel:(ECPlayerViewModel *)viewModel {
    
    NSIndexPath *playerIndexPath           = [NSIndexPath indexPathForRow:0 inSection:0];
    ECVideoPlayerTableViewCell *playerCell = [self.tableView cellForRowAtIndexPath:playerIndexPath];
    [playerCell updateCurrentPlayingStatusWithViewModel:viewModel];
}

#pragma mark - Shaking devices
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self.playerCell transformPlayerIntoFullScreen];
}

#pragma mark - Light Closing
- (void)_closeLight {
    // Calculate which cell should be reload, don't reload player cell or it will miss all status of player cell
    NSMutableArray<NSIndexPath *> *indexPaths = [@[] mutableCopy];
    NSIndexPath *indexPathOfEmptyCell         = [NSIndexPath indexPathForRow:0 inSection:0];
    for (int i = 1; i < self.guessingDatas.count + kNumberOfNoneGuessingContentCell; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    // Must update status first because it will be related to cell rendering
    BOOL oldStatus     = self.isLightClosed;
    self.isLightClosed = !self.isLightClosed;
    
    if (!oldStatus) {
        [self.tableView beginUpdates];
        self.numberOfRowsInSectionZero = 2;
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:@[indexPathOfEmptyCell] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.backgroundColor = [UIColor blackColor];
            self.tableView.separatorColor  = [UIColor blackColor];
        }];
        
    } else {
        [self.tableView beginUpdates];
        self.numberOfRowsInSectionZero = kNumberOfNoneGuessingContentCell + self.guessingDatas.count;
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathOfEmptyCell] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.backgroundColor = [UIColor whiteColor];
            self.tableView.separatorColor  = self.originSeparatorColor;
        }];
    }
    
    [self.playerCell transformBackgroundColor:!oldStatus];
}

- (void)_viewDidDoubleClicked {
    [self _closeLight];
}

#pragma mark - Special For 3D Touch
- (ECReturningVideo *)_getRandomVideoFromStaticAppVideos {
#warning TODO - should provide some static JSON datas in main bundle
    NSInteger const kNumberOfStaticJSON = 0; // should be modify to number of static data
    NSMutableArray <NSDictionary *> *staticJSONDatas = [@[] mutableCopy];
    
    for (NSInteger i = 0; i < kNumberOfStaticJSON; ++i) {
        NSBundle *bundle   = [NSBundle mainBundle];
        NSString *filename = [NSString stringWithFormat:@"StaticJSON%d", i];
        NSString *path     = [bundle pathForResource:filename ofType:nil];
        NSDictionary *JSON = [NSDictionary dictionaryWithContentsOfFile:path];
        
        [staticJSONDatas addObject:JSON];
    }
    
    NSInteger randomNumber = arc4random() % staticJSONDatas.count; // create randomNumber in [0, staticDatas.count)
    return [[ECReturningVideo alloc] initWithJSON:staticJSONDatas[randomNumber]];
}

- (void)enterFullScreenFromAppStart {
    ECReturningVideo  *video     = [self _getRandomVideoFromStaticAppVideos];
    ECPlayerViewModel *viewModel = [[ECPlayerViewModel alloc] initWithReturningVideo:video
                                                                     withCurrentTime:0
                                                                       withTotalTime:0
                                                                       withMuteStaus:NO
                                                                   withPlayingStatus:YES];
    UIStoryboard *storyBoard                       = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ECFullScreenPlayerController *playerController = [storyBoard instantiateViewControllerWithIdentifier:kFullScreenPlayerStoryboardIdentifier];
    playerController.viewModel                     = viewModel;
    playerController.delegate                      = self;
    [self presentViewController:playerController animated:YES completion:nil];
}

@end
