//
//  ECAPIManager.h
//  Beacon
//
//  Created by SeaHub on 2017/5/28.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ECReturningVideoType;
@class ECReturningVideo;
typedef void(^VideoTypeSuccessBlock)(NSArray<ECReturningVideoType *> *);
typedef void(^Top5VideosSuccessBlock)(NSArray<ECReturningVideo *> *);
typedef void(^FailureBlock)(NSError *);

@interface ECAPIManager : NSObject

/**
 获得网络请求单例

 @return 网络请求单例
 */
+ (instancetype)sharedManager;

/**
 获得视频分类

 @param successBlock 成功回调函数：返回分类数组
 @param failureBlock 失败回调函数：返回错误信息
 */
- (void)getVideoTypesWithSuccessBlock:(VideoTypeSuccessBlock __nullable)successBlock
                     withFailureBlock:(FailureBlock __nullable)failureBlock;

/**
 获取5部当日视频

 @param types 要获取的类型数组，如 @[@"电影", @"电视剧", @"综艺"]，为空则由后台进行推荐
 @param successBlock 成功回调函数：返回视频数组
 @param failureBlock 失败回调函数：返回错误信息
 */
- (void)getTop5Videos:(NSArray * __nullable)types
     withSuccessBlock:(Top5VideosSuccessBlock __nullable)successBlock
     withFailureBlock:(FailureBlock __nullable)failureBlock;;


@end

NS_ASSUME_NONNULL_END
