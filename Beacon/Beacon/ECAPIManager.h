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
@class ECReturningWatchedVideo;

typedef void(^VideoTypeSuccessBlock)(NSArray<ECReturningVideoType *> *videoTypes);
typedef void(^Top5VideosSuccessBlock)(NSArray<ECReturningVideo *> *videos);
typedef void(^AddPlayedHistorySuccessBlock)(BOOL isSuccess);
typedef void(^DelPlayedHistorySuccessBlock)(BOOL isSuccess);
typedef void(^VideoHistorySuccessBlock)(NSArray<ECReturningWatchedVideo *> *watchedVideos);
typedef void(^AddLikedVideoSuccessBlock)(BOOL isSuccess);
typedef void(^DelLikedVideoSuccessBlock)(BOOL isSuccess);
typedef void(^LikedVideoSuccessBlock)(NSArray<ECReturningVideo *> *videos);
typedef void(^GuessingVideoSuccessBlock)(NSArray<ECReturningVideo *> *videos);
typedef void(^FailureBlock)(NSError * error);

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
     withFailureBlock:(FailureBlock __nullable)failureBlock;

/**
 添加视频播放记录

 @param videoID 已播放的视频ID
 @param successBlock 成功回调函数：返回添加状态（YES 为添加成功，NO 为添加失败）
 @param failureBlock 失败回调函数
 */
- (void)addPlayedHistoryWithVideoID:(NSString *)videoID
                   withSuccessBlock:(AddPlayedHistorySuccessBlock __nullable)successBlock
                   withFailureBlock:(FailureBlock __nullable)failureBlock;

/**
 删除视频播放记录

 @param videoID 已播放的视频ID
 @param successBlock 成功回调函数：返回添加状态（YES 为删除成功，NO 为删除失败）
 @param failureBlock 失败回调函数
 */
- (void)delPlayedHistoryWithVideoID:(NSString *)videoID
                   withSuccessBlock:(DelPlayedHistorySuccessBlock __nullable)successBlock
                   withFailureBlock:(FailureBlock __nullable)failureBlock;

/**
 查看视频播放记录

 @param successBlock 成功回调函数：返回历史信息数组
 @param failureBlock 失败回调函数
 */
- (void)getPlayedHistroyWithSuccessBlock:(VideoHistorySuccessBlock __nullable)successBlock
                        withFailureBlock:(FailureBlock __nullable)failureBlock;

/**
 添加收藏视频

 @param videoID 视频ID
 @param successBlock 成功回调函数：返回添加状态（YES 为添加成功，NO 为添加失败）
 @param failureBlock 失败回调函数
 */
- (void)addLikedVideoWithVideoID:(NSString *)videoID
                withSuccessBlock:(AddLikedVideoSuccessBlock __nullable)successBlock
                withFailureBlock:(FailureBlock __nullable)failureBlock;

/**
 删除收藏视频

 @param videoID 视频ID
 @param successBlock 成功回调函数：返回添加状态（YES 为删除成功，NO 为删除失败）
 @param failureBlock 失败回调函数
 */
- (void)delLikedVideoWithVideoID:(NSString *)videoID
                withSuccessBlock:(DelLikedVideoSuccessBlock __nullable)successBlock
                withFailureBlock:(FailureBlock __nullable)failureBlock;

/**
 查看收藏视频

 @param successBlock 成功回调函数：返回视频数组
 @param failureBlock 失败回调函数
 */
- (void)getLikedVideoWithSuccessBlock:(LikedVideoSuccessBlock __nullable)successBlock
                     withFailureBlock:(FailureBlock __nullable)failureBlock;

/**
 获取 Guess you like 视频 (相比 GetTop5 接口获取更多数据)

 @param successBlock 成功回调函数：返回视频数组
 @param failureBlock 失败回调函数
 */
- (void)getGuessVideoWithSuccessBlock:(GuessingVideoSuccessBlock __nullable)successBlock
                     withFailureBlock:(FailureBlock __nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
