//
//  ECTop5Video.h
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ECReturningTop5Video;
@interface ECTop5Video : NSObject

- (instancetype)initWithReturningModel:(ECReturningTop5Video *)model;
- (NSString *)description;

@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *dateFormat;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *isVip;
@property (nonatomic, copy) NSString *playCountText;
@property (nonatomic, copy) NSString *shortTitle;
@property (nonatomic, copy) NSString *tvID;

@end

NS_ASSUME_NONNULL_END
