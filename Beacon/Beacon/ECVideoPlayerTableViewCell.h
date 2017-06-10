//
//  ECVideoPlayerTableViewCell.h
//  Beacon
//
//  Created by SeaHub on 2017/6/7.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECVideoPlayerTableViewCell : UITableViewCell

- (void)configureCellWithTitle:(NSString *)title
                     withTypes:(NSArray<NSString *> *)types
                withLikeNumber:(NSString *)likeNumber;

@end

NS_ASSUME_NONNULL_END