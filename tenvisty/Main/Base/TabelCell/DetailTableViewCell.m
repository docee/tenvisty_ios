//
//  DetailTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setSelect:(Boolean)selected{
    if(selected){
        [self.rightImg setHidden:NO];
    }
    else{
        [self.rightImg setHidden:YES];
        self.rightImg.image = [UIImage imageNamed:@"navDone"];
        self.rightImg.image = [self.rightImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.rightImg.tintColor = Color_Primary;
    }
}

@end
