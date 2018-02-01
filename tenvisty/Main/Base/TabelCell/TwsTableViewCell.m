//
//  TwsTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/14.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TwsTableViewCell.h"

@interface TwsTableViewCell()
@property (nonatomic,strong) NSRegularExpression *regular;
@end

@implementation TwsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTextFilter:(NSString *)textFilter{
    if(textFilter == nil){
        _regular = nil;
    }
    else{
        _regular =  [[NSRegularExpression alloc] initWithPattern:textFilter options:0 error:nil];
    }
    _textFilter = textFilter;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    if(self.maxLength > 0){
        if (string.length == 0) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > self.maxLength) {
            return NO;
        }
    }
    if(_regular){
        //char commitChar = [string characterAtIndex:0];
        NSInteger matchCount = [_regular numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
        if(matchCount < 1){
            return NO;
        }
        
//        if((commitChar > 96 && commitChar < 123)|| (commitChar < 91 && commitChar > 64) || (commitChar > 47 && commitChar < 58) ||commitChar == 45){
//            if (commitChar > 96 && commitChar < 123 ){
//                NSString * uppercaseString = string.uppercaseString;
//                NSString * str1 = [textField.text substringToIndex:range.location];
//                NSString * str2 = [textField.text substringFromIndex:range.location];
//                textField.text = [[NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2] uppercaseString];// [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2].uppercaseString;
//                return NO;
//            }
//        }
//        else{
//            return NO;
//        }
    }
    //    NSCharacterSet *cs;
    //    cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    //    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    //    BOOL basicTest = [string isEqualToString:filtered];
    //    if(!basicTest)  {
    //        return NO;
    //    }
//    if(self.autoUppercase){
//        NSString * str1 = [textField.text substringToIndex:range.location];
//        NSString * str2 = [textField.text substringFromIndex:range.location];
//        textField.text = [[NSString stringWithFormat:@"%@%@%@",str1,string,str2] uppercaseString];
//    }
    if(self.autoUppercase){
        NSString * uppercaseString = string.uppercaseString;
        NSString * str1 = [textField.text substringToIndex:range.location];
        NSString * str2 = [textField.text substringFromIndex:range.location];
        textField.text = [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2];// [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2].uppercaseString;
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    if(self.maxLength > 0){
        if (textField.text.length > self.maxLength) {
            textField.text = [textField.text substringToIndex:self.maxLength];
        }
    }
    if(self.autoUppercase){
        textField.text = [textField.text uppercaseString];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string{
    if(self.maxLength > 0){
        if (string.length == 0) {
            return YES;
        }
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > self.maxLength) {
            return NO;
        }
    }
    if(_regular){
        NSInteger matchCount = [_regular numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
        if(matchCount < 1){
            return NO;
        }
    }
    if(self.autoUppercase){
        NSString * uppercaseString = string.uppercaseString;
        NSString * str1 = [textView.text substringToIndex:range.location];
        NSString * str2 = [textView.text substringFromIndex:range.location];
        textView.text = [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2];// [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2].uppercaseString;
        return NO;
    }
    return YES;
}


@end
