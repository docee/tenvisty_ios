//
//  HichipAudioWiFiConfig.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/29.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "HichipAudioWiFiConfig.h"
#import "SinVoiceData.h"
#import <AVFoundation/AVFoundation.h>

@interface HichipAudioWiFiConfig(){
    
}
@property (nonatomic, strong) SinVoiceData *sinVoice;
@end


@implementation HichipAudioWiFiConfig

+(id)sharedInstance{
    static HichipAudioWiFiConfig *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

-(void)initObj{
    if(!_sinVoice){
        _sinVoice = [[SinVoiceData alloc] initWithSSID:self.ssid KEY:self.pwd];
    }
}

-(void) runConfig{
    [self initObj];
//    UInt32 audioRouteOverride = NO ?kAudioSessionOverrideAudioRoute_None:kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    [self.sinVoice setSSID:self.ssid KEY:self.pwd];
    [self.sinVoice startSinVoice];
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
}

-(void) stopConfig{
    [self.sinVoice stopSinVoice];
}

@end
