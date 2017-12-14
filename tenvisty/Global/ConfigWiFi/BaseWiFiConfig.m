//
//  BaseWiFiConfig.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/12.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "BaseWiFiConfig.h"

@implementation BaseWiFiConfig

-(void) set:(NSString *)ssid pwd:(NSString*)password{
    self.ssid = ssid;
    self.pwd = password;
}

-(NSInteger) getWiFiIpAddressInt{
    return 0;
}

-(void) runConfig{
    
}

-(void) stopConfig{
    
}

+(id)sharedInstance{
    static BaseWiFiConfig *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}


@end
