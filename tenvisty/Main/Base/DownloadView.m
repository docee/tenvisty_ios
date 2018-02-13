//
//  DownloadView.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/13.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "DownloadView.h"

@implementation DownloadView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"DownloadView" owner:self options:nil];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.contentView.center = self.center;
    self.contentView.frame = self.frame;
    [self addSubview:self.contentView];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
}

-(void)refreshView{
    [self.contentView setPercent:0];
    [self.contentView setAccFile:0 total:0 desc:LOCALSTR(@"Waiting...")];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
