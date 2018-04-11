//
//  ZoomContentView.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/9.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "ZoomContentView.h"
@interface ZoomContentView(){
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnFocusOut;
@property (weak, nonatomic) IBOutlet UIButton *btnFocusIn;
@property (weak, nonatomic) IBOutlet UIButton *btnZoomOut;
@property (weak, nonatomic) IBOutlet UIButton *btnZoomIn;
@property (weak, nonatomic) IBOutlet UIView *viewInnerContainer;
@end

@implementation ZoomContentView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}
-(void)setup{
    [_btnFocusOut setTitle:LOCALSTR(@"Focus Out") forState:UIControlStateNormal];
    [_btnFocusIn setTitle:LOCALSTR(@"Focus In") forState:UIControlStateNormal];
    [_btnZoomIn setTitle:LOCALSTR(@"Zoom In") forState:UIControlStateNormal];
    [_btnFocusOut setTitle:LOCALSTR(@"Zoom Out") forState:UIControlStateNormal];
    for (UIButton* btn in self.viewInnerContainer.subviews) {
        if([btn isKindOfClass:[UIButton class]]){
            [btn setBackgroundColor:Color_Transparent];
            [btn setBackgroundImage:[UIImage imageWithColor:Color_Gray wihtSize:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)clickBtn:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(ZoomView:didClickButton:type:)]){
        [self.delegate ZoomView:self didClickButton:sender type:sender.tag];
    }
}
- (IBAction)downBtn:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(ZoomView:didClickButtonDown:type:)]){
        [self.delegate ZoomView:self didClickButtonDown:sender type:sender.tag];
    }
}

- (IBAction)upBtn:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(ZoomView:didClickButtonUp:type:)]){
        [self.delegate ZoomView:self didClickButtonUp:sender type:sender.tag];
    }
}
@end
