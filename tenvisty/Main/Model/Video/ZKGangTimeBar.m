//
//  ZKGangTimeBar.m
//  CamHi
//
//  Created by 堃大爷 on 2017/7/13.
//  Copyright © 2017年 Hichip. All rights reserved.
//

#import "ZKGangTimeBar.h"

@implementation ZKGangTimeBar

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = frame.size.width/9;
        self.layer.masksToBounds = YES;
        self.alpha = .9;
        
        [self addSubview:self.time];
    }
    return self;
}

//-(void)drawRect:(CGRect)rect{
////    [self addSubview:self.time];
//}

-(UILabel* )time{
    if (!_time) {
        _time = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame))];
        _time.adjustsFontSizeToFitWidth = YES;
        _time.textAlignment = NSTextAlignmentCenter;
        _time.textColor = [UIColor whiteColor];
        
    }
    return _time;
}

@end
