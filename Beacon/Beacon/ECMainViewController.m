//
//  ECMainViewController.m
//  Beacon
//
//  Created by SeaHub on 2017/5/20.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECMainViewController.h"
#import "ECReturningVideo.h"
#import "ECMenuViewController.h"
#import "ECCacheAPIHelper.h"
#import "CCDraggableContainer.h"
#import "ECCardView.h"
#import "ECVideoTableViewController.h"
#import "ECAPIManager.h"
#import "IQActivityIndicatorView.h"

#import "Masonry.h"

@interface ECMainViewController ()<CCDraggableContainerDelegate, CCDraggableContainerDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet CCDraggableContainer *container;
@property (nonatomic, copy) NSArray<ECReturningVideo *> *dataSources;
@property (nonatomic, copy) NSArray<ECReturningWatchedVideo *> *watchedVideos;
@property (nonatomic, strong) NSMutableArray<ECReturningVideo *> *likedVideos;
@property (strong, nonatomic)  IQActivityIndicatorView *indicator;

@end

@implementation ECMainViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupShadow:_downButton];
    [self _setupShadow:_upButton];
    [self _setupShadow:_moreButton];
    [self loadDataSourceInBackground];
    [self loadHistoriesInBackground];
    [self loadLikedVideosInBackground];
    self.indicator = [[IQActivityIndicatorView alloc] init];
    self.indicator.color = [UIColor grayColor];
    [self.indicator startAnimating];
    [self.view addSubview:self.indicator];
    self.container.delegate        = self;
    self.container.dataSource      = self;
    self.container.backgroundColor = [UIColor clearColor];
    self.container.alpha           = 0;
    
    self.container.removeFromLeftCallback = ^(NSInteger index, UIView *card) {
        ECCardView *cardView              = (ECCardView *)card;
        ECReturningVideo *delLikedVideo   = self.dataSources[index];
        delLikedVideo.isLiked             = NO;
        [cardView delLiked];
        [[ECAPIManager sharedManager] delLikedVideoWithVideoID:delLikedVideo.a_id
                                              withSuccessBlock:nil
                                              withFailureBlock:nil];
        
        if ([self.likedVideos containsObject:delLikedVideo]) { // Update the datas fetched from network
            [self.likedVideos removeObject:delLikedVideo];
        }
    };
    
    self.container.removeFromRightCallback = ^(NSInteger index, UIView *card) {
        ECCardView *cardView               = (ECCardView *)card;
        ECReturningVideo *likedVideo       = self.dataSources[index];
        likedVideo.isLiked                 = YES;
        [cardView addLiked];
        [[ECAPIManager sharedManager] addLikedVideoWithVideoID:likedVideo.a_id
                                              withSuccessBlock:nil
                                              withFailureBlock:nil];
        
        if (![self.likedVideos containsObject:likedVideo]) { // Update the datas fetched from network
            [self.likedVideos addObject:likedVideo];
        }
    };
    
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.container);
        make.height.width.equalTo(@40);
    }];
}

- (void)loadHistoriesInBackground {
    [[ECAPIManager sharedManager] getPlayedHistroyWithSuccessBlock:^(NSArray<ECReturningWatchedVideo *> * _Nonnull watchedVideos) {
        self.watchedVideos = watchedVideos;
    } withFailureBlock:^(NSError * _Nonnull error) {
        debugLog(@"ErrorOnLoadingHistories: %@", [error description]);
    }];
}

- (void)loadLikedVideosInBackground {
    self.likedVideos = [@[] mutableCopy];
    [[ECAPIManager sharedManager] getLikedVideoWithSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull videos) {
        for (ECReturningVideo *video in videos) {
            [self.likedVideos addObject:video];
        }
        
    } withFailureBlock:^(NSError * _Nonnull error) {
        debugLog(@"ErrorOnLoadingLikedVideos: %@", [error description]);
    }];
}

- (void)loadDataSourceInBackground {
    self.dataSources = @[];
    [ECCacheAPIHelper getTop5VideosFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideo *> * _Nullable cachedVideos) {
        debugLog(@"isCacheHitting: %hhd \n, cachedVideos: %@", isCacheHitting, cachedVideos);
        self.dataSources = cachedVideos;
        [self.container reloadData];
        [UIView animateWithDuration:0.4 animations:^{
            self.indicator.alpha = 0;
            self.container.alpha = 1;
        }];
    }];
}

#pragma mark - IBAction
- (IBAction)downButtonClicked:(id)sender {
    [self.container removeForDirection:CCDraggableDirectionLeft];
}

- (IBAction)upButtonClicked:(id)sender {
    [self.container removeForDirection:CCDraggableDirectionRight];
}

- (IBAction)moreButtonClicked:(id)sender {
    ECMenuViewController *menuViewController  = [[ECMenuViewController alloc] init];
    menuViewController.watchedVideos          = self.watchedVideos;
    menuViewController.likedVideos            = self.likedVideos;
    menuViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    menuViewController.rootVC                 = self;
    
    [self presentViewController:menuViewController animated:YES completion:nil];
}

#pragma mark - Private Methods
- (void)_setupShadow:(UIButton *)button {
    button.layer.shadowOffset      = CGSizeMake(0, 2);
    button.layer.shadowColor       = [UIColor colorWithRed:206 green:206 blue:210 alpha:1].CGColor;
    UIBlurEffect *blur             = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame               = button.frame;
    [button addSubview:effectView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueOfECVideoController]) {
        ECVideoTableViewController *videoController = (ECVideoTableViewController *)segue.destinationViewController;
        videoController.videoOfUserChosen           = (ECReturningVideo *)sender;
    }
}

#pragma mark - CCDraggableContainer DataSource
- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    ECCardView *cardView = [[ECCardView alloc] initWithFrame:draggableContainer.bounds];
    [cardView initialData: self.dataSources[index]];
    return cardView;
}

- (NSInteger)numberOfIndexs {
    return self.dataSources.count;
}

#pragma mark - CCDraggableContainer Delegate
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
    CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
    if (draggableDirection == CCDraggableDirectionLeft) {
        self.downButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (draggableDirection == CCDraggableDirectionRight) {
        self.upButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex {
    [self performSegueWithIdentifier:kSegueOfECVideoController sender:self.dataSources[didSelectIndex]];
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    [draggableContainer reloadData];
}

@end
