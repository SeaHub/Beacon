//
//  UITableView+EmptyData.h
//  Beacon
//
//  Created by 段昊宇 on 2017/6/17.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(EmptyData)

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
