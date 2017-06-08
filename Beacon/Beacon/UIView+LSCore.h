//
//  UIView+LSCore.h
//  Beacon
//
//  Created by 段昊宇 on 2017/6/8.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(LSCore)

- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;
- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii viewRect:(CGRect)rect;

@end
