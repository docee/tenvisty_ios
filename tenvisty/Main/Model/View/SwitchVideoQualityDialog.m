//
//  SwitchVideoQualityDialog_port.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/19.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SwitchVideoQualityDialog.h"

@interface SwitchVideoQualityDialog(){
    
}
@property (nonatomic,assign)  BOOL isShow;


@end

@implementation SwitchVideoQualityDialog

- (IBAction)dsfdsf:(UIButton *)sender {
    if (_clickBlock) {
        _clickBlock(sender.tag,sender.currentTitle);
    }
}

- (IBAction)onClick:(UIButton *)sender {
    if (_clickBlock) {
        _clickBlock(sender.tag,sender.currentTitle);
    }
}
- (IBAction)sdf:(UIButton *)sender {
    if (_clickBlock) {
        _clickBlock(sender.tag,sender.currentTitle);
    }
}

- (void)show {
    
    _isShow = !_isShow;
    [self setHidden:NO];
//    __block CGRect currentframe = self.frame;
//    __weak typeof(self) weakSelf = self;
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        currentframe.origin.y += (2*currentframe.size.height + 84);
//        weakSelf.frame = currentframe;
//    }];
    
}
-(void)toggleShow{
    if(_isShow){
        [self dismiss];
    }
    else{
        [self show];
    }
}


- (void)dismiss {
    
    _isShow = !_isShow;
    
    [self setHidden:YES];
//    __block CGRect currentframe = self.frame;
//    __weak typeof(self) weakSelf = self;
//
//    [UIView animateWithDuration:0.5 animations:^{
//
//        currentframe.origin.y -= (2*currentframe.size.height + 84);
//        weakSelf.frame = currentframe;
//    }];
    
}


@end
