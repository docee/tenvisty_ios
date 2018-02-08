//
//  VideoProgressBarContentView.h
//  tenvisty
//
//  Created by Tenvis on 2018/2/7.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoProgressBarContentView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_btnExit;

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *labPlayTime;
@property (weak, nonatomic) IBOutlet UILabel *labEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnExit;
@property (weak, nonatomic) IBOutlet UISlider *sliderProgress;
@end
