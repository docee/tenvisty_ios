//
//  Event.m
//  IOTCamViewer
//
//  Created by tutk on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize UUID;
@synthesize pathString;
@synthesize eventType;
@synthesize eventTime;
@synthesize eventStatus;

+ (NSString *)getEventTypeName:(int)eventType {

    NSMutableString *result = [NSMutableString string];
    
    switch (eventType) {
        case AVIOCTRL_EVENT_ALL:
            [result appendString:NSLocalizedString(@"Full time recording", @"")];
            break;
            
        case AVIOCTRL_EVENT_EXPT_REBOOT:
            [result appendString:NSLocalizedString(@"Reboot", @"")];
            break;
            
        case AVIOCTRL_EVENT_IOALARM:
            [result appendString:NSLocalizedString(@"IO Alarm", @"")];
            break;
            
        case AVIOCTRL_EVENT_IOALARMPASS:
            break;
            
        case AVIOCTRL_EVENT_MOTIONDECT:
            [result appendString:NSLocalizedString(@"Motion Detection", @"")];
            break;
            
        case AVIOCTRL_EVENT_MOTIONPASS:
            break;
            
        case AVIOCTRL_EVENT_SDFAULT:
            [result appendString:NSLocalizedString(@"SDCard Fault", @"")];
            break;
            
        case AVIOCTRL_EVENT_VIDEOLOST:
            [result appendString:NSLocalizedString(@"Video Lost", @"")];
            break;
            
        case AVIOCTRL_EVENT_VIDEORESUME:
            [result appendString:NSLocalizedString(@"Video Resume", @"")];
            break;
            
        default:
            break;
    }
    
    return result;
}


+ (STimeDay)getTimeDay:(long)time {
    
    STimeDay result;
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    
    [dateFormatter setDateFormat:@"yyyy"];
    result.year = [[dateFormatter stringFromDate:date] intValue];
    
    [dateFormatter setDateFormat:@"MM"];
    result.month = [[dateFormatter stringFromDate:date] intValue];
    
    [dateFormatter setDateFormat:@"dd"];
    result.day = [[dateFormatter stringFromDate:date] intValue];
    
    [dateFormatter setDateFormat:@"e"];
    result.wday = [[dateFormatter stringFromDate:date] intValue];
    
    [dateFormatter setDateFormat:@"HH"];
    result.hour = [[dateFormatter stringFromDate:date] intValue];
    
    [dateFormatter setDateFormat:@"mm"];
    result.minute = [[dateFormatter stringFromDate:date] intValue];
    
    [dateFormatter setDateFormat:@"ss"];
    result.second = [[dateFormatter stringFromDate:date] intValue];    
    
    return result;
}


// return a new autoreleased UUID string
- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // to the autorelease pool
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

- (id)initWithEventType:(int)type EventTime:(long)time EventStatus:(int)status {
    
    self = [super init];
    
    if (self) {
        
        self.UUID = [self generateUuidString];
        self.eventType = type;
        self.eventTime = time;
        self.eventStatus = status;
        self.dateTimeInterval = [self zeroOfDateTimeInterval:[[NSDate alloc] initWithTimeIntervalSince1970:time]];
        
    }
    
    return self;
}

- (id)initWithEventType:(int)type EventTime:(long)time EventStatus:(int)status cloudStoragePath:(NSString *)pathString_ {
    
    self = [super init];
    
    if (self) {
        
        self.UUID = [self generateUuidString];
        self.pathString = pathString_;
        self.eventType = type;
        self.eventTime = time;
        self.eventStatus = status;
        self.dateTimeInterval = [self zeroOfDateTimeInterval:[[NSDate alloc] initWithTimeIntervalSince1970:time]];
    }
    
    return self;
}
- (NSTimeInterval)zeroOfDateTimeInterval:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
}
@end
