//
//  TextFieldImgTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TextFieldImgTableViewCell.h"

@interface TextFieldImgTableViewCell(){
    
}

@property (weak, nonatomic) IBOutlet UITextField *midTextField;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation TextFieldImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _midTextField.delegate = self;
    //[_rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _midTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
    return _midTextField.text;
}

-(void)setValue:(NSString*)t{
    _midTextField.text = t;
}
- (IBAction)clickBtn:(id)sender {
    if(self.action && self.actionOwner){
        if([self.actionOwner respondsToSelector:self.action]){
            IMP imp = [self.actionOwner methodForSelector:self.action];
            void (*func)(id, SEL) = (void *)imp;
            func(self.actionOwner, self.action);
            //[self.actionOwner performSelector:self.action withObject:nil];
        }
    }
}

-(void)setRightImage:(NSString *)rightImage{
    [_rightButton setImage:[UIImage imageNamed:rightImage] forState:UIControlStateNormal];
}
-(void)resignFirstResponder{
    [_midTextField resignFirstResponder];
}
@end
