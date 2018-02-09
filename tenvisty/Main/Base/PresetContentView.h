//
//  PresetContentView.h
//  tenvisty
//
//  Created by Tenvis on 2018/2/9.
//  Copyright © 2018年 Tenvis. All rights reserved.
//
#define BTN_PRESET_CALL 0
#define BTN_PRESET_SET 1
#define BTN_PRESET_POINT 2

#import <UIKit/UIKit.h>
@protocol PresetViewDelegate;


@interface PresetContentView : UIView
@property (nonatomic,assign) id<PresetViewDelegate> delegate;
@end

@protocol PresetViewDelegate <NSObject>
@optional
- (void)PresetContentView:(PresetContentView *)view didClickButton:(UIButton*)btn type:(NSInteger)btnType point:(NSInteger)point;
@end
