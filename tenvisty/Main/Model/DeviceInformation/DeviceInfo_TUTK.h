//
//  DeviceInfo_TUTK.h
//  tenvisty
//
//  Created by Tenvis on 2018/3/28.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo_TUTK : NSObject

@property (nonatomic, assign) unsigned int free;
@property (nonatomic, assign) unsigned int total;
@property (nonatomic,strong) NSString *model;
@property (nonatomic,strong) NSString *vendor;

- (id)initWithData:(char *)data size:(int)size;
@end
