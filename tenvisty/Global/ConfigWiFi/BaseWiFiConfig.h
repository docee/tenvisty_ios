//
//  BaseWiFiConfig.h
//  tenvisty
//
//  Created by Tenvis on 2017/12/12.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WiFiConfigDelegate<NSObject>
@optional
-(void)onReceived:(NSString *)status ip:(NSString*) ip uid:(NSString*)uid;
@end

@interface BaseWiFiConfig : NSObject{
    
}

@property(nonatomic,assign) id<WiFiConfigDelegate> delegate;

@property (nonatomic,strong) NSString* ssid;
@property (nonatomic,strong) NSString* pwd;
@property (nonatomic,assign) NSInteger authMode;

+(id)sharedInstance;

-(void) runConfig;
-(void) stopConfig;

-(NSInteger) getWiFiIpAddressInt;

-(void) set:(NSString *)ssid pwd:(NSString*)password;

+(id)sharedInstance;

@end
