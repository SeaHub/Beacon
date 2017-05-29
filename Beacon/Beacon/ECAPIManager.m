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
#import "ECReturningTop5Video.h"

static NSString *const kBaseURLString    = @"https://beacon-flask.herokuapp.com";
static const int kNetworkTimeoutInterval = 20;
static ECAPIManager *object              = nil;
static NSString *const kDatasKey         = @"datas";

@interface ECAPIManager () {
    AFHTTPSessionManager *_manager;
}

@end

@implementation ECAPIManager

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
        [_manager GET:@"/beacon/v2/top5" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            debugLog(@"RawValue: %@", responseObject);
            NSDictionary *JSON           = responseObject;
            NSArray *dataJSONs           = JSON[kDatasKey];
            NSMutableArray *returnModels = [@[] mutableCopy];
            
            for (NSDictionary *dataJSON in dataJSONs) {
                ECReturningTop5Video *model = [[ECReturningTop5Video alloc] initWithJSON:dataJSON];
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
#warning something error
       // NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:types options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        NSDictionary *params = @{ @"types": types };
        [_manager POST:@"/beacon/v2/top5" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            debugLog(@"RawValue: %@", responseObject);
            NSDictionary *JSON           = responseObject;
            NSArray *dataJSONs           = JSON[kDatasKey];
            NSMutableArray *returnModels = [@[] mutableCopy];
            
            for (NSDictionary *dataJSON in dataJSONs) {
                ECReturningTop5Video *model = [[ECReturningTop5Video alloc] initWithJSON:dataJSON];
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

#pragma mark - Singleton
- (instancetype)init {
    NSAssert(NO, @"Can`t be used for it`s a singleton");
    return nil;
}

- (instancetype)initMethod {
    if (self = [super init]) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
        _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        // _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                            // @"application/json", @"text/json",
                                                            //  @"text/javascript", @"text/html", nil];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_manager.requestSerializer setTimeoutInterval:kNetworkTimeoutInterval];
        #warning something error
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
