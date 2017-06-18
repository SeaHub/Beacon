//
//  ECVideoPlayerTableViewCell.h
//  Beacon
//
//  Created by SeaHub on 2017/6/7.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ECVideoPlayerTableViewCell;
@class ECReturningVideo;
@class ECPlayerViewModel;
@protocol ECVideoPlayerTableViewCellDelegate <NSObject>

- (void)videoPlayerCell:(ECVideoPlayerTableViewCell *)cell
        withPlayerModel:(ECPlayerViewModel *)playerViewModel;

@end

@interface ECVideoPlayerTableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) id<ECVideoPlayerTableViewCellDelegate> delegate;

- (void)configureCellWithVideo:(ECReturningVideo *)video;
- (void)transformPlayerIntoFullScreen;
- (void)updateCurrentPlayingStatusWithViewModel:(ECPlayerViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
