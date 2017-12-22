//
//  TextFieldDisableTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TextFieldDisableTableViewCell.h"

@interface TextFieldDisableTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_left_rightTextField;

@end



@implementation TextFieldDisableTableViewCell

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
    _constraint_width_leftImg.constant = 30;
}
-(NSString*)title{
    return _leftLabel.text;
}

-(void)setTitle:(NSString*)t{
    _leftLabel.text = t;
}
-(NSString*)value{
    return _rightTextField.text;
}

-(void)setValue:(NSString*)t{
    _rightTextField.text = t;
}

-(void) setValueAligment:(NSTextAlignment)align{
    _rightTextField.textAlignment = align;
}

-(void) setValueMarginLeft:(CGFloat)left{
    _constraint_left_rightTextField.constant  = left;
}
-(void)resignFirstResponder{
    [_rightTextField resignFirstResponder];
}
@end
