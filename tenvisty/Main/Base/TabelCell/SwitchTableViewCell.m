//
//  SwitchTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SwitchTableViewCell.h"

@interface SwitchTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@end


@implementation SwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
        self.constraint_width_leftImg.constant = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setLeftImage:(NSString*)imageName{
    [self.leftImg setImage:[UIImage imageNamed:imageName]];
    self.constraint_width_leftImg.constant = 30;
}

@end
