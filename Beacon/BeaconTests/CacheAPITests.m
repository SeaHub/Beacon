//
//  CacheAPITests.m
//  Beacon
//
//  Created by SeaHub on 2017/5/30.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ECCacheAPIHelper.h"

static const double kTestCaseTimeOutInterval = 20.0;
@interface CacheAPITests : XCTestCase

@end

@implementation CacheAPITests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetTop5VideosFromCache {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    
    [ECCacheAPIHelper getTop5VideosFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideo *> * _Nullable cachedVideos) {
        
        XCTAssert(cachedVideos != nil);
        
        // 第一次请求不一定命中缓存，但第二次请求一定命中缓存
        [ECCacheAPIHelper getTop5VideosFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideo *> * _Nullable cachedVideos) {
            XCTAssert(isCacheHitting && cachedVideos);
            [exception fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];
}

- (void)testGetVideoTypesFromCache {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    
    [ECCacheAPIHelper getVideoTypesFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideoType *> * _Nullable cachedTypes) {
        
        XCTAssert(cachedTypes != nil);
        
        // 第一次请求不一定命中缓存，但第二次请求一定命中缓存
        [ECCacheAPIHelper getVideoTypesFromCache:YES withFinishedBlock:^(BOOL isCacheHitting, NSArray<ECReturningVideoType *> * _Nullable cachedTypes) {
            XCTAssert(isCacheHitting && cachedTypes);
            [exception fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];
}

@end
