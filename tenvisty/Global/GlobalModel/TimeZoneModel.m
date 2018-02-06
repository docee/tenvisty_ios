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

static NSArray *newtimezones;
static NSArray *oldtimezones;
@implementation TimeZoneModel


+(TimeZoneModel *) initObj:(NSInteger)timezone area:(NSString*)area gmt:(NSString*)strGMT daylight:(Boolean)dst{
    TimeZoneModel *model = [[TimeZoneModel alloc] init];
    model.area = area;
    model.strGMT = strGMT;
    model.dst = dst;
    model.timezone = timezone;
    return model;
}

+(NSArray*)getAll{
    if(newtimezones == nil){
        newtimezones = [[NSArray alloc] initWithObjects: [TimeZoneModel initObj:-12 area:(@"Etc/GMT-12") gmt:@"GMT-12:00" daylight:NO],
                     [TimeZoneModel initObj:-11 area:(@"Pacific/Apia") gmt:@"GMT-11:00" daylight:YES],
                     [TimeZoneModel initObj:-10 area:(@"Pacific/Honolulu") gmt:@"GMT-10:00" daylight:NO],
                     [TimeZoneModel initObj:-9 area:(@"America/Anchorage") gmt:@"GMT-09:00" daylight:YES],
                     [TimeZoneModel initObj:-8 area:(@"America/Los_Angeles") gmt:@"GMT-08:00" daylight:YES],
                     [TimeZoneModel initObj:-7 area:(@"America/Denver") gmt:@"GMT-07:00" daylight:YES],
                     [TimeZoneModel initObj:-7 area:(@"America/Tegucigalpa") gmt:@"GMT-07:00" daylight:YES],
                     [TimeZoneModel initObj:-7 area:(@"America/Phoenix") gmt:@"GMT-07:00" daylight:NO],
                     [TimeZoneModel initObj:-6 area:(@"America/Saskatchewan") gmt:@"GMT-06:00" daylight:YES],
                     [TimeZoneModel initObj:-6 area:(@"America/Mexico_City") gmt:@"GMT-06:00" daylight:YES],
                     [TimeZoneModel initObj:-6 area:(@"America/Chicago") gmt:@"GMT-06:00" daylight:NO],
                     [TimeZoneModel initObj:-6 area:(@"America/Costa_Rica") gmt:@"GMT-06:00" daylight:NO],
                     [TimeZoneModel initObj:-5 area:(@"America/Indianapolis") gmt:@"GMT-05:00" daylight:YES],
                     [TimeZoneModel initObj:-5 area:(@"America/New_York") gmt:@"GMT-05:00" daylight:YES],
                     [TimeZoneModel initObj:-5 area:(@"America/Bogota") gmt:@"GMT-05:00" daylight:NO],
                     [TimeZoneModel initObj:-4 area:(@"America/Caracas") gmt:@"GMT-04:30" daylight:NO],
                     [TimeZoneModel initObj:-4 area:(@"America/Santiago") gmt:@"GMT-04:00" daylight:YES],
                     [TimeZoneModel initObj:-4 area:(@"America/Montreal") gmt:@"GMT-04:00" daylight:YES],
                     [TimeZoneModel initObj:-3.5 area:(@"America/St_Johns") gmt:@"GMT-03:30" daylight:YES],
                     [TimeZoneModel initObj:-3 area:(@"America/Thule") gmt:@"GMT-03:00" daylight:YES],
                     [TimeZoneModel initObj:-3 area:(@"America/Buenos_Aires") gmt:@"GMT-03:00" daylight:NO],
                     [TimeZoneModel initObj:-3 area:(@"America/Sao_Paulo") gmt:@"GMT-03:00" daylight:YES],
                     [TimeZoneModel initObj:-2 area:(@"Atlantic/South_Georgia") gmt:@"GMT-02:00" daylight:YES],
                     [TimeZoneModel initObj:-1 area:(@"Atlantic/Cape_Verde") gmt:@"GMT-01:00" daylight:NO],
                     [TimeZoneModel initObj:-1 area:(@"Atlantic/Azores") gmt:@"GMT-01:00" daylight:YES],
                     [TimeZoneModel initObj:0 area:(@"Europe/Dublin") gmt:@"GMT+00:00" daylight:YES],
                     [TimeZoneModel initObj:0 area:(@"Africa/Casablanca") gmt:@"GMT+00:00" daylight:NO],
                     [TimeZoneModel initObj:1 area:(@"Europe/Amsterdam") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:1 area:(@"Europe/Belgrade") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:1 area:(@"Europe/Brussels") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:1 area:(@"Europe/Warsaw") gmt:@"GMT+01:00" daylight:YES],
                     [TimeZoneModel initObj:1 area:(@"Africa/Lagos") gmt:@"GMT+01:00" daylight:NO],
                     [TimeZoneModel initObj:2 area:(@"Europe/Athens") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:2 area:(@"Europe/Bucharest") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:2 area:(@"Africa/Cairo") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:2 area:(@"Africa/Harare") gmt:@"GMT+02:00" daylight:NO],
                     [TimeZoneModel initObj:2 area:(@"Europe/Helsinki") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:2 area:(@"Asia/Jerusalem") gmt:@"GMT+02:00" daylight:YES],
                     [TimeZoneModel initObj:3 area:(@"Asia/Baghdad") gmt:@"GMT+03:00" daylight:NO],
                     [TimeZoneModel initObj:3 area:(@"Asia/Kuwait") gmt:@"GMT+03:00" daylight:NO],
                     [TimeZoneModel initObj:3 area:(@"Europe/Moscow") gmt:@"GMT+03:00" daylight:YES],
                     [TimeZoneModel initObj:3 area:(@"Africa/Nairobi") gmt:@"GMT+03:00" daylight:NO],
                     [TimeZoneModel initObj:3.5 area:(@"Asia/Tehran") gmt:@"GMT+03:30" daylight:YES],
                     [TimeZoneModel initObj:4 area:(@"Asia/Dubai") gmt:@"GMT+04:00" daylight:NO],
                     [TimeZoneModel initObj:4 area:(@"Asia/Baku") gmt:@"GMT+04:00" daylight:YES],
                     [TimeZoneModel initObj:4.5 area:(@"Asia/Kabul") gmt:@"GMT+04:30" daylight:NO],
                     [TimeZoneModel initObj:5 area:(@"Asia/Yekaterinburg") gmt:@"GMT+05:00" daylight:NO],
                     [TimeZoneModel initObj:5 area:(@"Asia/Karachi") gmt:@"GMT+05:00" daylight:NO],
                     [TimeZoneModel initObj:5.5 area:(@"Asia/Calcutta") gmt:@"GMT+05:30" daylight:NO],
                     [TimeZoneModel initObj:5.75 area:(@"Asia/Katmandu") gmt:@"GMT+05:45" daylight:NO],
                     [TimeZoneModel initObj:6 area:(@"Asia/Novosibirsk") gmt:@"GMT+06:00" daylight:YES],
                     [TimeZoneModel initObj:6 area:(@"Asia/Dhaka") gmt:@"GMT+06:00" daylight:NO],
                     [TimeZoneModel initObj:6 area:(@"Asia/Astana") gmt:@"GMT+06:00" daylight:NO],
                     [TimeZoneModel initObj:6.5 area:(@"Asia/Rangoon") gmt:@"GMT+06:30" daylight:NO],
                     [TimeZoneModel initObj:7 area:(@"Asia/Bangkok") gmt:@"GMT+07:00" daylight:NO],
                     [TimeZoneModel initObj:7 area:(@"Asia/Krasnoyarsk") gmt:@"GMT+07:00" daylight:YES],
                     [TimeZoneModel initObj:8 area:(@"Asia/Hong_Kong") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:8 area:(@"Asia/Irkutsk") gmt:@"GMT+08:00" daylight:YES],
                     [TimeZoneModel initObj:8 area:(@"Asia/Kuala_Lumpur") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:8 area:(@"Australia/Perth") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:8 area:(@"Asia/Taipei") gmt:@"GMT+08:00" daylight:NO],
                     [TimeZoneModel initObj:9 area:(@"Asia/Tokyo") gmt:@"GMT+09:00" daylight:NO],
                     [TimeZoneModel initObj:9 area:(@"Asia/Seoul") gmt:@"GMT+09:00" daylight:NO],
                     [TimeZoneModel initObj:9 area:(@"Asia/Yakutsk") gmt:@"GMT+09:00" daylight:YES],
                     [TimeZoneModel initObj:9.5 area:(@"Australia/Adelaide") gmt:@"GMT+09:30" daylight:YES],
                     [TimeZoneModel initObj:10 area:(@"Australia/Brisbane") gmt:@"GMT+10:00" daylight:NO],
                     [TimeZoneModel initObj:10 area:(@"Australia/Sydney") gmt:@"GMT+10:00" daylight:YES],
                     [TimeZoneModel initObj:10 area:(@"Pacific/Guam") gmt:@"GMT+10:00" daylight:NO],
                     [TimeZoneModel initObj:10 area:(@"Australia/Hobart") gmt:@"GMT+10:00" daylight:YES],
                     [TimeZoneModel initObj:10 area:(@"Asia/Vladivostok") gmt:@"GMT+10:00" daylight:YES],
                     [TimeZoneModel initObj:11 area:(@"Asia/Magadan") gmt:@"GMT+11:00" daylight:YES],
                     [TimeZoneModel initObj:12 area:(@"Pacific/Auckland") gmt:@"GMT+12:00" daylight:YES],
                     [TimeZoneModel initObj:12 area:(@"Pacific/Fiji") gmt:@"GMT+12:00" daylight:YES],
                     [TimeZoneModel initObj:13 area:(@"Pacific/Tongatapu") gmt:@"GMT+13:00" daylight:NO],nil];
    }
    return newtimezones;
}

