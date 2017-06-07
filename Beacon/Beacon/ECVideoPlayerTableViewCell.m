//
//  ECVideoPlayerTableViewCell.m
//  Beacon
//
//  Created by SeaHub on 2017/6/7.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoPlayerTableViewCell.h"

static NSString *const kECVideoCollectionReuseIdentifier = @"kECVideoCollectionReuseIdentifier";
@interface ECVideoPlayerTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *playerScreen;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resourceTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *resourceTypeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *resourceLikeLabel;
@property (copy, nonatomic) NSArray <NSString *> *resourceTypes;

@end

@implementation ECVideoPlayerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    debugLog(@"playerScreen needs to set up");
    debugLog(@"timeLabel needs to set up");
    self.resourceTypeCollectionView.delegate   = self;
    self.resourceTypeCollectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithTitle:(NSString *)title
                     withTypes:(NSArray<NSString *> *)types
                withLikeNumber:(NSString *)likeNumber {
    
    self.resourceTitleLabel.text = title;
    self.resourceTypes           = types;
    self.resourceLikeLabel.text  = likeNumber;
}

- (IBAction)likeButtonDidClicked:(id)sender {
    debugLog(@"Like Button Clicked");
}

- (IBAction)fullScreenButtonDidClicked:(id)sender {
    debugLog(@"FullScreen Button Clicked");
}

- (IBAction)shareButtonDidClicked:(id)sender {
    debugLog(@"Share Button Clicked");
}

- (IBAction)playButtonDidClicked:(id)sender {
    debugLog(@"Play Button Clicked");
}

#pragma mark - UICollectionView Related
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kECVideoCollectionReuseIdentifier
                                                                           forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    debugLog(@"section: %ld, row: %ld selected", (long)indexPath.section, (long)indexPath.row);
}

@end
