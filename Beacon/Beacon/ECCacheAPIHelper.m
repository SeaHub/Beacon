//
//  ECCacheAPIHelper.m
//  Beacon
//
//  Created by SeaHub on 2017/5/30.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECCacheAPIHelper.h"
#import "ECAPIManager.h"
#import "ECCacheManager.h"

static NSString *const kTop5VideosCacheIdentifier         = @"kTop5VideosCacheIdentifier";
static NSString *const kTop5VideosTimestampIdentifier     = @"kTop5VideosTimestampIdentifier";
static NSString *const kVideoTypesCacheIdentifier         = @"kVideoTypesCacheIdentifier";
static NSString *const kVideoTypesTimestampIdentifier     = @"kVideoTypesTimestampIdentifier";
static NSTimeInterval  kCacheExpiredTimeInterval          = 60 * 60 * 24; // 缓存有效期

typedef void(^GetTimestampOfExistedCacheBlock)(NSTimeInterval timestamp);
typedef void(^SetTimestampOfExistedCacheBlock)(BOOL isSuccess);

@implementation ECCacheAPIHelper
+ (void)getTop5VideosFromCache:(BOOL)isAllowRequestingWhenCacheMisses
             withFinishedBlock:(GetTop5VideosFromCacheBlock)block {
    
    if ([[ECCacheManager sharedManager] containsObjectForKey:kTop5VideosTimestampIdentifier]) {
        // 首先判断是否含有该缓存的时间戳 => 有则继续，无则试图发起网络请求（Work in background queue）
        [self _getTimestampOfExistedCache:kTop5VideosTimestampIdentifier
                        withFinishedBlock:^(NSTimeInterval timestamp) {
                            
                            if ([self _isTimestampOverLimitedTimeInterval:timestamp]) {
                                // 超出缓存有效期，缓存不命中，发起网络请求
                                
                                if (isAllowRequestingWhenCacheMisses) { // 若允许发起网络请求，并写入缓存
                                    [[ECAPIManager sharedManager] getTop5Videos:@[@"电影"] withSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
                                        
                                        // 写缓存
                                        [[ECCacheManager sharedManager] setObject:models forKey:kTop5VideosCacheIdentifier onlyMemory:NO withFinishedBlock:^{
                                            // 写时间戳
                                            [self _setTimestampOfExistedCache:kTop5VideosTimestampIdentifier withTimestamp:[[NSDate date] timeIntervalSince1970] withFinishedBlock:^(BOOL isSuccess) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    block(NO, models);
                                                });
                                            }];
                                        }];
                                        
                                    } withFailureBlock:^(NSError * _Nonnull error) {
                                        debugLog(@"%@", [error description]);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            block(NO, nil);
                                        });
                                    }];
                                    
                                } else { // 不允许发起网络请求，返回空
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        block(NO, nil);
                                    });
                                }
                                
                            } else { // 没有超出有效期，从缓存中读取数据，但不刷新缓存有效期
                                [[ECCacheManager sharedManager] objectForKey:kTop5VideosCacheIdentifier withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        block(YES, (NSArray *)object);
                                    });
                                }];
                            }
                        }];
    } else {
        if (isAllowRequestingWhenCacheMisses) { // 若允许发起网络请求，并写入缓存
            [[ECAPIManager sharedManager] getTop5Videos:@[@"电影"] withSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
                
                // 写缓存
                [[ECCacheManager sharedManager] setObject:models forKey:kTop5VideosCacheIdentifier onlyMemory:NO withFinishedBlock:^{
                    // 写时间戳
                    [self _setTimestampOfExistedCache:kTop5VideosTimestampIdentifier withTimestamp:[[NSDate date] timeIntervalSince1970] withFinishedBlock:^(BOOL isSuccess) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(NO, models);
                        });
                    }];
                }];
                
            } withFailureBlock:^(NSError * _Nonnull error) {
                debugLog(@"%@", [error description]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO, nil);
                });
            }];
            
        } else { // 不允许发起网络请求，返回空
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO, nil);
            });
        }
    }
}

