//
//  WifiAp.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "WifiCheck.h"

@implementation WifiCheck

+ (NSString *)getUnsupportedStr:(NSString *)text{
    if(text == nil || [text length] == 0){
        return @"";
    }
    NSString *unSupportedStr = @"";
    int preChar = 0;
    for (int i = 0; i < [text length]; i++) {
        int chr = [text characterAtIndex:i];
        if(chr >= 32 && chr <127){
            if(chr == '`' || chr == '\"' || ((i == 0 || i == [text length] -1) && chr == '\\')){
                if([unSupportedStr rangeOfString:[NSString stringWithFormat:@"%c",chr]].location == NSNotFound){
                    unSupportedStr = [NSString stringWithFormat:@"%@%c ",unSupportedStr,chr];
                }
            }
            else if(((chr == '(' || chr =='[' || chr == '{') && preChar == '$') || (chr == '\\' && preChar == '\\')){
                if([unSupportedStr rangeOfString:[NSString stringWithFormat:@"%c%c",preChar, chr]].location == NSNotFound){
                    unSupportedStr = [NSString stringWithFormat:@"%@%c%c ",unSupportedStr,preChar, chr];
                }
            }
            else{
                preChar = chr;
            }
        }else{
            if(chr != 0){
                if([unSupportedStr rangeOfString:[NSString stringWithFormat:@"%c", chr]].location == NSNotFound){
                    unSupportedStr = [NSString stringWithFormat:@"%@%c ",unSupportedStr, chr];
                }

            }
        }
    }
    return unSupportedStr;
}
@end
