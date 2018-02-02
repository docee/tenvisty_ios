//
//  TwsAutoKeyboardTextView.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/1.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "TwsAutoKeyboardTextView.h"

@implementation TwsAutoKeyboardTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)relocateView{
    UIView *view = nil;
    UIViewController *controller = [TwsTools getCurrentVC];
    for(UITableView *tablev in controller.view.subviews){
        if([tablev isKindOfClass:[UITableView class]] || [tablev.superview isKindOfClass:[UITableView class]]){
            view = tablev;
            break;
        }
    }
    CGRect selfFrameFromUIWindow = [self convertRect:self.bounds toView:view];
    // textField底部距离屏幕底部的距离
    CGFloat bottomHeight = [UIScreen mainScreen].bounds.size.height - selfFrameFromUIWindow.origin.y - selfFrameFromUIWindow.size.height;
    CGFloat yOffset = [UIScreen mainScreen].bounds.size.height *2/3;
    if(bottomHeight > yOffset){
        [UIView animateWithDuration:0.25f animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    else{
        [UIView animateWithDuration:0.25f animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, bottomHeight - yOffset);
        }];
    }
}
- (void)refreshLocateView{
    UIView *view = nil;
    UIViewController *controller = [TwsTools getCurrentVC];
    for(UITableView *tablev in controller.view.subviews){
        if([tablev isKindOfClass:[UITableView class]] || [tablev.superview isKindOfClass:[UITableView class]]){
            view = tablev;
            break;
        }
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

-(BOOL)resignFirstResponder{
   BOOL result = [super resignFirstResponder];
    [self refreshLocateView];
    return result;
}
@end