+ (void)getVideoTypesFromCache:(BOOL)isAllowRequestingWhenCacheMisses
             withFinishedBlock:(GetVideoTypesFromCacheBlock)block {
    if ([[ECCacheManager sharedManager] containsObjectForKey:kVideoTypesTimestampIdentifier]) {
        // 首先判断是否含有该缓存的时间戳 => 有则继续，无则试图发起网络请求（Work in background queue）
        [self _getTimestampOfExistedCache:kVideoTypesTimestampIdentifier
                        withFinishedBlock:^(NSTimeInterval timestamp) {
                            
                            if ([self _isTimestampOverLimitedTimeInterval:timestamp]) {
                                // 超出缓存有效期，缓存不命中，发起网络请求
                                if (isAllowRequestingWhenCacheMisses) { // 若允许发起网络请求，并写入缓存
                                    [[ECAPIManager sharedManager] getVideoTypesWithSuccessBlock:^(NSArray<ECReturningVideoType *> * _Nonnull models) {
                                        
                                        [[ECCacheManager sharedManager] setObject:models forKey:kVideoTypesCacheIdentifier onlyMemory:NO withFinishedBlock:^{
                                            // 写时间戳
                                            [self _setTimestampOfExistedCache:kVideoTypesTimestampIdentifier withTimestamp:[[NSDate date] timeIntervalSince1970] withFinishedBlock:^(BOOL isSuccess) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    block(NO, models);
                                                });
                                            }];
                                        }];
                                        
                                    } withFailureBlock:^(NSError * _Nonnull error) {
                                        debugLog(@"%@", [error description]);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            block(NO, nil);
                                        });
                                    }];
                                    
                                } else { // 不允许发起网络请求，返回空
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        block(NO, nil);
                                    });
                                }
                                
                            } else { // 没有超出有效期，从缓存中读取数据，但不刷新缓存有效期
                                [[ECCacheManager sharedManager] objectForKey:kVideoTypesCacheIdentifier withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        block(YES, (NSArray *)object);
                                    });
                                }];
                            }
        }];
        
    } else {
        if (isAllowRequestingWhenCacheMisses) { // 若允许发起网络请求，并写入缓存
            [[ECAPIManager sharedManager] getVideoTypesWithSuccessBlock:^(NSArray<ECReturningVideoType *> * _Nonnull models) {
                
                [[ECCacheManager sharedManager] setObject:models forKey:kVideoTypesCacheIdentifier onlyMemory:NO withFinishedBlock:^{
                    // 写时间戳
                    [self _setTimestampOfExistedCache:kVideoTypesTimestampIdentifier withTimestamp:[[NSDate date] timeIntervalSince1970] withFinishedBlock:^(BOOL isSuccess) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(NO, models);
                        });
                    }];
                }];
                
            } withFailureBlock:^(NSError * _Nonnull error) {
                debugLog(@"%@", [error description]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO, nil);
                });
            }];
        } else { // 不允许发起网络请求，返回空
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO, nil);
            });
        }
    }
}

#pragma mark - Private Methods
+ (void)_setTimestampOfExistedCache:(NSString *)cacheIdentifier
                      withTimestamp:(NSTimeInterval)timestamp
                  withFinishedBlock:(SetTimestampOfExistedCacheBlock)block {
    
    [[ECCacheManager sharedManager] setObject:[NSNumber numberWithDouble:timestamp]
                                       forKey:cacheIdentifier onlyMemory:NO
                            withFinishedBlock:^{
        block(YES);
    }];
}

+ (void)_getTimestampOfExistedCache:(NSString *)cacheIdentifier
                  withFinishedBlock:(GetTimestampOfExistedCacheBlock)block {
    
    [[ECCacheManager sharedManager] objectForKey:cacheIdentifier
                                       withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {

        NSTimeInterval timestamp = [(NSNumber *)object doubleValue];
        block(timestamp);
    }];
}

+ (BOOL)_isTimestampOverLimitedTimeInterval:(NSTimeInterval)timestamp {
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    return (current - timestamp) > kCacheExpiredTimeInterval;
}

@end
