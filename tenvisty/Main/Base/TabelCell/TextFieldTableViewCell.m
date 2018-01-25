//
//  TextFieldTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TextFieldTableViewCell.h"
@interface TextFieldTableViewCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (nonatomic,assign) NSInteger mLength;
@end

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.constraint_width_leftImg.constant = 0;
    _rightTextField.delegate = self;
    [_rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _rightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
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

-(void)setMaxLength:(NSInteger)maxLength{
    self.mLength = maxLength;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.mLength > 0){
        if (string.length == 0) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > self.mLength) {
            return NO;
        }
        char commitChar = [string characterAtIndex:0];
        if((commitChar > 96 && commitChar < 123)|| (commitChar < 91 && commitChar > 64) || (commitChar > 47 && commitChar < 58) ||commitChar == 45){
            if (commitChar > 96 && commitChar < 123 ){
                NSString * uppercaseString = string.uppercaseString;
                NSString * str1 = [textField.text substringToIndex:range.location];
                NSString * str2 = [textField.text substringFromIndex:range.location];
                textField.text = [[NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2] uppercaseString];// [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2].uppercaseString;
                return NO;
            }
        }
        else{
            return NO;
        }
    }
//    NSCharacterSet *cs;
//    cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    BOOL basicTest = [string isEqualToString:filtered];
//    if(!basicTest)  {
//        return NO;
//    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if(self.mLength > 0){
        if (textField.text.length > self.mLength) {
            textField.text = [[textField.text substringToIndex:self.mLength] uppercaseString];
        }
    }
}

@end
