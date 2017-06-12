//
//  ECVideoGuessingContentTableViewCell.m
//  Beacon
//
//  Created by SeaHub on 2017/6/10.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoGuessingContentTableViewCell.h"
#import "ECVideoResourceTypeCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "ECReturningVideo.h"

static NSString *const kECVideoGuessingCellCollectionReuseIdentifier = @"GuessingCellCollectionReuseIdentifier";
@interface ECVideoGuessingContentTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *resourceImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *resourceTypeCollectionView;
@property (copy, nonatomic) NSArray<NSString *> *resourceTypes;
@property (strong, nonatomic) ECReturningVideo *video;

@end

@implementation ECVideoGuessingContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _hideSeperate];
    self.resourceTypeCollectionView.delegate   = self;
    self.resourceTypeCollectionView.dataSource = self;
    self.resourceTypes                         = @[];
    [ECUtil addToPlayEffectView:self.resourceImageView];
    [self _addImageViewGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)_hideSeperate {
    CGFloat widthOfInset = [UIScreen mainScreen].bounds.size.width / 2;
    self.separatorInset  = UIEdgeInsetsMake(0, widthOfInset, 0, widthOfInset);
}

- (void)_addImageViewGesture {
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(_videoImageViewDidClicked)];
    tapGR.numberOfTapsRequired              = 1;
    self.resourceImageView.userInteractionEnabled = YES;
    [self.resourceImageView addGestureRecognizer:tapGR];
}

- (void)_videoImageViewDidClicked {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(videoGuessingContentCell:imageViewDidClickedWithVideo:)]) {
            [self.delegate videoGuessingContentCell:self
                       imageViewDidClickedWithVideo:self.video];
        }
    }
}

- (void)configureCellWithVideo:(ECReturningVideo *)video {
    self.video           = video;
    self.titleLabel.text = video.title;
    self.resourceTypes   = @[@"iQiYi"];
    [self.resourceImageView sd_setImageWithURL:[NSURL URLWithString:video.img]];
    [self.resourceTypeCollectionView reloadData];
}

#pragma mark - UICollectionView Related
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ECVideoResourceTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kECVideoGuessingCellCollectionReuseIdentifier forIndexPath:indexPath];
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
