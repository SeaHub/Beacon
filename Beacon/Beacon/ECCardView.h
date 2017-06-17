//
//  ECCardView.h
//  Beacon
//
//  Created by 段昊宇 on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCDraggableCardView.h"
#import "ECReturningVideo.h"

@interface ECCardView : CCDraggableCardView

- (void)initialData:(ECReturningVideo *)video;
- (void)addLiked;
- (void)delLiked;

@end
