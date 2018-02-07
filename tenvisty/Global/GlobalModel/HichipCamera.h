//
//  HichipCamera.h
//  tenvisty
//
//  Created by Tenvis on 2018/1/18.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCamera.h"
#import "HiCamera.h"
#import "TimeZone.h"
#import "newTimeZone.h"
#import "DeviceInfoExt.h"
#import "TimeParam.h"

@interface HichipCamera : HiCamera<BaseCameraDelegate,BaseCameraProtocol>


#pragma mark - 时区／夏令时
@property (nonatomic, strong) TimeZone *gmTimeZone;
@property (nonatomic,strong) newTimeZone* zkGmTimeZone;//20170801
@property (nonatomic,strong) BaseCamera *baseCamera;
@property (nonatomic, strong)  DeviceInfoExt *deviceInfoExt;
@property (nonatomic, strong)  TimeParam *deviceLoginTime;

- (BOOL)isGoke;
@end
