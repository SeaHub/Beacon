//
//  ECVideoIntroductTableViewCell.m
//  Beacon
//
//  Created by SeaHub on 2017/6/10.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoIntroductTableViewCell.h"

@interface ECVideoIntroductTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation ECVideoIntroductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithTitle:(NSString *)title withContent:(NSString *)content {
    self.titleLabel.text      = title;
    self.contentTextView.text = content;
}

- (void)configureCellWithIntroductionContent:(NSString *)content {
    self.titleLabel.text      = @"Introduction";
    self.contentTextView.text = content;
}

@end
