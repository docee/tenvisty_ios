//
//  TwsAutoKeyboardTextField.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/1.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "TwsAutoKeyboardTextField.h"

@implementation TwsAutoKeyboardTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (void)setNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//}
//- (void)closeNotification
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//}

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
//- (void)keyboardWillChangeFrame:(NSNotification *)notification {
//    if(!self.isFirstResponder){
//        return;
//    }
//    NSDictionary *dict = [notification userInfo];
//    // 键盘弹出和收回的时间
//    CGFloat duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    // 键盘初始时刻的frame
//    CGRect beginKeyboardRect = [[dict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    // 键盘停止后的frame
//    CGRect endKeyboardRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    // 相减为键盘高度
//    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
//    int curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
////    // 创建appDelegate单例对象
////    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////    // 初始化一个数组,UIWindow的所有子视图
////    NSArray *array = appDelegate.window.subviews;
////    // 获取当前Controller的view视图
////    UIView *view = appDelegate.window.subviews[array.count - 1];
//    // textField相对于UIWindow的frame
//    UIView *view = nil;
//    UIViewController *controller = [TwsAutoKeyboardTextField getCurrentVC];
//    for(UITableView *tablev in controller.view.subviews){
//        if([tablev isKindOfClass:[UITableView class]] || [tablev.superview isKindOfClass:[UITableView class]]){
//            view = tablev;
//            break;
//        }
//    }
//    CGRect selfFrameFromUIWindow = [self convertRect:self.bounds toView:view];
//    // textField底部距离屏幕底部的距离
//    CGFloat bottomHeight = [UIScreen mainScreen].bounds.size.height - selfFrameFromUIWindow.origin.y - selfFrameFromUIWindow.size.height;
//    
////    // 初始化一个frame,大小为UIWindow的frame
////    CGRect windowFrame = appDelegate.window.frame;
////    // 把这个frame的y值增加或减少相应的高度(这里的40是textField底部和键盘顶部的距离)
////    windowFrame.origin.y += yOffset + bottomHeight - 40;
//    // 根据yOffset判断键盘是弹出还是收回
//    if(yOffset>0 ||  bottomHeight > -yOffset + 80){
//        [UIView animateWithDuration:duration animations:^{
//            [UIView setAnimationCurve:curve];
//            view.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];
//    }
//    else{
//        [UIView animateWithDuration:duration animations:^{
//            [UIView setAnimationCurve:curve];
//            view.transform = CGAffineTransformMakeTranslation(0, yOffset);
//        }];
//    }
////    if (yOffset < 0) {
////        if(bottomHeight > (-yOffset + 100)){
////            windowFrame.origin.y = 0;
////        }
////        // 键盘弹出,改变当前Controller的view的frame
////        [UIView animateWithDuration:duration animations:^{
////            view.frame = windowFrame;
////        }];
////    } else if(yOffset > 0){
////        // 键盘收回,把view的frame恢复原状
////        [UIView animateWithDuration:duration animations:^{
////            view.frame = appDelegate.window.frame;
////        }];
////    }
//}
@end
