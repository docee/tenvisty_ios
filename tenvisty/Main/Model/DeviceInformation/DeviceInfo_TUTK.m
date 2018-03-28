//
//  DeviceInfo_TUTK.m
//  tenvisty
//
//  Created by Tenvis on 2018/3/28.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "DeviceInfo_TUTK.h"

@implementation DeviceInfo_TUTK

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        if (size < 0) {
            return self;
        }
        SMsgAVIoctrlDeviceInfoResp *model = (SMsgAVIoctrlDeviceInfoResp *)malloc(sizeof(SMsgAVIoctrlDeviceInfoResp));
        memset(model, 0, sizeof(SMsgAVIoctrlDeviceInfoResp));
        memcpy(model, data, size);
        self.free = model->free;
        self.total = model->total;
        self.model = [NSString stringWithUTF8String:(char *)model->model];
        self.vendor = [NSString stringWithUTF8String:(char *)model->vendor];
        
        free(model);
        model = nil;
    }
    return self;
}
@end
