//
//  NtpTimeModel.h
//  tenvisty
//
//  Created by Tenvis on 2018/3/30.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NtpTimeModel : NSObject
@property (nonatomic, assign) unsigned int u32Year;
@property (nonatomic, assign) unsigned int u32Month;
@property (nonatomic, assign) unsigned int u32Day;
@property (nonatomic, assign) unsigned int u32Hour;
@property (nonatomic, assign) unsigned int u32Minute;
@property (nonatomic, assign) unsigned int u32Second;
@property (nonatomic, assign) unsigned int u32Mode;
@property (nonatomic, assign) unsigned int u32Timezone;
@property (nonatomic, strong) NSString *strNtpServer;
- (id)initWithData:(char *)data size:(int)size;
- (SMsgAVIoctrlSetNtpConfigReq *)model;
@end
