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
@property int eventStatus;

@property (nonatomic,assign) BOOL isDateFirstItem;
@property (nonatomic,assign) NSTimeInterval dateTimeInterval;

+ (NSString *)getEventTypeName:(int)eventType;
+ (STimeDay)getTimeDay:(long)time;
- (id)initWithEventType:(int)eventType EventTime:(long)eventTime EventStatus:(int)status;
- (id)initWithEventType:(int)type EventTime:(long)time EventStatus:(int)status cloudStoragePath:(NSString *)pathString_;
@end