+(NSArray*)getAllOld{
    if(oldtimezones == nil){
        oldtimezones = [[NSArray alloc] initWithObjects:
                        [TimeZoneModel initObj:-11 area:@"Midway Islands;Samoa;" gmt:@"GMT-11" daylight:NO],
                        [TimeZoneModel initObj:-10 area:@"Hawaii;" gmt:@"GMT-10" daylight:YES],
                        [TimeZoneModel initObj:-9 area:@"Alaska;" gmt:@"GMT-9" daylight:YES],
                        [TimeZoneModel initObj:-8 area:@"Pacific Time(USA or Canada);" gmt:@"GMT-8" daylight:YES],
                        [TimeZoneModel initObj:-7 area:@"Mountain Time(USA or Canada);" gmt:@"GMT-7" daylight:YES],
                        [TimeZoneModel initObj:-6 area:@"Central Time(USA or Canada);" gmt:@"GMT-6" daylight:YES],
                        [TimeZoneModel initObj:-5 area:@"Eastern Time(USA or Canada);" gmt:@"GMT-5" daylight:YES],
                        [TimeZoneModel initObj:-4 area:@"Atlantic Time(Canada);" gmt:@"GMT-4" daylight:YES],
                        [TimeZoneModel initObj:-3 area:@"Atlantic Time(Canada);" gmt:@"GMT-3" daylight:YES],
                        [TimeZoneModel initObj:-2 area:@"Mid-Atlantic;" gmt:@"GMT-2" daylight:YES],
                        [TimeZoneModel initObj:-1 area:@"Azores;Cape Verde;" gmt:@"GMT-1" daylight:NO],
                        [TimeZoneModel initObj:0 area:@"London;Iceland;Lisbon;" gmt:@"GMT 0" daylight:NO],
                        [TimeZoneModel initObj:1 area:@"Paris;Rome;Berlin;Madrid;" gmt:@"GMT+1" daylight:YES],
                        [TimeZoneModel initObj:2 area:@"Israel;Athens;Cairo;Jerusalem;" gmt:@"GMT+2" daylight:YES],
                        [TimeZoneModel initObj:3 area:@"Moscow;Nairobi;Riyadh;" gmt:@"GMT+3" daylight:NO],
                        [TimeZoneModel initObj:4 area:@"Baku;Tbilisi;Abu Dhabi;Mascot;" gmt:@"GMT+4" daylight:YES],
                        [TimeZoneModel initObj:5 area:@"New Delhi;Islamabad;" gmt:@"GMT+5" daylight:NO],
                        [TimeZoneModel initObj:6 area:@"Dakar;Alma Ata;Novosibirsk;Astana;" gmt:@"GMT+6" daylight:NO],
                        [TimeZoneModel initObj:7 area:@"Bangkok;Hanoi;Jakarta;" gmt:@"GMT+7" daylight:NO],
                        [TimeZoneModel initObj:8 area:@"Beijing;Singapore;Hongkong;Taipei;" gmt:@"GMT+8" daylight:NO],
                        [TimeZoneModel initObj:9 area:@"Tokyo;Seoul;Yakutsk;" gmt:@"GMT+9" daylight:NO],
                        [TimeZoneModel initObj:10 area:@"Guam;Melbourne;Sydney;" gmt:@"GMT+10" daylight:NO],
                        [TimeZoneModel initObj:11 area:@"Magadan;New Caledonia;Solomon Islands;" gmt:@"GMT+11" daylight:NO],
                        [TimeZoneModel initObj:12 area:@"Wellington;Auckland;fiji;" gmt:@"GMT+12" daylight:YES],nil];
    }
    return oldtimezones;
}
@end
