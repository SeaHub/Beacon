//
//  ECCardView.m
//  Beacon
//
//  Created by 段昊宇 on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECCardView.h"

#import "Masonry.h"

@interface ECCardView()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ECCardView

- (instancetype)init {
    if (self = [super init]) {
        [self loadViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)initialData:(NSString *)image {
    self.imageView.image = [UIImage imageNamed:image];
}

@end
