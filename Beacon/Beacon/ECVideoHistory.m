//
//  ECVideoHistory.m
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoHistory.h"
#import "ECReturningVideoHistory.h"

@implementation ECVideoHistory

- (instancetype)initWithReturningModel:(ECReturningVideoHistory *)model {
    if (self = [super init]) {
        _userID    = model.user_id;
        _videoID   = model.video_id;
        _watchDate = model.watch_date;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"userID: %@, videoID: %@, watchDate: %@", _userID, _videoID, _watchDate];
}

- (BOOL)isEqual:(id)object {
    ECVideoHistory *history = (ECVideoHistory *)object;
    if ([_userID isEqualToString:history.userID]
        && [_videoID isEqual:history.videoID]
        && [_watchDate isEqual:history.watchDate]) {
        return YES;
    }
    
    return NO;
}

@end
