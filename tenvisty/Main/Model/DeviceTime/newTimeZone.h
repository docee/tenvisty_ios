//
//  newTimeZone.h
//  CamHi
//
//  Created by 堃大爷 on 2017/7/14.
//  Copyright © 2017年 Hichip. All rights reserved.
//


//typedef struct
//{
//    HI_CHAR sTimeZone[32];
//    HI_U32 u32DstMode;			//夏令时
//    HI_CHAR strReserved[4];
//} HI_P2P_S_TIME_ZONE_EXT;
///****************HI_P2P_SET_TIME_ZONE_EXT  HI_P2P_GET_TIME_ZONE_EXT*************/

#import <Foundation/Foundation.h>

@interface newTimeZone : NSObject

@property (nonatomic,assign) int dst;
@property (nonatomic,strong) NSString* timeName;

-(instancetype)initWithData:(char* )data withSize:(int)size;
- (HI_P2P_S_TIME_ZONE_EXT *)model;
@end
