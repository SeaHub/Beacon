//
//  UITableView+EmptyData.m
//  Beacon
//
//  Created by 段昊宇 on 2017/6/17.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "UITableView+EmptyData.h"

@implementation UITableView(EmptyData)

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount {
    if (rowCount == 0) {
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.backgroundView = messageLabel;
    } else {
        self.backgroundView = nil;
    }
}

@end
