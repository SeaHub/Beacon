//
//  ECUtil.m
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECUtil.h"
#import "APKeychainItemWrapper.h"
#import <Masonry.h>
#import <AFNetworkReachabilityManager.h>

@implementation ECUtil

+ (void)saveUUIDToKeyChain {
    APKeychainItemWrapper *keychainItem = [[APKeychainItemWrapper alloc] initWithAccount:@"Identfier" service:kBundleIdentifier accessGroup:nil];
    NSString *string = [keychainItem objectForKey: (__bridge id)kSecAttrGeneric];
    if([string isEqualToString:@""] || !string){
        [keychainItem setObject:[self _getUUIDString] forKey:(__bridge id)kSecAttrGeneric];
    }
}

+ (NSString *)readUUIDFromKeyChain {
    APKeychainItemWrapper *keychainItemm = [[APKeychainItemWrapper alloc] initWithAccount:@"Identfier" service:kBundleIdentifier accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

+ (UIView *)addToPlayEffectView:(UIView *)view {
    UIView *effectView         = [[UIView alloc] init];
    effectView.frame           = view.bounds;
    effectView.backgroundColor = [UIColor blackColor];
    effectView.alpha           = 0.6;
    
    UIImageView *playButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
    playButtonImageView.alpha        = 0.4;
    
    [effectView addSubview:playButtonImageView];
    [view addSubview:effectView];
    [playButtonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.width.equalTo(view.mas_width).multipliedBy(0.3);
        make.height.equalTo(view.mas_width).multipliedBy(0.3);
    }];
    
    return effectView;
}

+ (CGSize)calculateLabelSize:(NSString *)text
                    withFont:(UIFont *)font
                 withMaxSize:(CGSize)maxSize {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode            = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize: maxSize
                                          options: NSStringDrawingUsesLineFragmentOrigin |
                                                    NSStringDrawingUsesFontLeading |
                                                    NSStringDrawingTruncatesLastVisibleLine
                                       attributes:attributes
                                          context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width  = ceil(labelSize.width);
    return labelSize;
}

+ (void)showCancelAlertWithTitle:(NSString *)title
                         withMsg:(NSString *)msg
                  withCompletion:(ECAlertActionBlock)actionBlock {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction            = [UIAlertAction actionWithTitle:@"确定"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    if (actionBlock) {
                                                                        actionBlock();
                                                                    }
                                                                }];
    [alertController addAction:okAction];
    UIWindow *keyWindow                  = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = keyWindow.rootViewController;
    [rootViewController presentViewController:alertController
                                 animated:YES
                               completion:nil];
}

#pragma mark - Private Methods
+ (NSString *)_getUUIDString {
    CFUUIDRef uuidRef    = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef   = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

+ (void)monitoringNetworkWithErrorBlock:(ECNetworkMonitoringBlock)errorBlock
                          withWWANBlock:(ECNetworkMonitoringBlock)wwanBlock
                          withWiFiBlock:(ECNetworkMonitoringBlock)wifiBlock {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown: {
                [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                if (errorBlock) {
                    errorBlock();
                }
            } break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                if (wwanBlock) {
                    wwanBlock();
                }
            } break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                if (wifiBlock) {
                    wifiBlock();
                }
            } break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (NSString *)convertTimeIntervalToDateString:(NSTimeInterval)timeInterval {
    NSInteger interval = (NSInteger)timeInterval;
    NSInteger seconds  = interval % 60;
    NSInteger minutes  = (interval / 60) % 60;
    NSInteger hours    = (interval / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

+ (NSString *)jointPlayTimeString:(NSTimeInterval)currentPlayTime withTotalTime:(NSTimeInterval)totalTime {
    NSString *currentPlayTimeString = [ECUtil convertTimeIntervalToDateString:currentPlayTime];
    NSString *totalPlayTimeString   = [ECUtil convertTimeIntervalToDateString:totalTime];
    return [NSString stringWithFormat:@"%@ / %@", currentPlayTimeString, totalPlayTimeString];
}

+ (void)checkNetworkStatusWithErrorBlock:(ECNetworkMonitoringBlock)errorBlock
                        withSuccessBlock:(ECNetworkMonitoringBlock)successBlock {
    [ECUtil monitoringNetworkWithErrorBlock:^{
        [ECUtil showCancelAlertWithTitle:@"提示" withMsg:@"网络连接错误，请检查您的网络设置" withCompletion:^{
            if (errorBlock) {
                errorBlock();
            }
        }];
    } withWWANBlock:^{
        [ECUtil showCancelAlertWithTitle:@"提示"
                                 withMsg:@"观看视频可能会消耗大量流量，建议您在 WiFi 状态下观看"
                          withCompletion:^{
                              if (successBlock) {
                                  successBlock();
                              }
                          }];
    } withWiFiBlock:^{
        if (successBlock) {
            successBlock();
        }
    }];
}

@end
