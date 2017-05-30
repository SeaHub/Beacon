//
//  ECCacheManager.m
//  Beacon
//
//  Created by SeaHub on 2017/5/30.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECCacheManager.h"
#import <YYCache.h>

static ECCacheManager *object = nil;

@interface ECCacheManager() {
    YYCache *_cache;
}
@end

@implementation ECCacheManager

#pragma mark - Cache Methods
- (void)setObject:(id<NSCoding>)object
           forKey:(NSString *)key
       onlyMemory:(BOOL)isOnlyMemory
withFinishedBlock:(CacheSetObjectFinishedBlock)block {
    if (isOnlyMemory) {
        [_cache.memoryCache setObject:object forKey:key];
        block();
    } else {
        [_cache setObject:object forKey:key withBlock:block];
    }
}

- (void)removeObjectForKey:(NSString *)key
         withFinishedBlock:(CacheRemoveObjectFinishedBlock)block {
    [_cache removeObjectForKey:key withBlock:block];
}

- (void)clearAllObjectsWithProgressBlock:(CacheClearObjectsProgressBlock)progressBlock
                       withFinishedBlock:(CacheClearObjectsFinishedBlock)finishedBlock {
    [_cache removeAllObjectsWithProgressBlock:progressBlock endBlock:finishedBlock];
}

- (void)clearAllMemoryObjectsWithFinishedBlock:(CacheClearMemoryObjectsFinishedBlock)block {
    [_cache.memoryCache removeAllObjects];
    if (block) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

- (void)clearAllDiskObjectsWithFinishedBlock:(CacheClearDiskObjectsFinishedBlock)block {
    [_cache.diskCache removeAllObjectsWithBlock:block];
}

- (BOOL)containsObjectForKey:(NSString *)key {
    return [_cache containsObjectForKey:key];
}

- (void)objectForKey:(NSString *)key withBlock:(CacheObjectForKey)block {
    [_cache objectForKey:key withBlock:block];
}

- (NSString *)diskCachePath {
    return _cache.diskCache.path;
}

#pragma mark - Singleton Methods
- (instancetype)init {
    NSAssert(NO, @"Can`t be used for it`s a singleton");
    return nil;
}

- (instancetype)initMethod {
    if (self = [super init]) {
        _cache = [YYCache cacheWithName:kBundleIdentifier];
        _cache.diskCache.autoTrimInterval = NSUIntegerMax;
        return self;
    }
    
    return nil;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[ECCacheManager alloc] initMethod];
    });
    
    return object;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!object) {
        object = [super allocWithZone:zone];
    }
    
    return object;
}

- (id)copyWithZone:(NSZone *)zone {
    return object;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return object;
}

#if __has_feature(objc_arc)
#else
- (instancetype)retain {
    return self;
}

- (instancetype)autorelease {
    return self;
}

- (oneway void)release {
    return;
}

- (NSUInteger)retainCount {
    return UINT_MAX;
}
#endif


@end
