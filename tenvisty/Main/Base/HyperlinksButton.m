//
//  HyperlinksButton.m
//  tenvisty
//
//  Created by lu yi on 1/23/18.
//  Copyright © 2018 Tenvis. All rights reserved.
//

#import "HyperlinksButton.h"


@implementation HyperlinksButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    lineColor = self.titleLabel.textColor;
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
       lineColor = self.titleLabel.textColor;
        
        // underline Terms and condidtions
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
        
        //设置下划线...
        /*
         NSUnderlineStyleNone                                    = 0x00, 无下划线
         NSUnderlineStyleSingle                                  = 0x01, 单行下划线
         NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
         NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
         */
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        //此时如果设置字体颜色要这样
        [tncString addAttribute:NSForegroundColorAttributeName value:lineColor  range:NSMakeRange(0,[tncString length])];
        
        //设置下划线颜色...
        [tncString addAttribute:NSUnderlineColorAttributeName value:lineColor range:(NSRange){0,[tncString length]}];
        [self setAttributedTitle:tncString forState:UIControlStateNormal];
        
    }
    return self;
}


-(void)setColor:(UIColor *)color{
    lineColor = [color copy];
    [self setNeedsDisplay];
}

@end
