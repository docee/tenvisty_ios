//
//  TimeZoneModel.h
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeZoneModel : NSObject
@property (nonatomic,copy) NSString* area;
@property (nonatomic,copy) NSString* strGMT;
@property (nonatomic,assign) Boolean dst;
@property (nonatomic,assign) NSInteger timezone;

+(TimeZoneModel *) initObj:(NSInteger)timezone area:(NSString*)area gmt:(NSString*)strGMT daylight:(Boolean)dst;

+(NSArray*)getAll;
+(NSArray*)getAllOld;
@end
