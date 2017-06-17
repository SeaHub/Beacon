//
//  ECReturningVideo.h
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ECVideo;
@interface ECReturningVideo : NSObject <NSCoding>

- (instancetype)initWithJSON:(NSDictionary *)json;
- (ECVideo *)toRealObject;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (BOOL)isEqual:(id)object;
- (NSString *)description;

@property (nonatomic, copy, readonly) NSString *a_id;
@property (nonatomic, copy, readonly) NSString *date_format;
@property (nonatomic, copy, readonly) NSString *date_timestamp;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *img;
@property (nonatomic, copy, readonly) NSString *is_vip;
@property (nonatomic, copy, readonly) NSString *p_type;
@property (nonatomic, copy, readonly) NSString *play_count;
@property (nonatomic, copy, readonly) NSString *play_count_text;
@property (nonatomic, copy, readonly) NSString *short_title;
@property (nonatomic, copy, readonly) NSString *sns_score;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *total_num;
@property (nonatomic, copy, readonly) NSString *tv_id;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *update_num;
// Following are not JSON datas
@property (nonatomic, assign) BOOL isLiked;

@end

NS_ASSUME_NONNULL_END
