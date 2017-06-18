//
//  ECUtil.h
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ECNetworkMonitoringBlock)(void);
typedef void(^ECAlertActionBlock)(void);

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

/**
 在最顶层 Controller 弹出确认提示框
 
 @param title 提示框标题
 @param msg 提示框内容
 @param actionBlock 结束点击动作回调函数
 */
+ (void)showCancelAlertWithTitle:(NSString *)title
                         withMsg:(NSString *)msg
                  withCompletion:(nullable ECAlertActionBlock)actionBlock;

/**
 监控网络状态

 @param errorBlock 网络不可用状态
 @param wwanBlock 网络为流量状态
 @param wifiBlock 网络为 WiFi 状态
 */
+ (void)monitoringNetworkWithErrorBlock:(nullable ECNetworkMonitoringBlock)errorBlock
                          withWWANBlock:(nullable ECNetworkMonitoringBlock)wwanBlock
                          withWiFiBlock:(nullable ECNetworkMonitoringBlock)wifiBlock;

/**
 根据传入的毫秒值生成 HH:MM:SS 格式的时间字符串

 @param timeInterval 毫秒值
 @return HH:MM:SS 格式的时间字符串
 */
+ (NSString *)convertTimeIntervalToDateString:(NSTimeInterval)timeInterval;

/**
 拼接生成'播放器时间戳格式'字符串，'播放器时间戳格式' eg: 00:10:05 / 01:00:00

 @param currentPlayTime 当前播放时间戳
 @param totalTime 总时间戳
 @return '播放器时间戳格式'字符串
 */
+ (NSString *)jointPlayTimeString:(NSTimeInterval)currentPlayTime withTotalTime:(NSTimeInterval)totalTime;

/**
 检查网络状态（若在非 WiFi 状态下会出现弹窗警告）

 @param errorBlock 网络不可用回调函数
 */
+ (void)checkNetworkStatusWithErrorBlock:(nullable ECNetworkMonitoringBlock)errorBlock;

@end

NS_ASSUME_NONNULL_END
