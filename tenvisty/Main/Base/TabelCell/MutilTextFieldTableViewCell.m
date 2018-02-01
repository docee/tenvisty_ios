//
//  MutilTextFieldTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/31.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "MutilTextFieldTableViewCell.h"
#import "TwsAutoKeyboardTextView.h"
@interface MutilTextFieldTableViewCell(){
    
}
@property (weak, nonatomic) IBOutlet UILabel *labTitleText;
@property (weak, nonatomic) IBOutlet TwsAutoKeyboardTextView *textTitleValue;
@property (assign, nonatomic) NSInteger mLength;

@end

@implementation MutilTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textTitleValue.delegate = self;
    // Initialization code
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    //UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:LOCALSTR(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(resignFirstResponder)];
    doneButton.tintColor = [UIColor blackColor];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [_textTitleValue setInputAccessoryView:topView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)title{
    return _labTitleText.text;
}

-(void)setTitle:(NSString*)t{
    _labTitleText.text = t;
}

-(NSString*)value{
    return _textTitleValue.text;
}

-(void)setValue:(NSString*)t{
    _textTitleValue.text = t;
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    [super setPlaceHolder:placeHolder];
//    if(_textTitleValue.text.length == 0){
//        _textTitleValue.text = self.placeHolder;
//    }
}
//#pragma mark - UITextViewDelegate
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if(textView.text.length < 1){
//        textView.text = self.placeHolder;
//        textView.textColor = Color_GrayLightest;
//    }
//}
//
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if([textView.text isEqualToString:self.placeHolder]){
//        textView.text = @"";
//        textView.textColor=[UIColor blackColor];
//    }
//}

-(void)resignFirstResponder{
    [_textTitleValue resignFirstResponder];
    [_textTitleValue refreshLocateView];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [_textTitleValue relocateView];
    return YES;
}


@end
