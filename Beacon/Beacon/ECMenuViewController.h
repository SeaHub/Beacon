//
//  ECMenuViewController.h
//  Beacon
//
//  Created by 段昊宇 on 2017/6/8.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECReturningVideoHistory;
@class ECReturningVideo;
@interface ECMenuViewController : UIViewController

@property (nonatomic, strong) NSArray <ECReturningVideoHistory *> *histories;
@property (nonatomic, strong) NSArray <ECReturningVideo *> *likedVideos;

@end
