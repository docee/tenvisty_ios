//
//  CameraFunction.c
//  TWSCamHi
//
//  Created by Tenvis on 17/3/16.
//  Copyright © 2017年 Hichip. All rights reserved.
//

#include "CameraFunction.h"
#import <ifaddrs.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "GBase.h"
#import "GNetworkStates.h"

@implementation CameraFunction

+(NSString*)intToIP:(NSInteger)i{
    return [NSString stringWithFormat:@"@%.@%.@%.@%",i&0xFF,(i << 8)&0xFF, (i<<16)&0xFF, (i<<24)&0xFF];
}

+(NSInteger)ipToInt:(NSString*)ip{
    NSInteger intIP = 0;
    NSArray* splitNum = [ip componentsSeparatedByString:@"."];
    NSInteger count = [splitNum count];
    for(int i=0; i<count; i++){
        intIP += [(NSString *)[splitNum objectAtIndex:i] integerValue] << i*8;
    }
    return intIP;
}

+(BOOL)isSameNetwokr:(NSInteger)cameraIP netmask:(NSInteger)cameraNetmask{
    if([CameraFunction isWiFiConnected]){
        NSArray *phoneNetP = [CameraFunction getIpAddresses];
        NSInteger intPhoneIP = [CameraFunction ipToInt:[phoneNetP objectAtIndex:0]];
        NSInteger intPhoneNetmask = [CameraFunction ipToInt:[phoneNetP objectAtIndex:1]];
        if(intPhoneIP != cameraIP && intPhoneNetmask == cameraNetmask){
            return (intPhoneIP&intPhoneNetmask) == (cameraIP&cameraNetmask);
        }
        
    }
    return NO;
}

+(BOOL)isWiFiEnabled{
    NSCountedSet *cset = [[NSCountedSet alloc]init];
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)){
        for(struct ifaddrs *interface = interfaces;interface;interface = interface ->ifa_next){
            if((interface->ifa_flags & IFF_UP)==IFF_UP){
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"]>1?YES:NO;
}

+(BOOL)isWiFiConnected{
    return [GNetworkStates isWiFi];
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
//    //获得到网络返回码
//    for(id child in children){
//        if([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]){
//            int netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
//            NSLog(@"netType:%@",@(netType));
//            if(netType == 5){
//                NSLog(@"WIFI");
//                return YES;
//            }
//            else{
//                 NSLog(@"%dG",netType+1);
//                return NO;
//            }
//        }
//    }
//    NSLog(@"not open network or no network");
//    return NO;
}

+(NSArray *)getIpAddresses{
    NSString *address = @"error";
    NSString *netmask = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if(success == 0){
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET){
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]){
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return [[NSArray alloc] initWithObjects:address,netmask, nil];
}


+(void) DoCameraFunctionFlag:(BaseCamera *)camera ip:(NSString*)ip netmask:(NSString*)netmask{
    if([CameraFunction isSameNetwokr:[CameraFunction ipToInt:ip] netmask:[CameraFunction ipToInt:netmask]]){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *getFunctionUrl = [NSString stringWithFormat:@"http://%@/web/function.ini",ip];
            NSString* functionStringURL = [getFunctionUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* url2 = [NSURL URLWithString:functionStringURL];
            //NSString *getUIDUrl = [NSString stringWithFormat:@"http://%@/web/cgi-bin/hi3510/param.cgi?cmd=gethip2pattr",ip];
            //NSString* webStringURL = [getUIDUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSURL* url1 = [NSURL URLWithString:webStringURL];
           // NSLog(@"webStringURL = %@", webStringURL);
            
            //創建一個請求
           // NSURLRequest * pRequest = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
            NSMutableURLRequest *pRequest = [NSMutableURLRequest requestWithURL:url2 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:3];
            NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"admin", camera.pwd];
            NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
            NSString *authValue = [authData base64Encoding];
            [pRequest setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
           
            [NSURLConnection sendAsynchronousRequest:pRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
                if(((NSHTTPURLResponse *)response).statusCode == 200 && data != nil && connectionError == nil){
                      NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if ([responseStr length] != 0) {
                        [camera setStrFunctionFlag:responseStr];
                        [GBase setCameraFunction:camera.uid function:responseStr];
                    }
                }
            }];
            
        });
    }
}

@end
