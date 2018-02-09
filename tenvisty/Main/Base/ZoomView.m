//
//  ZoomView.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/9.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "ZoomView.h"
@interface ZoomView()<ZoomViewDelegate>{
    
}

@property (nonatomic, weak) IBOutlet ZoomContentView *contentView;
@end

@implementation ZoomView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"ZoomView" owner:self options:nil];
    self.contentView.delegate = self;
    self.frame = self.contentView.frame;
    [self addSubview:self.contentView];
}

- (void)ZoomView:(ZoomContentView *)view didClickButton:(UIButton*)btn type:(NSInteger)type{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ZoomView:didClickButton:type:)]){
        [self.delegate ZoomView:view didClickButton:btn type:type];
    }
}

- (void)ZoomView:(ZoomContentView *)view didClickButtonDown:(UIButton*)btn type:(NSInteger)type{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ZoomView:didClickButtonDown:type:)]){
        [self.delegate ZoomView:view didClickButtonDown:btn type:type];
    }
}
- (void)ZoomView:(ZoomContentView *)view didClickButtonUp:(UIButton*)btn type:(NSInteger)type{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ZoomView:didClickButtonUp:type:)]){
        [self.delegate ZoomView:view didClickButtonUp:btn type:type];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
