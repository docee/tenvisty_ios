//
//  WiFiConfigContext.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/12.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "WiFiConfigContext.h"
#import "FaceberAudioConfig.h"

@interface WiFiConfigContext(){
    id<WiFiConfigDelegate> configDelegate;
    BOOL isStopped;
}

@property (nonatomic, strong) NSMutableArray *configList;

@end

@implementation WiFiConfigContext
+(id)sharedInstance{
    static WiFiConfigContext *instance = nil;
    @synchronized(self) {
        if (instance == nil){
            instance = [[self alloc] init];
            [instance add:[FaceberAudioConfig sharedInstance]];
        }
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isStopped = YES;
    }
    return self;
}

-(NSMutableArray*)configList{
    if(!_configList){
        _configList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _configList;
}

-(void) setReceiveListner:(id<WiFiConfigDelegate>)delegate{
    configDelegate = delegate;
    for(BaseWiFiConfig *config in self.configList){
        config.delegate = delegate;
    }
}

-(void) clearReceiveListner{
    configDelegate = nil;
    for(BaseWiFiConfig *config in self.configList){
        config.delegate = nil;
    }
}

-(void) add:(BaseWiFiConfig*)config{
    config.delegate = configDelegate;
    [self.configList addObject:config];
}

-(void) setData:(NSString*)ssid password:(NSString*)pwd auth:(NSInteger)authMode{
    for(BaseWiFiConfig *config in self.configList){
        config.pwd = pwd;
        config.ssid = ssid;
        config.authMode = authMode;
    }
}

-(void) startConfig{
    isStopped = NO;
    for(BaseWiFiConfig *config in self.configList){
        config.delegate = configDelegate;
        [config runConfig];
    }
}

-(void) stopConfig{
    isStopped = YES;
    for(BaseWiFiConfig *config in self.configList){
        config.delegate = nil;
        [config stopConfig];
    }
}

-(BOOL) isRunning{
    return !isStopped;
}
@end
