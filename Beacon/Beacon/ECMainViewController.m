//
//  ECMainViewController.m
//  Beacon
//
//  Created by SeaHub on 2017/5/20.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECMainViewController.h"
#import "ECPlayerController.h"

@interface ECMainViewController ()

@end

@implementation ECMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueOfECPlayController]) {
        ECPlayerController *playerController = (ECPlayerController *)segue.destinationViewController;
        // Here is just a mock
        playerController.contentDict         = @{
            @"a_id": @"677870700",
            @"date_format": @"2017-05-12",
            @"date_timestamp": @"1494604800000",
            @"id": @"677870700",
            @"img": @"http://pic7.qiyipic.com/image/20170513/6d/a6/v_112314044_m_601_m1.jpg",
            @"is_vip": @"0",
            @"p_type": @"1",
            @"play_count": @"5423310",
            @"play_count_text": @"542.3\\U4e07",
            @"short_title": @"\\U9910\\U5385\\U8058\\U6bd4\\U57fa\\U5c3c\\U7f8e\\U5973\\U7aef\\U83dc",
            @"sns_score": @"",
            @"title": @"\\U5357\\U4eac\\U4e00\\U9910\\U5385\\U8058\\U6bd4\\U57fa\\U5c3c\\U7f8e\\U5973\\U7aef\\U83dc \\U8425\\U9500\\U624b\\U6bb5\\U60f9\\U4e89\\U8bae",
            @"total_num": @"1",
            @"tv_id": @"677870700",
            @"type": @"normal",
            @"update_num": @"1",
        };
    }
}

@end
