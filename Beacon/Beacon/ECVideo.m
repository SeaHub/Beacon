//
//  ECVideo.m
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideo.h"
#import "ECReturningVideo.h"

@implementation ECVideo

- (instancetype)initWithReturningModel:(ECReturningVideo *)model {
    if (self = [super init]) {
        _aID           = model.a_id;
        _dateFormat    = model.date_format;
        _identifier    = model.identifier;
        _img           = model.img;
        _isVip         = model.is_vip;
        _playCountText = model.play_count_text;
        _shortTitle    = model.short_title;
        _tvID          = model.tv_id;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"aID: %@, dateFormat: %@, identifier: %@, img: %@, isVip: %@, playCountText: %@, shortTitle: %@, tvID: %@", _aID, _dateFormat, _identifier, _img, _isVip, _playCountText, _shortTitle, _tvID];
}

@end
