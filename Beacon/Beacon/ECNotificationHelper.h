//
//  ECNotificationHelper.h
//  Beacon
//
//  Created by SeaHub on 2017/6/18.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kECNotificationNormalTypeIdentifier;
extern NSString *const kECNotificationOpenAppActionIdentifier;
extern NSString *const kECNotificationCancelActionIdentifier;
extern NSString *const kECNotificationCategoryIdentifier;

@interface ECNotificationHelper : NSObject <UNUserNotificationCenterDelegate>

@property (nonatomic, assign) BOOL isUserGranted;

+ (void)sendLocationNotification:(NSString *)title
                       wiithBody:(NSString *)body
                        withType:(NSString *)type
                withTimeInterval:(NSTimeInterval)timeInterval
                      isRepeated:(BOOL)isRepeated
                    withImageURL:(nullable NSURL *)imageURL;

+ (void)cancelUnshownLocalNotification:(NSArray *)types;

+ (void)removeDisplayedLocalNotification:(NSArray *)types;

@end

NS_ASSUME_NONNULL_END
