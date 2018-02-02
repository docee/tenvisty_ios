//
//  PasswordFieldTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "PasswordFieldTableViewCell.h"
#import "TwsAutoKeyboardTextField.h"

@interface PasswordFieldTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_left_midPasswordField;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnShowHidePassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_btnImg;
@property (weak, nonatomic) IBOutlet TwsAutoKeyboardTextField *midPasswordField;
@end

@implementation PasswordFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.constraint_width_leftImg.constant = 0;
    _midPasswordField.delegate = self;
   // [_midPasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _midPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    //UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:LOCALSTR(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(resignFirstResponder)];
    doneButton.tintColor = [UIColor blackColor];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [_midPasswordField setInputAccessoryView:topView];
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

-(NSString*)value{
    return _midPasswordField.text;
}

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
-(void)setRightImage:(NSString *)rightImage{
    if(rightImage == nil){
        [_btnShowHidePassword setImage:nil forState:UIControlStateNormal];
        [_btnShowHidePassword setImage:nil forState:UIControlStateSelected];
        _constraint_width_btnImg.constant = 0;
    }
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

-(void)setCellModel:(ListImgTableViewCellModel *)cellModel{
    [super setCellModel:cellModel];
    [self refreshCell];
}

-(void)refreshCell{
    [super refreshCell];
    if(self.cellModel){
        _midPasswordField.text = self.cellModel.titleValue;
        _leftLabel.text = self.cellModel.titleText;
        _midPasswordField.placeholder = self.cellModel.textPlaceHolder;
        _midPasswordField.textAlignment = self.cellModel.textAlignment;
        _constraint_left_midPasswordField.constant  = self.cellModel.valueMarginLeft;
        [self setRightImage:self.cellModel.rightImage];
        [self setLeftImage:self.cellModel.titleImgName];
    }
}
@end
