//
//  ECVideoTableViewController.m
//  Beacon
//
//  Created by SeaHub on 2017/6/6.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoTableViewController.h"

static NSString *const kECVideoTablePlayerReuseIdentifier    = @"kECVideoTablePlayerReuseIdentifier";
static NSString *const kECVideoTableGuessingReuseIdentifier  = @"kECVideoTableGuessingReuseIdentifier";
static NSString *const kECVideoTableIntroductReuseIdentifier = @"kECVideoTableIntroductReuseIdentifier";

@implementation ECVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kECVideoTablePlayerReuseIdentifier
                                               forIndexPath:indexPath];
    } else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:kECVideoTableIntroductReuseIdentifier
                                               forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kECVideoTableGuessingReuseIdentifier
                                               forIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case 0:
            height = 390.0;
            break;
        default:
            height = 150.0;
            break;
    }
    
    return height;
}


@end
