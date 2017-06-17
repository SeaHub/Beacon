//
//  ECReturningWatchedVideo.m
//  Beacon
//
//  Created by SeaHub on 2017/6/17.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECReturningWatchedVideo.h"

static NSString *const kWatch_dateKey = @"watch_date";

@implementation ECReturningWatchedVideo

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        _watch_date = json[kWatch_dateKey];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _watch_date = [aDecoder decodeObjectForKey:kWatch_dateKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_watch_date forKey:kWatch_dateKey];
}

- (BOOL)isEqual:(id)object {
    ECReturningWatchedVideo *video = (ECReturningWatchedVideo *)object;
    return [_watch_date isEqualToString:video.watch_date] &&
        [super isEqual:video];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, watchedDate: %@",
            [super description], _watch_date];
}

@end
