//
//  ECUtil.h
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECUtil : NSObject

/**
 将 UUID 保存至 Keychain => 构造唯一 UUID
 */
+ (void)saveUUIDToKeyChain;

/**
 从 Keychain 读取 UUID 

 @return UUID
 */
+ (NSString *)readUUIDFromKeyChain;

/**
 给 View 增加'播放效果'（添加带有一定灰度的播放 View）

 @param view 要添加效果的 View
 @return 效果 View
 */
+ (UIView *)addToPlayEffectView:(UIView *)view;


/**
 自动计算 Label 高度

 @param text 文本
 @param font 字体
 @param maxSize 大小
 @return 计算尺寸
 */
+ (CGSize)calculateLabelSize:(NSString *)text
                    withFont:(UIFont *)font
                 withMaxSize:(CGSize)maxSize;

@end
