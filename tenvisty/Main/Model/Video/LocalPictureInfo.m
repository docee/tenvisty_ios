//
//  LocalPictureInfo.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/26.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "LocalPictureInfo.h"
@interface LocalPictureInfo()

@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *desc;
@end

@implementation LocalPictureInfo
- (id)initWithName:(NSString *)name path:(NSString*)path time:(NSInteger)time{
    if (self = [super init]) {
        self.thumbPath = path;
        self.time = time;
        self.path = path;
        self.name = name;
        self.thumbName = name;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd"];
        self.date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        self.desc = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    }
    return self;
}
@end
