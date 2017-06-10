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

#pragma mark - Private Methods

+ (NSString *)_getUUIDString {
    CFUUIDRef uuidRef    = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef   = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

@end
