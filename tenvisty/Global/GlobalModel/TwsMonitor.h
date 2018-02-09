//
//  TwsMonitor.h
//  tenvisty
//
//  Created by Tenvis on 2018/2/9.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCamera.h"

@protocol TwsMonitorTouchDelegate;
@interface TwsMonitor : UIImageView
@property (nonatomic, assign) IBOutlet id<TwsMonitorTouchDelegate> delegate;

- (void)setMinimumGestureLength:(NSInteger)length MaximumVariance:(NSInteger)variance;
- (void)attachCamera:(BaseCamera *)camera;
- (void)deattachCamera;
@end
@protocol TwsMonitorTouchDelegate <NSObject>
@optional
- (void)monitor:(TwsMonitor *)monitor gestureSwiped:(TwsCameraDirection)direction;
- (void)monitor:(TwsMonitor *)monitor gesturePinched:(CGFloat)scale;
@end
