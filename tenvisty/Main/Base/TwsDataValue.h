//
//  TwsDataValue.h
//  tenvisty
//
//  Created by Tenvis on 2018/1/29.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwsDataValue : NSObject
+ (BaseCamera*) getTryConnectCamera;
+(void) setTryConnectCamera:(BaseCamera*)camera;
@end
