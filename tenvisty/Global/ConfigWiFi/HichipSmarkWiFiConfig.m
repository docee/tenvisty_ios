//
//  HichipSmarkWiFiConfig.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/29.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "HichipSmarkWiFiConfig.h"
#import "HiSmartLink.h"

@implementation HichipSmarkWiFiConfig
-(void) runConfig{
    HiStartSmartConnection(self.ssid.UTF8String, self.pwd.UTF8String);
}

-(void) stopConfig{
    HiStopSmartConnection();
}
@end
