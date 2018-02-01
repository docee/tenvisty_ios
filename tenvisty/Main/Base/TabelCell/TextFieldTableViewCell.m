//
//  TextFieldTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TextFieldTableViewCell.h"
#import "TwsAutoKeyboardTextField.h"
@interface TextFieldTableViewCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;
@property (weak, nonatomic) IBOutlet TwsAutoKeyboardTextField *rightTextField;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (nonatomic,assign) NSInteger mLength;
@end

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.constraint_width_leftImg.constant = 0;
    _rightTextField.delegate = self;
    //[_rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _rightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
     _rightTextField.secureTextEntry = NO;
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    //UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:LOCALSTR(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(resignFirstResponder)];
    doneButton.tintColor = [UIColor blackColor];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [_rightTextField setInputAccessoryView:topView];
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
// 获得焦点
- (BOOL)textFieldShouldBeginEditing:(TwsAutoKeyboardTextField *)textField{
    [_rightTextField relocateView];
    return YES;
}
// 失去焦点
- (BOOL)textFieldShouldEndEditing:(TwsAutoKeyboardTextField *)textField{
    // [_rightTextField closeNotification];
    return YES;
}
-(void)dealloc{
   // [_rightTextField closeNotification];
}
// 失去焦点
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//     [_rightTextField closeNotification];
//}
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if(self){
//        self.constraint_width_leftImg.constant = 0;
//    }
//    return self;
//}


-(void) setLeftImage:(NSString*)imageName{
    if(imageName != nil){
        [self.leftImg setHidden:NO];
        [self.leftImg setImage:[UIImage imageNamed:imageName]];
        self.constraint_width_leftImg.constant = 30;
    }
    else{
        [self.leftImg setHidden:YES];
        self.constraint_width_leftImg.constant = 0;
    }
}

-(void)resignFirstResponder{
    [_rightTextField resignFirstResponder];
    [_rightTextField refreshLocateView];
}

@end
