//
//  ECVideoGuessingContentTableViewCell.h
//  Beacon
//
//  Created by SeaHub on 2017/6/10.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ECVideoGuessingContentTableViewCell;
@class ECReturningVideo;
@protocol ECVideoGuessingContentCellDelegate <NSObject>

- (void)videoGuessingContentCell:(ECVideoGuessingContentTableViewCell *)cell
    imageViewDidClickedWithVideo:(ECReturningVideo *)video;

@end

@interface ECVideoGuessingContentTableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) id<ECVideoGuessingContentCellDelegate> delegate;

- (void)configureCellWithVideo:(ECReturningVideo *)video;

@end

NS_ASSUME_NONNULL_END
