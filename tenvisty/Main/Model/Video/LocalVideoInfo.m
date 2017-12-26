//
//  LocalVideoInfo.m
//  KncAngel
//
//  Created by zhao qi on 15/8/29.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "LocalVideoInfo.h"

@interface LocalVideoInfo ()

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic,strong) NSString *date;
@end

@implementation LocalVideoInfo



//- (id)initWithID:(NSString*)path Time:(NSInteger)time {
//    self = [super init];
//
//    if (self) {
//        self.path = path;
//        self.time = time;
//    }
//
//    return self;
//}

- (id)initWithRecordingName:(NSString *)name time:(NSInteger)time type:(NSInteger)type thumbPath:(NSString *)thumbPath {
    if (self = [super init]) {
        
        self.path = name;
        self.time = time;
        self.type = type;
        self.thumbPath = thumbPath;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        self.date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        
    }
    return self;
}



- (NSString *)videoType {
    
    NSString *video_type = @"mp4";
    
    if ([self.path rangeOfString:video_type].location != NSNotFound) {
        return video_type;
    }
    
    video_type = @"avi";
    if ([self.path rangeOfString:video_type].location != NSNotFound) {
        return video_type;
    }
    
    return nil;
}

- (NSString *)videoName {
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.time];
    
    NSString *name = [self.formatter stringFromDate:date];
    NSString *video_name = nil;
    
    if ([self.videoType isEqualToString:@"avi"]) {
        video_name = [NSString stringWithFormat:@"%@.avi", name];
    }
    
    if ([self.videoType isEqualToString:@"mp4"]) {
        video_name = [NSString stringWithFormat:@"%@.mp4", name];
    }
    
    return video_name;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd  HH:mm:ss";
        
    }
    return _formatter;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"video_path : %@ type:%d", self.path, (int)self.type];
}

@end
