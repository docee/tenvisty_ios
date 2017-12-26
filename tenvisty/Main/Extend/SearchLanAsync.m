//
//  SearchLanAsync.m
//  tenvisty
//
//  Created by Tenvis on 17/12/8.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SearchLanAsync.h"
#import <IOTCamera/IOTCAPIs.h>

#define SEARCHING (0)
#define STOPPING (1)
#define STOPPED (2)

#define DONE 1
#define NOTDONE 0

@interface SearchLanAsync()

@property (nonatomic,strong) NSMutableArray* deviceList;
@property (nonatomic,assign) NSInteger searchCount;
@property (nonatomic,assign) NSInteger maxWaitTime;
@property (nonatomic,assign) NSInteger beginTime;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic, strong) NSThread *searchThread;
@property (nonatomic, strong) NSConditionLock *searchThreadLock;
@end


@implementation SearchLanAsync

-(id)init{
    self = [super init];
    if(self){
        self.searchCount = 0;
        self.maxWaitTime = 2;
        self.state = STOPPED;
        self.delegate = nil;
    }
    return self;
}

-(NSMutableArray*)deviceList{
    if(_deviceList == nil){
        _deviceList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _deviceList;
}

-(void) beginSearch{
    if(self.searchThread == nil){
        self.state = SEARCHING;
        self.beginTime = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue];
        self.searchCount = 1;
        [[self deviceList] removeAllObjects];
        self.searchThreadLock = [[NSConditionLock alloc] initWithCondition:NOTDONE];
        self.searchThread = [[NSThread alloc] initWithTarget:self selector:@selector(search) object:nil];
        [self.searchThread start];
    }
}

-(void)search{
    [self.searchThreadLock lock];
    if(self.delegate != nil &&  [self.delegate respondsToSelector:@selector(onReceiveSearchResult:status:)]){
        [self.delegate onReceiveSearchResult:nil status:2];
    }
    int num = 0;
    int k = 0;
    while (self.state == SEARCHING && ([[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue] - self.beginTime) < self.maxWaitTime) {
        self.searchCount++;
        NSInteger timeout = self.searchCount/2<1?1:self.searchCount*75;
        LanSearch_t *pLanSearchAll =[Camera LanSearchT:&num timeout:(int)timeout];
       
        if(pLanSearchAll != nil){
            for(k = 0; k < num; k++) {
                
//                printf("\tUID[%s]\n", pLanSearchAll[k].UID);
//                printf("\tIP[%s]\n", pLanSearchAll[k].IP);
//                printf("\tPORT[%d]\n", pLanSearchAll[k].port);
//                printf("------------------------------------------\n");
                
                LANSearchDevice *dev = [[LANSearchDevice alloc] init];
                dev.uid = [NSString stringWithFormat:@"%s", pLanSearchAll[k].UID];
                dev.ip = [NSString stringWithFormat:@"%s", pLanSearchAll[k].IP];
                dev.port = pLanSearchAll[k].port;
                BOOL exist = NO;
                for(LANSearchDevice *d in [self deviceList]){
                    if([d.uid isEqualToString:dev.uid]){
                        exist = YES;
                        break;
                    }
                }
                if(!exist){
                    [[self deviceList] addObject:dev];
                    if(self.delegate != nil &&  [self.delegate respondsToSelector:@selector(onReceiveSearchResult:status:)]){
                        [self.delegate onReceiveSearchResult:dev status:1];
                    }
                }
                
            }
        }
    }
    self.state = STOPPED;
    if(self.delegate != nil &&  [self.delegate respondsToSelector:@selector(onReceiveSearchResult:status:)]){
        [self.delegate onReceiveSearchResult:nil status:0];
    }
    [self.searchThreadLock unlockWithCondition:DONE];
}

-(void) stopSearch{
    if(self.state == SEARCHING){
        self.state = STOPPING;
        if(self.searchThread != nil){
            if(self.delegate != nil &&  [self.delegate respondsToSelector:@selector(onReceiveSearchResult:status:)]){
                [self.delegate onReceiveSearchResult:nil status:0];
            }
        }
    }
    if(self.searchThreadLock != nil){
        [self.searchThreadLock lockWhenCondition:DONE];
        [self.searchThreadLock unlock];
    }
    self.searchThread = nil;
}

-(NSInteger) getState{
    return self.state;
}


@end
