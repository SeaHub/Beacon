//
//  ECMainViewController.m
//  Beacon
//
//  Created by SeaHub on 2017/5/20.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECMainViewController.h"
#import "ECPlayerController.h"

#import "CCDraggableContainer.h"
#import "ECCardView.h"

@interface ECMainViewController ()<CCDraggableContainerDelegate, CCDraggableContainerDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet CCDraggableContainer *container;
@property (nonatomic, copy) NSArray *dataSources;

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
    [self.container reloadData];
}

- (void)loadDatas {
    self.dataSources = @[
                         @"cardA",
                         @"cardB",
                         @"cardC",
                         ];
}

#pragma mark - IBAction
- (IBAction)downButtonClicked:(id)sender {
    debugLog(@"todo");
}

- (IBAction)upButtonClicked:(id)sender {
    debugLog(@"todo");
}

- (IBAction)moreButtonClicked:(id)sender {
    debugLog(@"todo");
    [self performSegueWithIdentifier:kSegueOfECVideoController sender:self];
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
    if ([segue.identifier isEqualToString:kSegueOfECPlayController]) {
        // TO Delete
        ECPlayerController *playerController = (ECPlayerController *)segue.destinationViewController;
        // Here is just a mock
        playerController.contentDict         = @{
            @"a_id": @"677870700",
            @"date_format": @"2017-05-12",
            @"date_timestamp": @"1494604800000",
            @"id": @"677870700",
            @"img": @"http://pic7.qiyipic.com/image/20170513/6d/a6/v_112314044_m_601_m1.jpg",
            @"is_vip": @"0",
            @"p_type": @"1",
            @"play_count": @"5423310",
            @"play_count_text": @"542.3\\U4e07",
            @"short_title": @"\\U9910\\U5385\\U8058\\U6bd4\\U57fa\\U5c3c\\U7f8e\\U5973\\U7aef\\U83dc",
            @"sns_score": @"",
            @"title": @"\\U5357\\U4eac\\U4e00\\U9910\\U5385\\U8058\\U6bd4\\U57fa\\U5c3c\\U7f8e\\U5973\\U7aef\\U83dc \\U8425\\U9500\\U624b\\U6bb5\\U60f9\\U4e89\\U8bae",
            @"total_num": @"1",
            @"tv_id": @"677870700",
            @"type": @"normal",
            @"update_num": @"1",
        };
    }
}

#pragma mark - CCDraggableContainer DataSource

- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    
    ECCardView *cardView = [[ECCardView alloc] initWithFrame:draggableContainer.bounds];
    [cardView initialData:self.dataSources[index]];
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
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    [draggableContainer reloadData];
}

@end
