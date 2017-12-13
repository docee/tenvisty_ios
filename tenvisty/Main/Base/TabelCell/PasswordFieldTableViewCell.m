//
//  PasswordFieldTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "PasswordFieldTableViewCell.h"

@interface PasswordFieldTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;

@end

@implementation PasswordFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.constraint_width_leftImg.constant = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)togglePassword:(UIButton *)sender {
    if(_midPasswordField.isSecureTextEntry){
        [sender setImage:[UIImage imageNamed:@"icPasswordShown"] forState:UIControlStateNormal];
        [_midPasswordField setSecureTextEntry:NO];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"icPasswordHidden"] forState:UIControlStateNormal];
        [_midPasswordField setSecureTextEntry:YES];
    }
}

-(void) setLeftImage:(NSString*)imageName{
    [self.leftImg setImage:[UIImage imageNamed:imageName]];
    self.constraint_width_leftImg.constant = 30;
}

@end
