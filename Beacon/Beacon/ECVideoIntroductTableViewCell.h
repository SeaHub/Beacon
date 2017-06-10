//
//  ECVideoIntroductTableViewCell.h
//  Beacon
//
//  Created by SeaHub on 2017/6/10.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECVideoIntroductTableViewCell : UITableViewCell

- (void)configureCellWithTitle:(NSString *)title
                   withContent:(NSString *)content;

- (void)configureCellWithIntroductionContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
