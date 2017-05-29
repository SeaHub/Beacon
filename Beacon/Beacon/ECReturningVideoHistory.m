//
//  ECReturningVideoHistory.m
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECReturningVideoHistory.h"
#import "ECVideoHistory.h"

static NSString *const kUserIDKey    = @"user_id";
static NSString *const kVideoIDKey   = @"video_id";
static NSString *const kWatchDateKey = @"watch_date";

@implementation ECReturningVideoHistory

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        _user_id     = json[kUserIDKey];
        _video_id    = json[kVideoIDKey];
        _watch_date  = json[kWatchDateKey];
    }
    
    return self;
}

- (ECVideoHistory *)toRealObject {
    return [[ECVideoHistory alloc] initWithReturningModel:self];
}

@end
