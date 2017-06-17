//
//  ECMenuViewController.h
//  Beacon
//
//  Created by 段昊宇 on 2017/6/8.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECReturningWatchedVideo;
typedef NS_OPTIONS(NSUInteger, ECMenuType) {
    ECMenuFavouriteType = 0,
    ECMenuHistoryType = 1 
};

@class ECReturningVideoHistory;
@class ECReturningVideo;
@class ECMainViewController;
@interface ECMenuViewController : UIViewController

@property (nonatomic, strong) NSArray <ECReturningWatchedVideo *> *watchedVideos;
@property (nonatomic, strong) NSArray <ECReturningVideo *> *likedVideos;
@property (assign) ECMenuType type;

@property (nonatomic, strong) ECMainViewController *rootVC;

@end
