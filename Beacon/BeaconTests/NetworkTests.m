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

- (void)testGetGuessVideos {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    
    [[ECAPIManager sharedManager] getGuessVideoWithSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
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

- (void)testAddPlayedHistory {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECAPIManager sharedManager] getTop5Videos:nil
                               withSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
        
        [[ECAPIManager sharedManager] addPlayedHistoryWithVideoID:models.firstObject.identifier
                                                 withSuccessBlock:^(BOOL isSuccess) {
                                                     
                                                     [exception fulfill];
                                                     if (!isSuccess) {
                                                         XCTAssert(NO);
                                                     }
                                                     
                                                 } withFailureBlock:^(NSError * _Nonnull error) {
                                                     [exception fulfill];
                                                     XCTAssert(error == nil);
                                                 }];
        
    } withFailureBlock:^(NSError * _Nonnull error) {
        XCTAssert(error == nil);
    }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval * 2 handler:nil];
}

- (void)testDelPlayedHistory {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECAPIManager sharedManager] getTop5Videos:nil
                               withSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
                                   
                                   [[ECAPIManager sharedManager] delPlayedHistoryWithVideoID:models.firstObject.identifier withSuccessBlock:^(BOOL isSuccess) {
                                      
                                       [exception fulfill];
                                       if (!isSuccess) {
                                           XCTAssert(NO);
                                       }
                                   } withFailureBlock:^(NSError * _Nonnull error) {
                                       [exception fulfill];
                                       XCTAssert(error == nil);
                                   }];
                                   
                               } withFailureBlock:^(NSError * _Nonnull error) {
                                   XCTAssert(error == nil);
                               }];
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval * 2 handler:nil];
}

- (void)testGetPlayedHistory {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECAPIManager sharedManager] getPlayedHistroyWithSuccessBlock:^(NSArray<ECReturningVideoHistory *> * _Nonnull models) {
        for (ECReturningVideo *model in models) {
            ECVideo *realModel = [model toRealObject];
            XCTAssert(realModel != nil);
        }
        
        [exception fulfill];
    } withFailureBlock:^(NSError * _Nonnull error) {
         XCTAssert(error == nil);
    }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval * 2 handler:nil];
}

- (void)testAddLikedVideo {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECAPIManager sharedManager] getTop5Videos:nil
                               withSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
                                   
            [[ECAPIManager sharedManager] addLikedVideoWithVideoID:models.firstObject.identifier withSuccessBlock:^(BOOL isSuccess) {
                    [exception fulfill];
                    if (!isSuccess) {
                        XCTAssert(NO);
                    }
                
                } withFailureBlock:^(NSError * _Nonnull error) {
                    [exception fulfill];
                    XCTAssert(error == nil);
                }];
                                   
    } withFailureBlock:^(NSError * _Nonnull error) {
        XCTAssert(error == nil);
    }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval * 2 handler:nil];
}

- (void)testDelLikedVideo {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECAPIManager sharedManager] getTop5Videos:nil
                               withSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
                                   
                                   [[ECAPIManager sharedManager] delLikedVideoWithVideoID:models.firstObject.identifier withSuccessBlock:^(BOOL isSuccess) {
                                       [exception fulfill];
                                       if (!isSuccess) {
                                           XCTAssert(NO);
                                       }
                                   } withFailureBlock:^(NSError * _Nonnull error) {
                                       [exception fulfill];
                                       XCTAssert(error == nil);
                                   }];
                                   
                               } withFailureBlock:^(NSError * _Nonnull error) {
                                   XCTAssert(error == nil);
                               }];
    
    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval * 2 handler:nil];
}

- (void)testGetLikedVideo {
    XCTestExpectation *exception = [self expectationWithDescription:@"Wait callback"];
    [[ECAPIManager sharedManager] getLikedVideoWithSuccessBlock:^(NSArray<ECReturningVideo *> * _Nonnull models) {
        for (ECReturningVideo *model in models) {
            ECVideo *realModel = [model toRealObject];
            XCTAssert(realModel != nil);
        }
        
        [exception fulfill];
    } withFailureBlock:^(NSError * _Nonnull error) {
        XCTAssert(error == nil);
    }];

    [self waitForExpectationsWithTimeout:kTestCaseTimeOutInterval * 2 handler:nil];
}

@end
