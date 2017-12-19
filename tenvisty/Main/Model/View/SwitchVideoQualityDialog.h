//
//  SwitchVideoQualityDialog_port.h
//  tenvisty
//
//  Created by Tenvis on 2017/12/19.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchVideoQualityDialog : UIView
- (void)show;
- (void)dismiss;
-(void)toggleShow;
@property (nonatomic, copy) void(^clickBlock)(NSInteger index,NSString* title);
@end
