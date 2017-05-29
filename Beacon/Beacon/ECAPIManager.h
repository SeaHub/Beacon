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
@class ECReturningTop5Video;
typedef void(^VideoTypeSuccessBlock)(NSArray<ECReturningVideoType *> *);
typedef void(^Top5VideosSuccessBlock)(NSArray<ECReturningTop5Video *> *);
typedef void(^FailureBlock)(NSError *);

@interface ECAPIManager : NSObject

- (void)getVideoTypesWithSuccessBlock:(VideoTypeSuccessBlock __nullable)successBlock
                     withFailureBlock:(FailureBlock __nullable)failureBlock;
- (void)getTop5Videos:(NSArray * __nullable)types
     withSuccessBlock:(Top5VideosSuccessBlock __nullable)successBlock
     withFailureBlock:(FailureBlock __nullable)failureBlock;;
+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
