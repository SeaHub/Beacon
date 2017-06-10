//
//  ECVideoTableViewController.m
//  Beacon
//
//  Created by SeaHub on 2017/6/6.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoTableViewController.h"

static NSString *const kECVideoTablePlayerReuseIdentifier          = @"kECVideoTablePlayerReuseIdentifier";
static NSString *const kECVideoTableIntroductReuseIdentifier       = @"kECVideoTableIntroductReuseIdentifier";
static NSString *const kECVideoTableGuessingLabelReuseIdentifier   = @"kECVideoTableGuessingLabelReuseIdentifier";
static NSString *const kECVideoTableGuessingContentReuseIdentifier = @"kECVideoTableGuessingContentReuseIdentifier";

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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kECVideoTablePlayerReuseIdentifier
                                               forIndexPath:indexPath];
    } else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:kECVideoTableIntroductReuseIdentifier
                                               forIndexPath:indexPath];
    } else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:kECVideoTableGuessingLabelReuseIdentifier
                                               forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kECVideoTableGuessingContentReuseIdentifier
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
        case 1:
            height = 150.0;
            break;
        case 2:
            height = 31.5;
            break;
        default:
            height = 120.0;
            break;
    }
    
    return height;
}

#pragma mark - Button Action
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)likeButtonClicked:(id)sender {
    debugLog(@"Like Button Clicked");
}

- (IBAction)dislikeButtonClicked:(id)sender {
    debugLog(@"Dislike Button Clicked");
}

- (IBAction)moreButtonClicked:(id)sender {
    debugLog(@"More Button Clicked");
}

- (IBAction)playButtonClicked:(id)sender {
    debugLog(@"Play Button Clicked");
}

- (IBAction)shareButtonClicked:(id)sender {
    debugLog(@"Share Button Clicked");
}

- (IBAction)fullScreenButtonClicked:(id)sender {
    debugLog(@"FullScreen Button Clicked");
}

@end
