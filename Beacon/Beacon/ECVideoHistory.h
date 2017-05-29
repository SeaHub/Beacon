//
//  ECVideoHistory.h
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ECReturningVideoHistory;
@interface ECVideoHistory : NSObject

- (instancetype)initWithReturningModel:(ECReturningVideoHistory *)model;
- (NSString *)description;
- (BOOL)isEqual:(id)object;

@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *videoID;
@property (nonatomic, copy, readonly) NSString *watchDate;

@end

NS_ASSUME_NONNULL_END
