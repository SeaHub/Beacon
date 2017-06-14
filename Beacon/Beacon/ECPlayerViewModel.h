//
//  ECPlayerViewModel.h
//  Beacon
//
//  Created by SeaHub on 2017/6/14.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ECReturningVideo;
@interface ECPlayerViewModel : NSObject

- (instancetype)initWithReturningVideo:(ECReturningVideo *)video
                       withCurrentTime:(NSTimeInterval)currentTime
                         withTotalTime:(NSTimeInterval)totalTime
                         withMuteStaus:(BOOL)isMute
                     withPlayingStatus:(BOOL)isPlaying;
- (NSString *)description;
- (BOOL)isEqual:(id)object;

@property (nonatomic, strong, readonly) ECReturningVideo *videoSource;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
@property (nonatomic, assign, readonly) BOOL isMute;
@property (nonatomic, assign, readonly) BOOL isPlaying;

@end

NS_ASSUME_NONNULL_END
