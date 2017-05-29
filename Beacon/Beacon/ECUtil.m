//
//  ECUtil.m
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECUtil.h"
#import "APKeychainItemWrapper.h"

@implementation ECUtil

+ (void)saveUUIDToKeyChain {
    APKeychainItemWrapper *keychainItem = [[APKeychainItemWrapper alloc] initWithAccount:@"Identfier" service:kBundleIdentifier accessGroup:nil];
    NSString *string = [keychainItem objectForKey: (__bridge id)kSecAttrGeneric];
    if([string isEqualToString:@""] || !string){
        [keychainItem setObject:[self getUUIDString] forKey:(__bridge id)kSecAttrGeneric];
    }
}

+ (NSString *)readUUIDFromKeyChain {
    APKeychainItemWrapper *keychainItemm = [[APKeychainItemWrapper alloc] initWithAccount:@"Identfier" service:kBundleIdentifier accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

+ (NSString *)getUUIDString {
    CFUUIDRef uuidRef    = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef   = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

@end
