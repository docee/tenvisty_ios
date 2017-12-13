//
//  TimeScheduleViewController.h
//  ThomView
//
//  Created by Tenvis on 16/12/27.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "ViewController.h"
@protocol SetScheduleDelegate <NSObject>

//@optional
- (void)didSetSchedule:(NSInteger)type fromTime:(NSDate *)fromTime toTime:(NSDate *)toTime;


@end
@interface TimeScheduleViewController : ViewController

@property (nonatomic, assign) id<SetScheduleDelegate> delegate;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSDate *fromTime;
@property (nonatomic, strong) NSDate *toTime;
@end
