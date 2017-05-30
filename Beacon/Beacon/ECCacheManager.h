//
//  ECCacheManager.h
//  Beacon
//
//  Created by SeaHub on 2017/5/30.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CacheSetObjectFinishedBlock)(void);
typedef void(^CacheRemoveObjectFinishedBlock)(NSString *key);
typedef void(^CacheClearObjectsProgressBlock)(int removedCount, int totalCount);
typedef void(^CacheClearObjectsFinishedBlock)(BOOL error);
typedef void(^CacheClearMemoryObjectsFinishedBlock)(void);
typedef void(^CacheClearDiskObjectsFinishedBlock)(void);
typedef void(^CacheObjectForKey)(NSString *key, id<NSCoding> object);

@interface ECCacheManager : NSObject
/**
 存取缓存 - 当 isOnlyMemory == NO 时，更新 UI 需要 dispatch_get_main

 @param object 需要存储的对象
 @param key 缓存对象 Key
 @param isOnlyMemory 是否只存在内存缓存中（YES => 只存在内存缓存）
 @param block 存取完成回调函数
 */
- (void)setObject:(id<NSCoding>)object
           forKey:(NSString *)key
       onlyMemory:(BOOL)isOnlyMemory
withFinishedBlock:(nullable CacheSetObjectFinishedBlock)block;

/**
 清除某个对象缓存 - 更新 UI 时需要 dispatch_get_main

 @param key 缓存对象 Key
 @param block 清除完成回调函数：返回缓存对象 Key
 */
- (void)removeObjectForKey:(NSString *)key
         withFinishedBlock:(nullable CacheRemoveObjectFinishedBlock)block;

/**
 清除所有缓存 - 更新 UI 时需要 dispatch_get_main

 @param progressBlock 清除进度回调函数：返回已清除个数与总个数
 @param finishedBlock 清除完成回调函数：返回是否存在错误（YES => 出现错误）
 */
- (void)clearAllObjectsWithProgressBlock:(nullable CacheClearObjectsProgressBlock)progressBlock
                       withFinishedBlock:(nullable CacheClearObjectsFinishedBlock)finishedBlock;

/**
 清除所有内存缓存

 @param block 清除完成回调函数
 */
- (void)clearAllMemoryObjectsWithFinishedBlock:(nullable CacheClearMemoryObjectsFinishedBlock)block;

/**
 清除所有磁盘缓存 - 更新 UI 时需要 dispatch_get_main

 @param block 清除完成回调函数
 */
- (void)clearAllDiskObjectsWithFinishedBlock:(nullable CacheClearDiskObjectsFinishedBlock)block;

/**
 判断缓存内是否含有对象

 @param key 缓存对象 Key
 @return 是否含有对象
 */
- (BOOL)containsObjectForKey:(NSString *)key;

/**
 返回缓存内的对象 - 更新 UI 时需要 dispatch_get_main

 @param key 缓存对象 Key
 @param block 回调函数：返回缓存对象 Key 与缓存对象
 */
- (void)objectForKey:(NSString *)key withBlock:(CacheObjectForKey)block;

/**
 获取单例对象

 @return 单例对象
 */
+ (instancetype)sharedManager;

@property (nonatomic, copy, nullable, readonly) NSString *diskCachePath;

@end

NS_ASSUME_NONNULL_END
