//
//  CCDraggableCardView.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/6.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CCDraggableCardView.h"

@implementation CCDraggableCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultStyle];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultStyle];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self defaultStyle];
}

- (void)defaultStyle {
    
    self.userInteractionEnabled = YES;
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:10.0f];
    
    CGFloat scaleBackgroud = 245.0f / 255.0f;
    self.backgroundColor = [UIColor colorWithRed:scaleBackgroud green:scaleBackgroud blue:scaleBackgroud alpha:1];
    
}

- (void)cc_layoutSubviews {}

@end
