//
//  ZoomContentView.h
//  tenvisty
//
//  Created by Tenvis on 2018/2/9.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BTN_ZOOM_IN 0
#define BTN_ZOOM_OUT 1
#define BTN_FOCUS_IN 2
#define BTN_FOCUS_OUT 3


@protocol ZoomViewDelegate;
@interface ZoomContentView : UIView

@property (nonatomic,assign) id<ZoomViewDelegate> delegate;
@end

@protocol ZoomViewDelegate <NSObject>
@optional
- (void)ZoomView:(ZoomContentView *)view didClickButton:(UIButton*)btn type:(NSInteger)type;
- (void)ZoomView:(ZoomContentView *)view didClickButtonDown:(UIButton*)btn type:(NSInteger)type;
- (void)ZoomView:(ZoomContentView *)view didClickButtonUp:(UIButton*)btn type:(NSInteger)type;
@end
