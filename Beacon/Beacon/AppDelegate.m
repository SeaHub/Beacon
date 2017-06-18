//
//  AppDelegate.m
//  Beacon
//
//  Created by SeaHub on 2017/5/20.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "AppDelegate.h"
#import "ECNotificationHelper.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@property (nonatomic, strong) ECNotificationHelper *notificationHelper;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self _registerNotification];
    [ECUtil saveUUIDToKeyChain]; // Save UUID
    debugLog(@"UUID: %@", [ECUtil readUUIDFromKeyChain]);
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler {
    if ([shortcutItem.type isEqualToString:@"play"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"play_random_video" object:nil];
    }
}

- (void)_registerNotification {
    [self _registerNotificationCategory];
    self.notificationHelper                                       = [[ECNotificationHelper alloc] init];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self.notificationHelper;
    static NSString *const kIsNotificationAlertShown = @"isNotificationAlertShown";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIsNotificationAlertShown] == nil
        || [[[NSUserDefaults standardUserDefaults] objectForKey:kIsNotificationAlertShown] boolValue] == NO) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ECUtil showCancelAlertWithTitle:@"提示"
                                     withMsg:@"Beacon 接下来将请求您的授权，以通知您获取最新的资讯"
                              withCompletion:^{
                                  
                                  
                                  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                                            forKey:kIsNotificationAlertShown];
                                  
                                  [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNNotificationPresentationOptionSound | UNAuthorizationOptionBadge  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                      
                                      
                                      if (!granted || error) {
                                          debugLog(@"用户不同意授权");
                                      }
                                  }];
                              }];
        });
    }
}
    

- (void)_registerNotificationCategory {
    
    UNNotificationAction *openAppAction = [UNNotificationAction actionWithIdentifier:kECNotificationOpenAppActionIdentifier title:@"打开应用" options:UNNotificationActionOptionForeground];
    UNNotificationAction *cancelAction  = [UNNotificationAction actionWithIdentifier:kECNotificationCancelActionIdentifier title:@"取消" options:UNNotificationActionOptionDestructive];
    UNNotificationCategory *category    = [UNNotificationCategory categoryWithIdentifier:kECNotificationCategoryIdentifier actions:@[openAppAction, cancelAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category, nil]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
