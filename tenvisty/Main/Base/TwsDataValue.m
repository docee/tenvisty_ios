//
//  TwsDataValue.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/29.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "TwsDataValue.h"
@interface TwsDataValue(){
  
}
@end

static   BaseCamera *tryCamera;
@implementation TwsDataValue

+ (BaseCamera*) getTryConnectCamera{
    return tryCamera;
}
+(void) setTryConnectCamera:(BaseCamera*)camera{
    if(tryCamera != camera && tryCamera != nil){
        BOOL added = NO;
        for(BaseCamera *c in [GBase sharedInstance].cameras){
            if(c == tryCamera){
                added = YES;
                break;
            }
        }
        if(!added){
            [tryCamera stop];
        }
    }
    tryCamera = camera;
}

@end
