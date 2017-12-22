//
//  TextFieldTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TextFieldTableViewCell.h"
@interface TextFieldTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@end

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.constraint_width_leftImg.constant = 0;
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

-(void)setPlaceHolder:(NSString *)placeHolder{
    _rightTextField.placeholder = placeHolder;
}

//-(id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if(self){
//        self.constraint_width_leftImg.constant = 0;
//    }
//    return self;
//}

-(void) setLeftImage:(NSString*)imageName{
    [self.leftImg setImage:[UIImage imageNamed:imageName]];
    self.constraint_width_leftImg.constant = 30;
}
-(void)resignFirstResponder{
    [_rightTextField resignFirstResponder];
}
@end
