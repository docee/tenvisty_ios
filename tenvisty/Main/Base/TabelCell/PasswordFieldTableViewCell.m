//
//  PasswordFieldTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "PasswordFieldTableViewCell.h"

@interface PasswordFieldTableViewCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_left_midPasswordField;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnShowHidePassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_btnImg;
@property (weak, nonatomic) IBOutlet UITextField *midPasswordField;
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
    BOOL wasFirstResponder;
    if ((wasFirstResponder = [_midPasswordField isFirstResponder])) {
        [_midPasswordField resignFirstResponder];
    }
    
    if(_midPasswordField.isSecureTextEntry){
        sender.selected = YES;
       // [_midPasswordField setSecureTextEntry:NO];
    }
    else{
        sender.selected = NO;
        //[_midPasswordField setSecureTextEntry:YES];
    }
    // 这里改变该属性最好使用以下的方法，而不要使用类似[textField setSecureTextEntry:![textField isSecureTextEntry]]的方式，因为会改变占位文字的大小
    _midPasswordField.secureTextEntry = !_midPasswordField.secureTextEntry;
    
    if (wasFirstResponder) {
        [_midPasswordField becomeFirstResponder];
    }
    
}
-(void)hideImgBtn{
    [_btnShowHidePassword setImage:nil forState:UIControlStateNormal];
    [_btnShowHidePassword setImage:nil forState:UIControlStateSelected];
    _constraint_width_btnImg.constant = 0;
}

-(NSString*)title{
    return _leftLabel.text;
}

-(void)setTitle:(NSString*)t{
    _leftLabel.text = t;
}
-(NSString*)value{
    return _midPasswordField.text;
}

-(void)setValue:(NSString*)t{
    _midPasswordField.text = t;
}


-(void) setLeftImage:(NSString*)imageName{
    [_leftImg setImage:[UIImage imageNamed:imageName]];
    _constraint_width_leftImg.constant = 30;
}

-(void) setValueAligment:(NSTextAlignment)align{
    _midPasswordField.textAlignment = align;
}
-(void) setValueMarginLeft:(CGFloat)left{
    _constraint_left_midPasswordField.constant  = left;
}
-(void)showPassword{
    [_midPasswordField setSecureTextEntry:NO];
}
-(void)hidePassword{
    [_midPasswordField setSecureTextEntry:YES];
}

-(void)resignFirstResponder{
    [_midPasswordField resignFirstResponder];
}
@end
