//
//  ECVideoType.h
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ECReturningVideoType;
@interface ECVideoType : NSObject

- (instancetype)initWithReturningModel:(ECReturningVideoType *)model;
- (NSString *)description;

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
