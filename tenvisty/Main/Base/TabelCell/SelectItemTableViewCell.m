//
//  SelectItemTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SelectItemTableViewCell.h"

@interface SelectItemTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;
@end


@implementation SelectItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.constraint_width_leftImg.constant = 0;
    
    self.imgSelected.image = [self.imgSelected.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imgSelected.tintColor = Color_Primary;
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

-(void) setSelect:(Boolean)selected{
    if(selected){
        [self.imgSelected setHidden:NO];
    }
    else{
        [self.imgSelected setHidden:YES];
    }
}
@end
