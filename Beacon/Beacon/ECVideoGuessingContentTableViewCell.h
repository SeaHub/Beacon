//
//  ECVideoGuessingContentTableViewCell.h
//  Beacon
//
//  Created by SeaHub on 2017/6/10.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECVideoGuessingContentTableViewCell : UITableViewCell

- (void)configureCellWithTitle:(NSString *)title
            withImageURLString:(NSString *)imageURL
                     withTypes:(NSArray<NSString *> *)types;

@end

NS_ASSUME_NONNULL_END