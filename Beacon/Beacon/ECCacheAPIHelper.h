//
//  ECCacheAPIHelper.h
//  Beacon
//
//  Created by SeaHub on 2017/5/30.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ECReturningVideoType;
@class ECReturningVideo;
typedef void(^GetTop5VideosFromCacheBlock)(BOOL isCacheHitting, NSArray<ECReturningVideo *> * _Nullable cachedVideos);
typedef void(^GetVideoTypesFromCacheBlock)(BOOL isCacheHitting, NSArray<ECReturningVideoType *> * _Nullable cachedTypes);

@interface ECCacheAPIHelper : NSObject

/**
 从缓存中取出今日推荐的五部视频（工作在后台线程，block 自动切换在主线程执行）
 
 @param isAllowRequestingWhenCacheMisses 当缓存不存在数据时，是否允许请求网络获得数据并放入缓存
 @param block 回调函数：返回是否命中 Cache，以及视频数组
 */
+ (void)getTop5VideosFromCache:(BOOL)isAllowRequestingWhenCacheMisses
             withFinishedBlock:(GetTop5VideosFromCacheBlock)block;

/**
 从缓存中取出视频分类（工作在后台线程，block 自动切换在主线程执行）
 
 @param isAllowRequestingWhenCacheMisses 当缓存不存在数据时，是否允许请求网络获得数据并放入缓存
 @param block 回调函数：返回是否命中 Cache，以及视频类型数组
 */
+ (void)getVideoTypesFromCache:(BOOL)isAllowRequestingWhenCacheMisses
             withFinishedBlock:(GetVideoTypesFromCacheBlock)block;;

@end

NS_ASSUME_NONNULL_END
