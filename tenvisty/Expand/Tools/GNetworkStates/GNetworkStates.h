//
//  GNetworkStates.h
//  CamHi
//
//  Created by HXjiang on 2016/11/21.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNetworkStates : NSObject

+ (NSString *)getNetworkStates;
+ (BOOL)hasNetwork;

+ (BOOL)isWiFi;

//添加公共获取WIFI SSID方法   ---20170629
+ (NSString *) getDeviceSSID;
@end
