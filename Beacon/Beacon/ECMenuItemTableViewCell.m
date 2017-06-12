//
//  ECMenuItemTableViewCell.m
//  Beacon
//
//  Created by 段昊宇 on 2017/6/8.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECMenuItemTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface ECMenuItemTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *ablumImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchLabel;

@end

@implementation ECMenuItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self initStyle];
}

- (void)initStyle {
    self.ablumImageView.layer.masksToBounds = YES;
    self.ablumImageView.layer.cornerRadius = 4;
}

- (void)configureCellByModel: (ECReturningVideo *)video {
    [self.ablumImageView sd_setImageWithURL:[NSURL URLWithString:video.img]];
    self.titleLabel.text = video.title;
    self.watchLabel.text = video.play_count_text;
}

@end
