//
//  LANSearchDevice.h
//  IOTCamViewer
//
//  Created by tutk on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSCamera.h"

@interface LANSearchDevice : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *ip;
@property NSInteger port;
@property (nonatomic, copy) NSString *ddns_user;    //mj相机属性
@property (nonatomic, assign)CameraModel cameraModel;

@end
