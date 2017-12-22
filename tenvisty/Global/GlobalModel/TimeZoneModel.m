//
//  TimeZoneModel.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TimeZoneModel.h"

@interface TimeZoneModel()

@end

static NSArray *timezones;
@implementation TimeZoneModel


+(TimeZoneModel *) initObj:(NSString*)area gmt:(NSString*)strGMT daylight:(Boolean)dst{
    TimeZoneModel *model = [[TimeZoneModel alloc] init];
    model.area = area;
    model.strGMT = strGMT;
    model.dst = dst;
    return model;
}

+(NSArray*)getAll{
    if(timezones == nil){
        timezones = [[NSArray alloc] initWithObjects: [TimeZoneModel initObj:(@"Etc/GMT-12") gmt:@"GMT-12:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Pacific/Apia") gmt:@"GMT-11:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Pacific/Honolulu") gmt:@"GMT-10:00" daylight:NO],
                     [TimeZoneModel initObj:(@"America/Anchorage") gmt:@"GMT-09:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Los_Angeles") gmt:@"GMT-08:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Denver") gmt:@"GMT-07:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Tegucigalpa") gmt:@"GMT-07:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Phoenix") gmt:@"GMT-07:00" daylight:NO],
                     [TimeZoneModel initObj:(@"America/Saskatchewan") gmt:@"GMT-06:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Mexico_City") gmt:@"GMT-06:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Chicago") gmt:@"GMT-06:00" daylight:NO],
                     [TimeZoneModel initObj:(@"America/Costa_Rica") gmt:@"GMT-06:00" daylight:NO],
                     [TimeZoneModel initObj:(@"America/Indianapolis") gmt:@"GMT-05:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/New_York") gmt:@"GMT-05:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Bogota") gmt:@"GMT-05:00" daylight:NO],
                     [TimeZoneModel initObj:(@"America/Caracas") gmt:@"GMT-04:30" daylight:NO],
                     [TimeZoneModel initObj:(@"America/Santiago") gmt:@"GMT-04:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Montreal") gmt:@"GMT-04:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/St_Johns") gmt:@"GMT-03:30" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Thule") gmt:@"GMT-03:00" daylight:YES],
                     [TimeZoneModel initObj:(@"America/Buenos_Aires") gmt:@"GMT-03:00" daylight:NO],
                     [TimeZoneModel initObj:(@"America/Sao_Paulo") gmt:@"GMT-03:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Atlantic/South_Georgia") gmt:@"GMT-02:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Atlantic/Cape_Verde") gmt:@"GMT-01:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Atlantic/Azores") gmt:@"GMT-01:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Europe/Dublin") gmt:@"GMT+00:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Africa/Casablanca") gmt:@"GMT+00:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Europe/Amsterdam") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Europe/Belgrade") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Europe/Brussels") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Europe/Warsaw") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Africa/Lagos") gmt:@"GMT+01:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Europe/Athens") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Europe/Bucharest") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Africa/Cairo") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Africa/Harare") gmt:@"GMT+02:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Europe/Helsinki") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Asia/Jerusalem") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Asia/Baghdad") gmt:@"GMT+03:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Kuwait") gmt:@"GMT+03:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Europe/Moscow") gmt:@"GMT+03:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Africa/Nairobi") gmt:@"GMT+03:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Tehran") gmt:@"GMT+03:30" daylight:YES],
                     [TimeZoneModel initObj:(@"Asia/Dubai") gmt:@"GMT+04:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Baku") gmt:@"GMT+04:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Asia/Kabul") gmt:@"GMT+04:30" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Yekaterinburg") gmt:@"GMT+05:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Karachi") gmt:@"GMT+05:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Calcutta") gmt:@"GMT+05:30" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Katmandu") gmt:@"GMT+05:45" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Novosibirsk") gmt:@"GMT+06:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Asia/Dhaka") gmt:@"GMT+06:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Astana") gmt:@"GMT+06:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Rangoon") gmt:@"GMT+06:30" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Bangkok") gmt:@"GMT+07:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Krasnoyarsk") gmt:@"GMT+07:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Asia/Hong_Kong") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Irkutsk") gmt:@"GMT+08:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Asia/Kuala_Lumpur") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Australia/Perth") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Taipei") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Tokyo") gmt:@"GMT+09:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Seoul") gmt:@"GMT+09:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Asia/Yakutsk") gmt:@"GMT+09:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Australia/Adelaide") gmt:@"GMT+09:30" daylight:YES],
                     [TimeZoneModel initObj:(@"Australia/Brisbane") gmt:@"GMT+10:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Australia/Sydney") gmt:@"GMT+10:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Pacific/Guam") gmt:@"GMT+10:00" daylight:NO],
                     [TimeZoneModel initObj:(@"Australia/Hobart") gmt:@"GMT+10:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Asia/Vladivostok") gmt:@"GMT+10:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Asia/Magadan") gmt:@"GMT+11:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Pacific/Auckland") gmt:@"GMT+12:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Pacific/Fiji") gmt:@"GMT+12:00" daylight:YES],
                     [TimeZoneModel initObj:(@"Pacific/Tongatapu") gmt:@"GMT+13:00" daylight:NO],nil];
    }
    return timezones;
}
@end
