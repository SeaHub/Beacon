//
//  ECCardView.m
//  Beacon
//
//  Created by 段昊宇 on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECCardView.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface ECCardView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *effectView;
@property (assign) BOOL *isStar;

@property (strong, nonatomic) UIImageView *playButton;
@property (strong, nonatomic) UILabel *duration;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIImageView *star;

@property (strong, nonatomic) UILabel *tag1;

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
    self.isStar = NO;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundColor = [UIColor clearColor];
    
    self.effectView = [[UIView alloc] init];
    self.effectView.frame = self.imageView.frame;
    self.effectView.backgroundColor = [UIColor blackColor];
    self.effectView.alpha = 0.6;
    
    self.playButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
    self.playButton.alpha = 0.4;
    
    self.duration = [[UILabel alloc] init];
    self.duration.backgroundColor = [UIColor blackColor];
    self.duration.text = @"1:20:00";
    self.duration.textColor = [UIColor whiteColor];
    self.duration.textAlignment = NSTextAlignmentCenter;
    self.duration.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    
    self.title = [[UILabel alloc] init];
    self.title.backgroundColor = [UIColor clearColor];
    self.title.text = @"Ghost In The Shell";
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
    self.star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    self.backgroundColor = [UIColor clearColor];
    self.star.alpha = 0;
    
    self.tag1 = [[UILabel alloc] init];
    self.tag1.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:192 / 255.0 blue:47 / 255.0 alpha:1];
    self.tag1.text = @"# iQIYI";
    self.tag1.textAlignment = NSTextAlignmentCenter;
    self.tag1.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    
    [self addSubview:self.imageView];
    [self addSubview:self.effectView];
    [self addSubview:self.playButton];
    [self addSubview:self.duration];
    [self addSubview:self.title];
    [self addSubview:self.star];
    [self addSubview:self.tag1];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    [self.duration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@40);
        make.width.equalTo(@72);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(20);
        make.bottom.equalTo(self.mas_bottom).with.offset(-48);
        make.right.equalTo(self.mas_right).with.offset(-60);
    }];
    
    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@58);
        make.width.equalTo(@58);
    }];
    
    [self.tag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(20);
        make.height.equalTo(@20);
        make.top.equalTo(self.title.mas_bottom).with.offset(9);
        make.width.equalTo(@55);
    }];
    
}

- (void)initialData:(ECReturningVideo *)video {
    NSString *image = video.img;
    NSRange range = [image rangeOfString:@"m_601"];
    NSInteger len = range.length;
    if (len != 0) {
        NSString *imageHD = [image stringByReplacingOccurrencesOfString:@".jpg" withString:@"_480_360.jpg"];
        debugLog(@"%@", imageHD);
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageHD]];
    } else {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:image]];
    }
    
    self.title.text = video.title;
    self.duration.text = video.play_count_text;
}

- (void)convertToBlurImage:(UIImageView *)imageView {
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    CIImage *inputImage = [CIImage imageWithCGImage:[imageView.image CGImage]];
    [gaussianBlurFilter setValue:inputImage forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@5 forKey:kCIInputRadiusKey];
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[inputImage extent]]; // note, use input image extent if you want it the same size, the output image extent is larger
    UIImage *convertedImage = [UIImage imageWithCGImage:cgimg];
    imageView.image = convertedImage;
}


@end
