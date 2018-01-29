//
//  WiFiConfigContext.h
//  tenvisty
//
//  Created by Tenvis on 2017/12/12.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWiFiConfig.h"

@interface WiFiConfigContext : NSObject
+(id)sharedInstance;
-(void) setReceiveListner:(id<WiFiConfigDelegate>)delegate;

-(void) clearReceiveListner;

-(void) add:(BaseWiFiConfig*)config;

-(void) setData:(NSString*)uid ssid:(NSString*)ssid password:(NSString*)pwd auth:(NSInteger)authMode;

-(void) startConfig;

-(void) stopConfig;

-(BOOL) isRunning;
@end
