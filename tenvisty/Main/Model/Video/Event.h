//
//  Event.h
//  IOTCamViewer
//
//  Created by tutk on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define EVENT_UNREADED 0
#define EVENT_READED 1
#define EVENT_NORECORD 2

#import <Foundation/Foundation.h>
#import <IOTCamera/AVIOCTRLDEFs.h>

@interface Event : NSObject {
    
    NSString *UUID;
    int eventType;
    long eventTime;
    int eventStatus;
}

@property (nonatomic, retain) NSString *UUID;
@property (nonatomic, retain) NSString *pathString; //cloud stroger path
@property int eventType;
@property long eventTime;
@property long eventEndTime;
@property int eventStatus;

@property (nonatomic,assign) BOOL isDateFirstItem;
@property (nonatomic,assign) NSTimeInterval dateTimeInterval;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) NSInteger downloadState;
@property (nonatomic,strong,readonly) NSString* strEventTime;
+ (STimeDay)getHiTimeDay:(long)time;
+ (NSString *)getEventTypeName:(int)eventType;
+ (TUTK_STimeDay)getTimeDay:(long)time;
- (id)initWithEventType:(int)eventType EventTime:(long)eventTime EventStatus:(int)status;
- (id)initWithEventType:(int)eventType EventStartTime:(long)startTime EventEndTime:(long)endTime EventStatus:(int)status;
- (id)initWithEventType:(int)type EventTime:(long)time EventStatus:(int)status cloudStoragePath:(NSString *)pathString_;
+ (NSString *)getHiEventTypeName:(int)eventType;
@end
