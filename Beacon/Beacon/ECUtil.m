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

+ (void)showCancelAlertController:(UIViewController *)viewController
                        withTitle:(NSString *)title
                          withMsg:(NSString *)msg {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction            = [UIAlertAction actionWithTitle:@"确定"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:nil];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController
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

@end
