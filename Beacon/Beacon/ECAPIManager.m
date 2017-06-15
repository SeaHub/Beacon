//
//  ECAPIManager.m
//  Beacon
//
//  Created by SeaHub on 2017/5/28.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECAPIManager.h"
#import <AFNetworking.h>
#import "ECReturningVideoType.h"
#import "ECReturningVideo.h"
#import "ECReturningVideoHistory.h"

static NSString *const kBaseURLString    = @"https://beacon-flask.herokuapp.com";
static const int kNetworkTimeoutInterval = 20;
static ECAPIManager *object              = nil;
static NSString *const kDatasKey         = @"datas";
static NSString *const kDataKey          = @"data";
static NSString *const kErrorCodeKey     = @"code";
static NSString *const kErrorCodeMsgKey  = @"msg";

@interface ECAPIManager () {
    AFHTTPSessionManager *_manager;
}

@end

@implementation ECAPIManager

#pragma mark - Network Methods
- (void)getVideoTypesWithSuccessBlock:(VideoTypeSuccessBlock)successBlock
                     withFailureBlock:(FailureBlock)failureBlock {
    [_manager GET:@"/beacon/v2/types" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"RawValue: %@", responseObject);
        NSDictionary *JSON           = responseObject;
        NSArray *dataJSONs           = JSON[kDatasKey];
        NSMutableArray *returnModels = [@[] mutableCopy];
    
        for (NSDictionary *dataJSON in dataJSONs) {
            ECReturningVideoType *model = [[ECReturningVideoType alloc] initWithJSON:dataJSON];
            [returnModels addObject:model];
        }
        
        if (successBlock) {
            successBlock(returnModels);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"Network error: %@", [error description]);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)getTop5Videos:(NSArray * __nullable)types
     withSuccessBlock:(Top5VideosSuccessBlock)successBlock
     withFailureBlock:(FailureBlock)failureBlock {
    if (types == nil) { // excute getting
        // Test API
        [_manager GET:@"/beacon/test/top5" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            debugLog(@"RawValue: %@", responseObject);
            NSDictionary *JSON           = responseObject;
            NSArray *dataJSONs           = JSON[kDatasKey];
            NSMutableArray *returnModels = [@[] mutableCopy];
            
            for (NSDictionary *dataJSON in dataJSONs) {
                ECReturningVideo *model = [[ECReturningVideo alloc] initWithJSON:dataJSON];
                [returnModels addObject:model];
            }
            
            if (successBlock) {
                successBlock(returnModels);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            debugLog(@"Network error: %@", [error description]);
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    
    } else { // contains types, excute posting
        NSDictionary *params = @{ @"types": types };
        [_manager POST:@"/beacon/v2/top5" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            debugLog(@"RawValue: %@", responseObject);
            NSDictionary *JSON           = responseObject;
            NSArray *dataJSONs           = JSON[kDatasKey];
            NSMutableArray *returnModels = [@[] mutableCopy];
            
            for (NSDictionary *dataJSON in dataJSONs) {
                ECReturningVideo *model = [[ECReturningVideo alloc] initWithJSON:dataJSON];
                [returnModels addObject:model];
            }
            
            if (successBlock) {
                successBlock(returnModels);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            debugLog(@"Network error: %@", [error description]);
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}

- (void)addPlayedHistoryWithVideoID:(NSString *)videoID
                   withSuccessBlock:(AddPlayedHistorySuccessBlock)successBlock
                   withFailureBlock:(FailureBlock)failureBlock {
    NSDictionary *params = @{ @"uuid": [ECUtil readUUIDFromKeyChain], @"video_id": videoID };
    [_manager POST:@"/beacon/v2/add_play_history" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"RawValue: %@", responseObject);
        NSDictionary *JSON           = responseObject;
        NSNumber *errorCode          = JSON[kErrorCodeKey];
        
        if ([errorCode unsignedIntegerValue] == 200) {
            if (successBlock) {
                successBlock(YES);
            }
            
        } else {
            if (successBlock) {
                successBlock(NO);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"Network error: %@", [error description]);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)delPlayedHistoryWithVideoID:(NSString *)videoID
                   withSuccessBlock:(DelLikedVideoSuccessBlock)successBlock
                   withFailureBlock:(FailureBlock)failureBlock {
    NSDictionary *params = @{ @"uuid": [ECUtil readUUIDFromKeyChain], @"video_id": videoID };
    [_manager POST:@"/beacon/v2/del_play_history" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"RawValue: %@", responseObject);
        NSDictionary *JSON           = responseObject;
        NSNumber *errorCode          = JSON[kErrorCodeKey];
        
        if ([errorCode unsignedIntegerValue] == 200) {
            if (successBlock) {
                successBlock(YES);
            }
            
        } else {
            if (successBlock) {
                successBlock(NO);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"Network error: %@", [error description]);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)getPlayedHistroyWithSuccessBlock:(VideoHistorySuccessBlock)successBlock
                        withFailureBlock:(FailureBlock)failureBlock {
    NSString *getAddress = [NSString stringWithFormat:@"/beacon/v2/get_play_history/%@",
                            [ECUtil readUUIDFromKeyChain]];
    [_manager GET:getAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"RawValue: %@", responseObject);
        NSDictionary *JSON           = responseObject;
        NSArray *dataJSONs           = JSON[kDataKey];
        NSMutableArray *returnModels = [@[] mutableCopy];
        
        for (NSDictionary *dataJSON in dataJSONs) {
            ECReturningVideoHistory *model = [[ECReturningVideoHistory alloc] initWithJSON:dataJSON];
            [returnModels addObject:model];
        }
        
        if (successBlock) {
            successBlock(returnModels);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"Network error: %@", [error description]);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)addLikedVideoWithVideoID:(NSString *)videoID
                withSuccessBlock:(AddLikedVideoSuccessBlock)successBlock
                withFailureBlock:(FailureBlock)failureBlock {
    NSDictionary *params = @{ @"uuid": [ECUtil readUUIDFromKeyChain], @"video_id": videoID };
    [_manager POST:@"/beacon/v2/add_like_video" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"RawValue: %@", responseObject);
        NSDictionary *JSON           = responseObject;
        NSNumber *errorCode          = JSON[kErrorCodeKey];
        
        if ([errorCode unsignedIntegerValue] == 200) {
            if (successBlock) {
                successBlock(YES);
            }
            
        } else {
            if (successBlock) {
                successBlock(NO);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"Network error: %@", [error description]);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)delLikedVideoWithVideoID:(NSString *)videoID
                withSuccessBlock:(DelLikedVideoSuccessBlock)successBlock
                withFailureBlock:(FailureBlock)failureBlock {
    NSDictionary *params = @{ @"uuid": [ECUtil readUUIDFromKeyChain], @"video_id": videoID };
    [_manager POST:@"/beacon/v2/del_like_video" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"RawValue: %@", responseObject);
        NSDictionary *JSON           = responseObject;
        NSNumber *errorCode          = JSON[kErrorCodeKey];
        
        if ([errorCode unsignedIntegerValue] == 200) {
            if (successBlock) {
                successBlock(YES);
            }
            
        } else {
            if (successBlock) {
                successBlock(NO);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"Network error: %@", [error description]);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)getLikedVideoWithSuccessBlock:(LikedVideoSuccessBlock)successBlock
                     withFailureBlock:(FailureBlock)failureBlock {
    NSString *getAddress = [NSString stringWithFormat:@"/beacon/v2/get_like_video/%@",
                            [ECUtil readUUIDFromKeyChain]];
    [_manager GET:getAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"RawValue: %@", responseObject);
        NSDictionary *JSON           = responseObject;
        NSArray *dataJSONs           = JSON[kDataKey];
        NSMutableArray *returnModels = [@[] mutableCopy];
        
        for (NSDictionary *dataJSON in dataJSONs) {
            ECReturningVideo *model = [[ECReturningVideo alloc] initWithJSON:dataJSON];
            [returnModels addObject:model];
        }
        
        if (successBlock) {
            successBlock(returnModels);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"Network error: %@", [error description]);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)getGuessVideoWithSuccessBlock:(GuessingVideoSuccessBlock)successBlock
                     withFailureBlock:(FailureBlock)failureBlock {
    NSString *getAddress = [NSString stringWithFormat:@"/beacon/v2/guess_you_like/%@",
                            [ECUtil readUUIDFromKeyChain]];
    [_manager GET:getAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"RawValue: %@", responseObject);
        NSDictionary *JSON           = responseObject;
        NSArray *dataJSONs           = JSON[kDatasKey];
        NSMutableArray *returnModels = [@[] mutableCopy];
        
        for (NSDictionary *dataJSON in dataJSONs) {
            ECReturningVideo *model = [[ECReturningVideo alloc] initWithJSON:dataJSON];
            [returnModels addObject:model];
        }
        
        if (successBlock) {
            successBlock(returnModels);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"Network error: %@", [error description]);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Singleton Methods
- (instancetype)init {
    NSAssert(NO, @"Can`t be used for it`s a singleton");
    return nil;
}

- (instancetype)initMethod {
    if (self = [super init]) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
        _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        _manager.requestSerializer = [AFJSONRequestSerializer  serializer];
        [_manager.requestSerializer setTimeoutInterval:kNetworkTimeoutInterval];
        return self;
    }
    
    return nil;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[ECAPIManager alloc] initMethod];
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
