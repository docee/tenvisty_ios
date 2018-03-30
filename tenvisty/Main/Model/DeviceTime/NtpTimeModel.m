//
//  NtpTimeModel.m
//  tenvisty
//
//  Created by Tenvis on 2018/3/30.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "NtpTimeModel.h"

@implementation NtpTimeModel
- (id)initWithData:(char *)data size:(int)size{
    if(size < 61){
        return nil;
    }
    if (self = [super init]) {
        
        SMsgAVIoctrlSetNtpConfigReq *model = (SMsgAVIoctrlSetNtpConfigReq *)malloc(sizeof(SMsgAVIoctrlSetNtpConfigReq));
        memset(model, 0, sizeof(SMsgAVIoctrlSetNtpConfigReq));
        memcpy(model, data, size);
        _u32Year    = model->time.year;
        _u32Month   = model->time.month;
        _u32Day     = model->time.date;
        _u32Hour    = model->time.hour;
        _u32Minute  = model->time.minute;
        _u32Second  = model->time.second;
        _u32Timezone = model->TimeZone;
        _u32Mode = model->mod;
        _strNtpServer = [NSString stringWithUTF8String:(char *)model->Server];
        free(model);
        model = nil;
    }
    return self;
}
- (SMsgAVIoctrlSetNtpConfigReq *)model{
    SMsgAVIoctrlSetNtpConfigReq *tmodel = (SMsgAVIoctrlSetNtpConfigReq *)malloc(sizeof(SMsgAVIoctrlSetNtpConfigReq));
    memset(tmodel, 0, sizeof(SMsgAVIoctrlSetNtpConfigReq));
    tmodel->time.year = _u32Year;
    tmodel->time.month = _u32Month;
    tmodel->time.date = _u32Day;
    tmodel->time.hour = _u32Hour;
    tmodel->time.minute = _u32Minute;
    tmodel->time.second = _u32Second;
    tmodel->TimeZone = _u32Timezone;
    tmodel->mod = _u32Mode;
    memcpy(tmodel->Server, [_strNtpServer UTF8String], _strNtpServer.length);
    return tmodel;
}
@end
