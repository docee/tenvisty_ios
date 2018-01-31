//
//  MutilTextFieldTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/31.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "MutilTextFieldTableViewCell.h"
@interface MutilTextFieldTableViewCell()<UITextViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UILabel *labTitleText;
@property (weak, nonatomic) IBOutlet UITextView *textTitleValue;
@property (assign, nonatomic) NSInteger mLength;

@end

@implementation MutilTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textTitleValue.delegate = self;
    // Initialization code
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
    self.placeHolder = placeHolder;
    if(_textTitleValue.text.length == 0){
        _textTitleValue.text = self.placeHolder;
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = self.placeHolder;
        textView.textColor = [UIColor grayColor];
    }
    [textView resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:self.placeHolder]){
        textView.text = @"";
        textView.textColor=[UIColor blackColor];
    }
}
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if(self){
//        self.constraint_width_leftImg.constant = 0;
//    }
//    return self;
//}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string{
    if(self.mLength > 0){
        if (string.length == 0) {
            textView.text = self.placeHolder;
            textView.textColor = [UIColor grayColor];
            return YES;
        }
        textView.textColor = [UIColor blackColor];
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > self.mLength) {
            return NO;
        }
        return YES;
    }
    return YES;
}


-(void)resignFirstResponder{
    [_textTitleValue resignFirstResponder];
}

-(void)setMaxLength:(NSInteger)maxLength{
    self.mLength = maxLength;
}


@end
