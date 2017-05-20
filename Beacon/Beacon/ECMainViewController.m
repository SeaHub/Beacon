//
//  ECMainViewController.m
//  Beacon
//
//  Created by SeaHub on 2017/5/20.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECMainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ECMainViewController () {
    __weak IBOutlet UIImageView *_imageView;
}
@end

@implementation ECMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495903164&di=a47f8c9c8b7a455a2bb5cee4b91500e8&imgtype=jpg&er=1&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%253D580%2Fsign%3D2507a4c8db33c895a67e9873e1127397%2Fd0ecb744ad345982989436cd0ef431adcbef8400.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
