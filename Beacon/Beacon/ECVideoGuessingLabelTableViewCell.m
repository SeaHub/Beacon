//
//  ECVideoGuessingLabelTableViewCell.m
//  Beacon
//
//  Created by SeaHub on 2017/6/10.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoGuessingLabelTableViewCell.h"

@interface ECVideoGuessingLabelTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ECVideoGuessingLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _hideSeperate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)_hideSeperate {
    CGFloat widthOfInset = [UIScreen mainScreen].bounds.size.width / 2;
    self.separatorInset  = UIEdgeInsetsMake(0, widthOfInset, 0, widthOfInset);
}

@end
