//
//  NetworkTests.m
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ECAPIManager.h"
#import "ECVideoType.h"
#import "ECReturningVideoType.h"
#import "ECReturningVideo.h"
#import "ECVideo.h"

static const double kTestCaseTimeOutInterval = 20.0;
@interface NetworkTests : XCTestCase

@end

@implementation NetworkTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetVideoTypes {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    
    [[ECAPIManager sharedManager] getVideoTypesWithSuccessBlock:^(NSArray<ECReturningVideoType *> * _Nonnull models) {
        for (ECReturningVideoType *model in models) {
            ECVideoType *realModel = [model toRealObject];
            XCTAssert(realModel != nil);
        }
        
        [exception fulfill];
    } withFailureBlock:^(NSError * _Nonnull error) {
        XCTAssert(error == nil);
    }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];
}

- (void)testGetTop5Videos {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    
    [[ECAPIManager sharedManager] getTop5Videos:nil withSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
        for (ECReturningVideo *model in models) {
            ECVideo *realModel = [model toRealObject];
            XCTAssert(realModel != nil);
        }
        
        [exception fulfill];
    } withFailureBlock:^(NSError * _Nonnull error) {
        XCTAssert(error == nil);
    }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];
}

- (void)testGetTop5VideosWithParams {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    
    [[ECAPIManager sharedManager] getTop5Videos:@[@"电影", @"电视剧", @"综艺"] withSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
        for (ECReturningVideo *model in models) {
            ECVideo *realModel = [model toRealObject];
            XCTAssert(realModel != nil);
        }
        
        [exception fulfill];
    } withFailureBlock:^(NSError * _Nonnull error) {
        XCTAssert(error == nil);
    }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval handler:nil];
}

@end
