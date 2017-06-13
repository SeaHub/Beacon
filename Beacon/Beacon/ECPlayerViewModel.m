//
//  ECPlayerViewModel.m
//  Beacon
//
//  Created by SeaHub on 2017/6/14.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECPlayerViewModel.h"
#import "ECReturningVideo.h"
#import "ECVideo.h"

@implementation ECPlayerViewModel

- (instancetype)initWithVideo:(ECVideo *)video
              withCurrentTime:(NSTimeInterval)currentTime
                withTotalTime:(NSTimeInterval)totalTime
                withMuteStaus:(BOOL)isMute
            withPlayingStatus:(BOOL)isPlaying {
    
    if (self = [super init]) {
        _videoSource = video;
        _currentTime = currentTime;
        _totalTime   = totalTime;
        _isMute      = isMute;
        _isPlaying   = isPlaying;
    }

    return self;
}

- (instancetype)initWithReturningVideo:(ECReturningVideo *)video
                       withCurrentTime:(NSTimeInterval)currentTime
                         withTotalTime:(NSTimeInterval)totalTime
                         withMuteStaus:(BOOL)isMute
                     withPlayingStatus:(BOOL)isPlaying {
    
    return [self initWithVideo:[video toRealObject]
               withCurrentTime:currentTime withTotalTime:totalTime
                 withMuteStaus:isMute
            withPlayingStatus:isPlaying];
}

- (NSString *)description {
    NSString *isMuteString    = self.isMute ? @"YES" : @"NO";
    NSString *isPlayingString = self.isPlaying ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"aID: %@, tvID: %@, isVip: %@ | currentTimeString: %@, totalTimeString: %@ | isMute: %@, isPlaying: %@", self.videoSource.aID, self.videoSource.tvID, self.videoSource.isVip, [ECUtil convertTimeIntervalToDateString:self.currentTime], [ECUtil convertTimeIntervalToDateString:self.totalTime], isMuteString, isPlayingString];
}

- (BOOL)isEqual:(id)object {
    return [self.videoSource isEqual:((ECPlayerViewModel *)object).videoSource];
}

@end
