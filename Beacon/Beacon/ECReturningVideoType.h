//
//  ECReturningVideoType.h
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ECVideoType;
@interface ECReturningVideoType : NSObject <NSCoding>

- (instancetype)initWithJSON:(NSDictionary *)json;
- (ECVideoType *)toRealObject;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@property (nonatomic, copy, readonly) NSString *desc;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *name;

@end

NS_ASSUME_NONNULL_END
