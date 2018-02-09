//
//  PresetContentView.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/9.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "PresetContentView.h"

@interface PresetContentView(){
    NSInteger accPoint;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSet;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIView *viewPresetPointContainer;
@property (weak, nonatomic)  UIButton *preClickPoint;

@end

@implementation PresetContentView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}

-(void)setup{
    [_btnSet setBackgroundImage:[UIImage imageWithColor:Color_GrayDark wihtSize:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
    [_btnCall setBackgroundImage:[UIImage imageWithColor:Color_GrayDark wihtSize:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
    for (UIButton* btn in self.viewPresetPointContainer.subviews) {
        if([btn isKindOfClass:[UIButton class]]){
            [btn setBackgroundColor:Color_Transparent];
            [btn setBackgroundImage:[UIImage imageWithColor:Color_Gray wihtSize:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:Color_GrayDark wihtSize:CGSizeMake(1.0, 1.0)] forState:UIControlStateSelected];
        }
    }
}
- (IBAction)tapView:(id)sender {
}

- (IBAction)clickSet:(UIButton*)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(PresetContentView:didClickButton:type:point:)]){
        [self.delegate PresetContentView:self didClickButton:sender type:BTN_PRESET_SET point:accPoint];
    }
}
- (IBAction)clickCall:(UIButton*)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(PresetContentView:didClickButton:type:point:)]){
        [self.delegate PresetContentView:self didClickButton:sender type:BTN_PRESET_CALL point:accPoint];
    }
}
- (IBAction)clickPoint:(UIButton*)sender {
    sender.selected = YES;
    if(self.preClickPoint){
        self.preClickPoint.selected = NO;
    }
    accPoint = sender.tag;
    self.preClickPoint = sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(PresetContentView:didClickButton:type:point:)]){
        [self.delegate PresetContentView:self didClickButton:sender type:BTN_PRESET_POINT point:accPoint];
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
