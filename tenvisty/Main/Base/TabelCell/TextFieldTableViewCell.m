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
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *constraint_trail_textField;

@property (nonatomic,assign) NSInteger mLength;
@end

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.constraint_width_leftImg.constant = 0;
    self.constraint_trail_textField.constant = 0;
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


-(NSString*)value{
    return _rightTextField.text;
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

-(void)resignFirstResponder{
    [_rightTextField resignFirstResponder];
}

-(void)setCellModel:(ListImgTableViewCellModel *)cellModel{
    [super setCellModel:cellModel];
    [self refreshCell];
}

-(void)refreshCell{
    [super refreshCell];
    if(self.cellModel){
        _rightTextField.text = self.cellModel.titleValue;
        _leftLabel.text = self.cellModel.titleText;
        _rightTextField.placeholder = self.cellModel.textPlaceHolder;
        _rightLabel.text = self.cellModel.rightDesc;
        [self setLeftImage:self.cellModel.titleImgName];
        if(self.cellModel.rightDesc && self.cellModel.rightDesc.length > 0){
            self.constraint_trail_textField.constant = 15;
        }
        if([self.cellModel.textFilter isEqualToString:REGEX_NUMBER]){
            _rightTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
}

@end
