//
//  HXProgress.h
//  LastMissor
//
//  Created by HXjiang on 16/6/29.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwsProgress : UIView

+ (void)showProgress;
+ (void)showProgressWithSize:(CGSize)size;
+ (void)showProgressWithSize:(CGSize)size withColor:(UIColor *)color;

+ (void)showText:(NSString *)text durationTime:(NSInteger)time;
+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text transform:(CGFloat)rotate;
+ (void)showText:(NSString *)text withSize:(CGSize)size durationTime:(NSTimeInterval)time;
+ (void)showText:(NSString *)text withSize:(CGSize)size withColor:(UIColor *)color withDismissTime:(NSTimeInterval)seconds;

+ (void)dismiss;

+(void)setDismissBlock:(void(^)(NSString* text))dismissBlock;

@end
