//
//  GNetworkStates.m
//  CamHi
//
//  Created by HXjiang on 2016/11/21.
//  Copyright © 2016年 Hichip. All rights reserved.
//


#import <SystemConfiguration/CaptiveNetwork.h>
#import "GNetworkStates.h"
#import "Reachability.h"
#import <objc/message.h>

@implementation GNetworkStates

//20171106 ZK new ADD:
+(NSString *)internetStatus {
    
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"wifi";
    
    switch (internetStatus) {
            
        case ReachableViaWiFi:
            
            net = @"wifi";
            
            break;
            
        case ReachableViaWWAN:
            
            net = @"3G/4G";
            
            break;
            
        case NotReachable:
            
            net = @"No Network";
            
        default:
            
            break;
            
    }
    NSLog(@"当前网络  %@",net);
    return net;
}

// 从状态栏中获取网络类型
+ (NSString *)getNetworkStates {
    
    UIApplication *application = [UIApplication sharedApplication];
    NSString *state = nil;
    NSArray *children = [[[application valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int netType = 0;
    
    // 获取网络返回码
    for (id child in children) {
        
        //NSLog(@"child = %@", child);
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            // 获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            NSLog(@"netType = %d", netType);
            
            switch (netType) {
                case 0:
                    state = @"No Networdk"; // 无网络
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"wifi";
                    break;
                    
                    
                default:
                    break;
            }// @switch
            
        } else {
            if (!state) {
                state = @"No Network";
            }
            
        }// @isKindOfClass
        
    }// @for
    
    return state;
}

+ (BOOL)hasNetwork {
    NSString* netType = nil;
    if (zkDevice_IsiPhoneXOrBigger_SafeArea || zkDevice_IsiPhoneXOrBigger) {
        netType = [self internetStatus];
    }else{
        netType = [self getNetworkStates];
    }
    
    if ([netType isEqualToString:@"No Network"]) {
        return NO;
    }
    
    return YES;
}
+ (BOOL)isWiFi {
    NSString* netType = nil;
    if (zkDevice_IsiPhoneXOrBigger_SafeArea || zkDevice_IsiPhoneXOrBigger) {
        netType = [self internetStatus];
    }else{
        netType = [self getNetworkStates];
    }
    
    if ([netType isEqualToString:@"wifi"]) {
        return NO;
    }
    
    return YES;
}

+ (NSString *) getDeviceSSID {
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    
    NSDictionary *dctySSID = (NSDictionary *)info;
    //    NSString *ssid = [[dctySSID objectForKey:@"SSID"] lowercaseString];
    NSString *ssid = [dctySSID objectForKey:@"SSID"];
    return ssid;
    
}

@end
