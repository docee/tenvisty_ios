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
        timezones = [[NSArray alloc] initWithObjects: [TimeZoneModel initObj:LOCALSTR(@"Etc/GMT-12") gmt:@"GMT-12:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Etc/GMT-12") gmt:@"GMT-12:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Pacific/Apia") gmt:@"GMT-11:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Pacific/Honolulu") gmt:@"GMT-10:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Anchorage") gmt:@"GMT-09:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Los_Angeles") gmt:@"GMT-08:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Denver") gmt:@"GMT-07:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Tegucigalpa") gmt:@"GMT-07:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Phoenix") gmt:@"GMT-07:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Saskatchewan") gmt:@"GMT-06:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Mexico_City") gmt:@"GMT-06:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Chicago") gmt:@"GMT-06:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Costa_Rica") gmt:@"GMT-06:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Indianapolis") gmt:@"GMT-05:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/New_York") gmt:@"GMT-05:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Bogota") gmt:@"GMT-05:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Caracas") gmt:@"GMT-04:30" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Santiago") gmt:@"GMT-04:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Montreal") gmt:@"GMT-04:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/St_Johns") gmt:@"GMT-03:30" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Thule") gmt:@"GMT-03:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Buenos_Aires") gmt:@"GMT-03:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"America/Sao_Paulo") gmt:@"GMT-03:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Atlantic/South_Georgia") gmt:@"GMT-02:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Atlantic/Cape_Verde") gmt:@"GMT-01:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Atlantic/Azores") gmt:@"GMT-01:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Europe/Dublin") gmt:@"GMT+00:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Africa/Casablanca") gmt:@"GMT+00:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Europe/Amsterdam") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Europe/Belgrade") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Europe/Brussels") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Europe/Warsaw") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Africa/Lagos") gmt:@"GMT+01:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Europe/Athens") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Europe/Bucharest") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Africa/Cairo") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Africa/Harare") gmt:@"GMT+02:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Europe/Helsinki") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Jerusalem") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Baghdad") gmt:@"GMT+03:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Kuwait") gmt:@"GMT+03:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Europe/Moscow") gmt:@"GMT+03:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Africa/Nairobi") gmt:@"GMT+03:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Tehran") gmt:@"GMT+03:30" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Dubai") gmt:@"GMT+04:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Baku") gmt:@"GMT+04:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Kabul") gmt:@"GMT+04:30" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Yekaterinburg") gmt:@"GMT+05:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Karachi") gmt:@"GMT+05:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Calcutta") gmt:@"GMT+05:30" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Katmandu") gmt:@"GMT+05:45" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Novosibirsk") gmt:@"GMT+06:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Dhaka") gmt:@"GMT+06:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Astana") gmt:@"GMT+06:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Rangoon") gmt:@"GMT+06:30" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Bangkok") gmt:@"GMT+07:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Krasnoyarsk") gmt:@"GMT+07:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Hong_Kong") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Irkutsk") gmt:@"GMT+08:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Kuala_Lumpur") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Australia/Perth") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Taipei") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Tokyo") gmt:@"GMT+09:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Seoul") gmt:@"GMT+09:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Yakutsk") gmt:@"GMT+09:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Australia/Adelaide") gmt:@"GMT+09:30" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Australia/Brisbane") gmt:@"GMT+10:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Australia/Sydney") gmt:@"GMT+10:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Pacific/Guam") gmt:@"GMT+10:00" daylight:NO],
                     [TimeZoneModel initObj:LOCALSTR(@"Australia/Hobart") gmt:@"GMT+10:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Vladivostok") gmt:@"GMT+10:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Asia/Magadan") gmt:@"GMT+11:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Pacific/Auckland") gmt:@"GMT+12:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Pacific/Fiji") gmt:@"GMT+12:00" daylight:YES],
                     [TimeZoneModel initObj:LOCALSTR(@"Pacific/Tongatapu") gmt:@"GMT+13:00" daylight:NO],nil];
    }
    return timezones;
}
@end
