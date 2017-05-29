//
//  ECReturningVideoHistory.h
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ECVideoHistory;
@interface ECReturningVideoHistory : NSObject

- (instancetype)initWithJSON:(NSDictionary *)json;
- (ECVideoHistory *)toRealObject;

@property (nonatomic, copy, readonly) NSString *user_id;
@property (nonatomic, copy, readonly) NSString *video_id;
@property (nonatomic, copy, readonly) NSString *watch_date;

@end

NS_ASSUME_NONNULL_END
