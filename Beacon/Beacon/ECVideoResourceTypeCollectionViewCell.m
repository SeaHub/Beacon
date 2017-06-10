//
//  ECVideoResourceTypeCollectionViewCell.m
//  Beacon
//
//  Created by SeaHub on 2017/6/10.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoResourceTypeCollectionViewCell.h"

@interface ECVideoResourceTypeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ECVideoResourceTypeCollectionViewCell

- (void)configureCellWithTitle:(NSString *)title {
    self.titleLabel.text = [NSString stringWithFormat:@"# %@", title];
}

@end
