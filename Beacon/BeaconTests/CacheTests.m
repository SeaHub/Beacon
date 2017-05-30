//
//  CacheTests.m
//  Beacon
//
//  Created by SeaHub on 2017/5/30.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ECCacheManager.h"

static const double kTestCaseTimeOutInterval = 20.0;
static NSString *const kTestCacheNameA       = @"kTestCacheNameA";
static NSString *const kTestCacheNameB       = @"kTestCacheNameB";

@interface CacheTests : XCTestCase {
    UIImage *_imageToCacheA;
    UIImage *_imageToCacheB;
}
@end

@implementation CacheTests

- (void)setUp {
    _imageToCacheA = [UIImage imageNamed:@"more"];
    _imageToCacheB = [UIImage imageNamed:@"up"];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSetObjectOnlyMemoryAndContainsObject {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECCacheManager sharedManager] setObject:_imageToCacheA
                                       forKey:kTestCacheNameA
                                   onlyMemory:YES withFinishedBlock:^{
                                       
        BOOL flag = [[ECCacheManager sharedManager] containsObjectForKey:kTestCacheNameA];
        XCTAssert(flag == YES);
        [exception fulfill];
    }];
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];
}

- (void)testSetObjectAndGetObject {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECCacheManager sharedManager] setObject:_imageToCacheA
                                       forKey:kTestCacheNameA
                                   onlyMemory:YES withFinishedBlock:^{
                                       
        [[ECCacheManager sharedManager] objectForKey:kTestCacheNameA withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
            XCTAssert([key isEqualToString:kTestCacheNameA] && object != nil);
            [exception fulfill];
        }];
    }];
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];    
}

- (void)testRemoveObjectForKey {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    
    [[ECCacheManager sharedManager] setObject:_imageToCacheB forKey:kTestCacheNameB onlyMemory:NO withFinishedBlock:^{
        
        [[ECCacheManager sharedManager] removeObjectForKey:kTestCacheNameB withFinishedBlock:^(NSString * _Nonnull key) {
            BOOL flag = [[ECCacheManager sharedManager] containsObjectForKey:key];
            XCTAssert(flag == NO);
            
            [[ECCacheManager sharedManager] objectForKey:kTestCacheNameB withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
                XCTAssert([key isEqualToString:kTestCacheNameB] && object == nil);
                [exception fulfill];
            }];
        }];
    }];
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];    
}

- (void)testClearObjects {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECCacheManager sharedManager] setObject:_imageToCacheB forKey:kTestCacheNameB onlyMemory:NO withFinishedBlock:^{
        [[ECCacheManager sharedManager] clearAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
            XCTAssert(removedCount <= totalCount);
            
        } withFinishedBlock:^(BOOL error) {
            // 注意，在 claerAllObjects: 的回调函数中调用 containsObjectForKey:，需要异步调用，否则死锁
            dispatch_async(dispatch_get_main_queue(), ^{
                XCTAssert(error == NO);
                BOOL flag = [[ECCacheManager sharedManager] containsObjectForKey:kTestCacheNameB];
                XCTAssert(flag == NO);
                [exception fulfill];
            });
        }];
    }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];
}

- (void)testClearMemoryObjects {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECCacheManager sharedManager] setObject:_imageToCacheA
                                       forKey:kTestCacheNameA
                                   onlyMemory:YES withFinishedBlock:^{
        
        [[ECCacheManager sharedManager] clearAllMemoryObjectsWithFinishedBlock:^{
            BOOL flag = [[ECCacheManager sharedManager] containsObjectForKey:kTestCacheNameA];
            XCTAssert(flag == NO);
            [exception fulfill];
        }];
    }];
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];
}

- (void)testClearDiskObjects {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    
    [[ECCacheManager sharedManager] setObject:_imageToCacheB forKey:kTestCacheNameB onlyMemory:NO withFinishedBlock:^{
        
        [[ECCacheManager sharedManager] objectForKey:kTestCacheNameB withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
            
            [[ECCacheManager sharedManager] clearAllMemoryObjectsWithFinishedBlock:^{
                BOOL flag = [[ECCacheManager sharedManager] containsObjectForKey:kTestCacheNameB];
                XCTAssert(flag == YES);
                
                [[ECCacheManager sharedManager] clearAllMemoryObjectsWithFinishedBlock:nil];
                [[ECCacheManager sharedManager] clearAllDiskObjectsWithFinishedBlock:^{
                    BOOL flag = [[ECCacheManager sharedManager] containsObjectForKey:kTestCacheNameB];
                    XCTAssert(flag == NO);
                    [[ECCacheManager sharedManager] objectForKey:kTestCacheNameB withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
                        XCTAssert(key == kTestCacheNameB && object == nil);
                        [exception fulfill];
                    }];
                }];
            }];
        }];
    }];

    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];
}

- (void)testCachePath {
    XCTAssert([ECCacheManager sharedManager].diskCachePath != nil);
}

@end

