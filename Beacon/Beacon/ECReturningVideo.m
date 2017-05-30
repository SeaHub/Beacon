//
//  ECReturningVideo.m
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECReturningVideo.h"
#import "ECVideo.h"

static NSString *const kA_idKey            = @"a_id";
static NSString *const kDate_formatKey     = @"date_format";
static NSString *const kDate_timestampKey  = @"date_timestamp";
static NSString *const kIDKey              = @"id";
static NSString *const kImgKey             = @"img";
static NSString *const kIs_vipKey          = @"is_vip";
static NSString *const kP_typeKey          = @"p_type";
static NSString *const kPlay_countKey      = @"play_count";
static NSString *const kPlay_count_textKey = @"play_count_text";
static NSString *const kShort_titleKey     = @"short_title";
static NSString *const kSns_scoreKey       = @"sns_score";
static NSString *const kTitleKey           = @"title";
static NSString *const kTotal_numKey       = @"total_num";
static NSString *const kTv_idKey           = @"tv_id";
static NSString *const kTypeKey            = @"type";
static NSString *const kUpdate_numKey      = @"update_num";

@implementation ECReturningVideo

- (instancetype)initWithJSON:(NSDictionary *)json {
    
    if (self = [super init]) {
        _a_id            = json[kA_idKey];
        _date_format     = json[kDate_formatKey];
        _date_timestamp  = json[kDate_timestampKey];
        _identifier      = json[kIDKey];
        _img             = json[kImgKey];
        _is_vip          = json[kIs_vipKey];
        _p_type          = json[kP_typeKey];
        _play_count      = json[kPlay_countKey];
        _play_count_text = json[kPlay_count_textKey];
        _short_title     = json[kShort_titleKey];
        _sns_score       = json[kSns_scoreKey];
        _title           = json[kTitleKey];
        _total_num       = json[kTotal_numKey];
        _tv_id           = json[kTv_idKey];
        _type            = json[kTv_idKey];
        _update_num      = json[kUpdate_numKey];
    }
    
    return self;
}

- (ECVideo *)toRealObject {
    return [[ECVideo alloc] initWithReturningModel:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _a_id            = [aDecoder decodeObjectForKey:kA_idKey];
        _date_format     = [aDecoder decodeObjectForKey:kDate_formatKey];
        _date_timestamp  = [aDecoder decodeObjectForKey:kDate_timestampKey];
        _identifier      = [aDecoder decodeObjectForKey:_identifier];
        _img             = [aDecoder decodeObjectForKey:kImgKey];
        _is_vip          = [aDecoder decodeObjectForKey:kIs_vipKey];
        _p_type          = [aDecoder decodeObjectForKey:kP_typeKey];
        _play_count      = [aDecoder decodeObjectForKey:kPlay_countKey];
        _play_count_text = [aDecoder decodeObjectForKey:kPlay_count_textKey];
        _short_title     = [aDecoder decodeObjectForKey:kShort_titleKey];
        _sns_score       = [aDecoder decodeObjectForKey:kSns_scoreKey];
        _title           = [aDecoder decodeObjectForKey:kTitleKey];
        _total_num       = [aDecoder decodeObjectForKey:kTotal_numKey];
        _tv_id           = [aDecoder decodeObjectForKey:kTv_idKey];
        _type            = [aDecoder decodeObjectForKey:_type];
        _update_num      = [aDecoder decodeObjectForKey:kUpdate_numKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_a_id            forKey:kA_idKey];
    [aCoder encodeObject:_date_format     forKey:kDate_formatKey];
    [aCoder encodeObject:_date_timestamp  forKey:kDate_timestampKey];
    [aCoder encodeObject:_identifier      forKey:kIDKey];
    [aCoder encodeObject:_img             forKey:kImgKey];
    [aCoder encodeObject:_is_vip          forKey:kIs_vipKey];
    [aCoder encodeObject:_p_type          forKey:kP_typeKey];
    [aCoder encodeObject:_play_count      forKey:kPlay_countKey];
    [aCoder encodeObject:_play_count_text forKey:kPlay_count_textKey];
    [aCoder encodeObject:_short_title     forKey:kShort_titleKey];
    [aCoder encodeObject:_sns_score       forKey:kSns_scoreKey];
    [aCoder encodeObject:_title           forKey:kTitleKey];
    [aCoder encodeObject:_total_num       forKey:kTotal_numKey];
    [aCoder encodeObject:_tv_id           forKey:kTv_idKey];
    [aCoder encodeObject:_type            forKey:kTypeKey];
    [aCoder encodeObject:_update_num      forKey:kUpdate_numKey];
}

@end
