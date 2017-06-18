//
//  ECNotificationHelper.m
//  Beacon
//
//  Created by SeaHub on 2017/6/18.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECNotificationHelper.h"

static NSString *const kECNotificationOpenTypeStrIdentifier     = @"kECNotificationOpenTypeStrIdentifier";
static NSString *const kECNotificationImageAttachmentIdentifier = @"kECNotificationImageAttachmentIdentifier";
NSString *const kECNotificationNormalTypeIdentifier             = @"kECNotificationNormalTypeIdentifier";
NSString *const kECNotificationOpenAppActionIdentifier          = @"kECNotificationOpenAppActionIdentifier";
NSString *const kECNotificationCancelActionIdentifier           = @"kECNotificationCancelActionIdentifier";
NSString *const kECNotificationCategoryIdentifier               = @"kECNotificationCategoryIdentifier";

@implementation ECNotificationHelper

+ (void)sendLocationNotification:(NSString *)title
                       wiithBody:(NSString *)body
                        withType:(NSString *)type
                withTimeInterval:(NSTimeInterval)timeInterval
                      isRepeated:(BOOL)isRepeated
                    withImageURL:(NSURL *)imageURL {
    
    assert(!isRepeated || (isRepeated && timeInterval >= 60));
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title                         = title;
    content.body                          = body;
    content.userInfo                      = @{kECNotificationOpenTypeStrIdentifier: type};
    content.categoryIdentifier            = kECNotificationCategoryIdentifier;
    if (imageURL) {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:kECNotificationImageAttachmentIdentifier URL:imageURL options:nil error:nil];
        content.attachments                  = @[attachment];
    }
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:isRepeated];
    NSString *identifier                       = type;
    UNNotificationRequest *request             = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            debugLog(@"%@", [error description]);
        }
    }];
}

+ (void)cancelUnshownLocalNotification:(NSArray *)types {
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:types];
}

+ (void)removeDisplayedLocalNotification:(NSArray *)types {
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:types];
}

#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionNone);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    
    if ([response.notification.request.content.userInfo[kECNotificationOpenTypeStrIdentifier] isKindOfClass:[NSString class]]) {
        
        completionHandler();
    }

}

@end
