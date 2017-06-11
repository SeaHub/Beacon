//
//  ECMenuItemTableViewCell.h
//  Beacon
//
//  Created by 段昊宇 on 2017/6/8.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECReturningVideo.h"

@interface ECMenuItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *topLine;

- (void)configureCellByModel: (ECReturningVideo *)video;
@end
