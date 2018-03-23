//
//  AoniWiFiConfig.m
//  tenvisty
//
//  Created by Tenvis on 2018/3/23.
//  Copyright © 2018年 Tenvis. All rights reserved.
//
#import <netinet/in.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#import "AoniWiFiConfig.h"
#import "cooee.h"
@interface AoniWiFiConfig(){
    const char *_pwd2;
    const char *_ssid2;
    const char *_KEY;
    unsigned int _ip;
    long times;
}
@property (nonatomic,assign) BOOL isStop6212;
@end

@implementation AoniWiFiConfig
-(void) runConfig{
    times = 0;
    _isStop6212 = NO;
    if (!_isStop6212) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (!_isStop6212) {
                _pwd2 = [self.pwd UTF8String];
                _ssid2 = [self.ssid UTF8String];
                _KEY = [@"" UTF8String];
                struct in_addr addr;
                inet_aton([[AoniWiFiConfig getIPAddress] UTF8String], &addr);
                _ip = CFSwapInt32BigToHost(ntohl(addr.s_addr));
                NSLog(@"StartCooee");
                NSLog(@"SSID = %s , len = %lu " , _ssid2 , strlen(_ssid2));
                NSLog(@"PWD = %s , len = %lu ", _pwd2, strlen(_pwd2));
                NSLog(@"[self getIPAddress] = %@" , [AoniWiFiConfig getIPAddress]);
                NSLog(@"ip = %08x", _ip);
                //        NSString * strSSIDSuffix = [_cameraUid substringFromIndex:_cameraUid.length - 8];
                NSString *strSSIDSuffix = @"AONI_IPC";
                //备注:路由器加密类型和认证方式由0，0 改为 4，4
                NSString * strSSID = [NSString stringWithFormat:@"%@:%@:%d:%d:%d", self.ssid, strSSIDSuffix, 0, 4, 4];
                _ssid2 = [strSSID UTF8String];
                send_cooee(_ssid2, (int)strlen(_ssid2), _pwd2, (int)strlen(_pwd2), _KEY, 0, _ip);
                times++;
                if(times % 100 == 0){
                    sleep(500);
                }
            }
        });
    }
}

-(void) stopConfig{
    _isStop6212 = YES;
}

+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr -> ifa_name] isEqualToString: @"en0"]){
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr -> ifa_addr) -> sin_addr)];
                }
            }
            temp_addr = temp_addr -> ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
