//
//  ECUtil.h
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECUtil : NSObject

+ (void)saveUUIDToKeyChain;
+ (NSString *)readUUIDFromKeyChain;
+ (UIView *)addToPlayEffectView:(UIView *)view;

@end
