//
//  SelectTime.h
//  ThomView
//
//  Created by Tenvis on 16/12/27.
//  Copyright © 2016年 Hichip. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SelectTime : UIView

@property (nonatomic, strong) NSDate *fromTime;
@property (nonatomic, strong) NSDate *toTime;

@property (nonatomic, copy) void(^cancelBlock)();
@property (nonatomic, copy) void(^okBlock)(NSDate *fromTime,NSDate * toTime);

+ (SelectTime *)sharedInstance;
+ (void)show;
+ (void)dismiss;
+ (void)show :(NSDate*)fromTime toTime:(NSDate*)toTime;

@end
