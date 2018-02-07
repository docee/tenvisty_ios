//
//  VideoProgressBarView.h
//  tenvisty
//
//  Created by Tenvis on 2018/2/7.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoProgressBarContentView.h"

@protocol VideoProgressBarDelegate;

@interface VideoProgressBarView : UIView
@property (nonatomic,assign) id<VideoProgressBarDelegate> delegate;
@property (nonatomic, weak) IBOutlet VideoProgressBarContentView *view;
- (void)show;
- (void)dismiss;
-(void)setTime:(long)nowTime start:(long)startTime end:(long)endTime;
@end

@protocol VideoProgressBarDelegate <NSObject>
@optional
- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didClickPlayButton:(UIButton*)btn;
- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didClickExitButton:(UIButton*)btn;
- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didEndSliderChanging:(UISlider*)sender time:(long)time;
- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didSliderChanging:(UISlider*)sender time:(long)time;
- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didClickSlider:(UISlider*)sender time:(long)time;

@end
