//
//  newTimeZone.m
//  CamHi
//
//  Created by 堃大爷 on 2017/7/14.
//  Copyright © 2017年 Hichip. All rights reserved.
//

#import "newTimeZone.h"

@implementation newTimeZone


-(instancetype)initWithData:(char* )data withSize:(int)size{
    if (self = [super init]) {
        if (size < 0) {
            return self;
        }
        
        HI_P2P_S_TIME_ZONE_EXT* model = (HI_P2P_S_TIME_ZONE_EXT* )data;
        _dst = model->u32DstMode;
        _timeName = [NSString stringWithUTF8String:model->sTimeZone];
    }
    return self;
}




- (HI_P2P_S_TIME_ZONE_EXT *)model {
    
    HI_P2P_S_TIME_ZONE_EXT *t_model = (HI_P2P_S_TIME_ZONE_EXT *)malloc(sizeof(HI_P2P_S_TIME_ZONE_EXT));
    if(t_model == nil)
        return nil;
    memset(t_model, 0, sizeof(HI_P2P_S_TIME_ZONE_EXT));
    
    
    const char * cityn = [_timeName UTF8String];
    if(strlen(cityn) > 32)
        return nil;
//    strcmp(t_model->sTimeZone, cityn);
    memcpy(t_model->sTimeZone, cityn, strlen(cityn));
    t_model->u32DstMode     = _dst;
    
    LOG(@">>>> t_model->u32DstMode:%d", t_model->u32DstMode)
    
    return t_model;
}

@end
