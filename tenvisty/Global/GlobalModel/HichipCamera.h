//
//  HichipCamera.h
//  tenvisty
//
//  Created by Tenvis on 2018/1/18.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCamera.h"
#import "HiCamera.h"

@interface HichipCamera : HiCamera<BaseCameraDelegate,BaseCameraProtocol>


@property (nonatomic,strong) BaseCamera *baseCamera;
@end
