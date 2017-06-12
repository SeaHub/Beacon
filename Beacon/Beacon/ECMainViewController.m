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

@interface ECMainViewController ()<CCDraggableContainerDelegate, CCDraggableContainerDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet CCDraggableContainer *container;
@property (nonatomic, copy, nonnull) NSArray<ECReturningVideo *> *dataSources;

@end

@implementation ECMainViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupShadow:_downButton];
    [self _setupShadow:_upButton];
    [self _setupShadow:_moreButton];
    
    // Draggable Container
    [self loadDatas];
    
    self.container.delegate = self;
    self.container.dataSource = self;
    self.container.backgroundColor = [UIColor clearColor];
    
    self.container.removeFromLeftCallback = ^(NSInteger index, UIView *card) {
        ECCardView *cardView = (ECCardView *)card;
        self.dataSources[index].isLove = NO;
        [cardView setCancelLove];
    };
    
    self.container.removeFromRightCallback = ^(NSInteger index, UIView *card) {
        ECCardView *cardView = (ECCardView *)card;
        self.dataSources[index].isLove = YES;
        [cardView setIsLove];
        NSString *videoId = self.dataSources[index].a_id;
        [[ECAPIManager sharedManager] addLikedVideoWithVideoID:videoId withSuccessBlock:^(BOOL success) {
            
        } withFailureBlock:^(NSError * _Nonnull error) {
            
        }];
    };
    [self.container reloadData];
}

- (void)loadDatas {
    self.dataSources = @[];
    [ECCacheAPIHelper getTop5VideosFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideo *> * _Nullable cachedVideos) {
        debugLog(@"%hhd %@", isCacheHitting, cachedVideos);
        self.dataSources = cachedVideos;
        [self.container reloadData];
    }];
    
}

#pragma mark - IBAction
- (IBAction)downButtonClicked:(id)sender {
    debugLog(@"Down");
    [self.container removeForDirection:CCDraggableDirectionLeft];
}

- (IBAction)upButtonClicked:(id)sender {
    debugLog(@"todo");
    [self.container removeForDirection:CCDraggableDirectionRight];
}

- (IBAction)moreButtonClicked:(id)sender {
    debugLog(@"Menu controller");
    ECMenuViewController *menuVC = [ECMenuViewController new];
//    menuVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:menuVC animated:YES completion:nil];
}

#pragma mark - Private Methods
- (void)_setupShadow:(UIButton *)button {
    button.layer.shadowOffset = CGSizeMake(0, 2);
    button.layer.shadowColor  = [UIColor colorWithRed:206 green:206 blue:210 alpha:1].CGColor;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame   = button.frame;
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
    
    NSLog(@"点击了Tag为%ld的Card", (long)didSelectIndex);
    [self performSegueWithIdentifier:kSegueOfECVideoController sender:self.dataSources[didSelectIndex]];
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    [draggableContainer reloadData];
}

@end
