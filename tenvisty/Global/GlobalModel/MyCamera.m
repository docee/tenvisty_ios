//
//  MyCamera.m
//  IOTCamViewer
//
//  Created by Cloud Hsiao on 12/7/2.
//  Copyright (c) 2012年 TUTK. All rights reserved.
//
#define CONNECT_TIMEOUT_WAITTIME 30
#define MAX_RECONNECT_TIMES 2

#import "MyCamera.h"
#import <IOTCamera/AVIOCTRLDEFs.h>
#import <IOTCamera/AVFrameInfo.h>
#import "TimeZoneModel.h"
#import "Event.h"
#import "DeviceInfo_TUTK.h"

@interface MyCamera()<CameraDelegate>{
    BOOL isWakingUp;
    int reConnectTimes;
}
@property (nonatomic,assign) NSInteger beginRebootTime;
@property (nonatomic,assign) NSInteger rebootTimeout;
@property (nonatomic,assign) NSInteger connectTimeoutBeginTime;
@property (nonatomic, strong) NSUserDefaults *camDefaults;
@property (nonatomic, strong) NSString *pushToken;
@property (nonatomic,assign) CGFloat vRatio;
@property (nonatomic,strong) TimeZoneModel *timezone;
@property (nonatomic,strong) DeviceInfo_TUTK *deviceInfo;
@end

@implementation MyCamera
@synthesize baseCamera;
@synthesize lastChannel;
@synthesize user, pwd;
@synthesize cameraStateDesc;

@synthesize p2pType;

@synthesize cameraDelegate;
@synthesize isSessionConnecting;
@synthesize modelName;
@synthesize batteryTime;
@synthesize batteryMode;
@synthesize batterPercent;

#pragma mark - Public Methods

//- (NSArray *)getSupportedStreams
//{
//    return [arrayStreamChannel count] == 0 ? nil : [[NSArray alloc] initWithArray:arrayStreamChannel];
//}
//
//- (BOOL)getAudioInSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 1) == 0;
//}
//
//- (BOOL)getAudioOutSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 2) == 0;
//}
//
//- (BOOL)getPanTiltSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 4) == 0;
//}
//
//- (BOOL)getEventListSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 8) == 0;
//}
//
//- (BOOL)getPlaybackSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 16) == 0;
//}
//
//- (BOOL)getWiFiSettingSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 32) == 0;
//}
//
//- (BOOL)getMotionDetectionSettingSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 64) == 0;
//}
//
//- (BOOL)getRecordSettingSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 128) == 0;
//}
//
//- (BOOL)getFormatSDCardSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 256) == 0;
//}
//
//- (BOOL)getVideoFlipSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 512) == 0;
//}
//
//- (BOOL)getEnvironmentModeSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 1024) == 0;
//}
//
//- (BOOL)getMultiStreamSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 2048) == 0;
//}
//
//- (NSInteger)getAudioOutFormatOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 4096) == 0 ? MEDIA_CODEC_AUDIO_SPEEX : MEDIA_CODEC_AUDIO_ADPCM;
//}
//
//- (BOOL)getVideoQualitySettingSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 8192) == 0;
//}
//
//- (BOOL)getDeviceInfoSupportOfChannel:(NSInteger)channel
//{
//    return ([self getServiceTypeOfChannel:channel] & 16384) == 0;
//}
//
//-(NSString *)getCameraStatus{
//    if (self.sessionState == CONNECTION_STATE_CONNECTING) {
//        return LOCALSTR(@"Connecting...");
//    }
//    else if (self.sessionState == CONNECTION_STATE_DISCONNECTED) {
//        return LOCALSTR(@"Off line");
//    }
//    else if (self.sessionState == CONNECTION_STATE_UNKNOWN_DEVICE) {
//        return LOCALSTR(@"Unknown Device");
//    }
//    else if (self.sessionState == CONNECTION_STATE_TIMEOUT) {
//        return LOCALSTR(@"Timeout");
//    }
//    else if (self.sessionState == CONNECTION_STATE_UNSUPPORTED) {
//        return LOCALSTR(@"Unsupported");
//    }
//    else if (self.sessionState == CONNECTION_STATE_CONNECT_FAILED) {
//        return LOCALSTR(@"Connect Failed");
//    }
//    return LOCALSTR(@"Off line");
//}

#pragma mark -
-(NSString*)cameraStateDesc{
    if(self.processState == CAMERASTATE_NONE){
        if(self.isConnecting || self.isWakingUp){
            return LOCALSTR(@"Connecting");
        }
        else{
            if(self.isSleeping){
                return LOCALSTR(@"Sleeping");
            }
            else if(self.isAuthConnected){
                return LOCALSTR(@"Online");
            }
            else if(self.isWrongPassword){
                return LOCALSTR(@"Wrong Password");
            }
            else{
                return LOCALSTR(@"Offline");
            }
        }
    }
    else{
        if(self.processState == CAMERASTATE_WILLREBOOTING || self.processState == CAMERASTATE_REBOOTING){
            return LOCALSTR(@"Rebooting...");
        }
        else if(self.processState == CAMERASTATE_WILLRESETING || self.processState == CAMERASTATE_RESETING){
            return LOCALSTR(@"Reseting...");
        }
        else if(self.processState == CAMERASTATE_WILLUPGRADING || self.processState == CAMERASTATE_UPGRADING){
            if(self.upgradePercent > 0){
                return FORMAT(LOCALSTR(@"Upgrading %d%%"),self.upgradePercent);
            }
            else{
                return LOCALSTR(@"Upgrading...");
            }
        }
    }
    return @"";
}

-(BOOL)isSessionConnected{
    return self.cameraConnectState == CONNECTION_STATE_CONNECTED_SESSION || self.isAuthConnected;
}

-(BOOL)isAuthConnected{
    return self.cameraConnectState == CONNECTION_STATE_CONNECTED;
}

-(BOOL)isConnecting{
    return self.cameraConnectState == CONNECTION_STATE_CONNECTING || self.cameraConnectState == CONNECTION_STATE_CONNECTED_SESSION;
}
-(BOOL)isSessionConnecting{
    return self.cameraConnectState == CONNECTION_STATE_CONNECTING;
}

-(BOOL)isDisconnect{
    return self.cameraConnectState == CONNECTION_STATE_DISCONNECTED || self.cameraConnectState == CONNECTION_STATE_CONNECT_FAILED || self.cameraConnectState == CONNECTION_STATE_UNSUPPORTED || self.cameraConnectState == CONNECTION_STATE_NONE || self.cameraConnectState == CONNECTION_STATE_UNKNOWN_DEVICE || self.cameraConnectState == CONNECTION_STATE_TIMEOUT || self.cameraConnectState == CONNECTION_STATE_NETWORK_FAILED;
}

-(BOOL)isWrongPassword{
    return self.cameraConnectState == CONNECTION_STATE_WRONG_PASSWORD;
}
- (void)syncWithPhoneTime{
    SMsgAVIoctrlSetTimeReq *req = malloc(sizeof(SMsgAVIoctrlSetTimeReq));
    memset(req, 0, sizeof(SMsgAVIoctrlSetTimeReq));
    memcpy(req->NtpServ, NTP_SERVER, NTP_SERVER.length);
    req->NtpEnable = 1;
    req->AdjustFlg = 1;
    req->TimeInfo = [Event getTimeDay:[[NSDate date] timeIntervalSince1970]];
    [self sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_TIME_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetTimeReq)];
    free(req);
    req = nil;
}


- (id)init
{
    self = [super init];
    if (self) {
        arrayStreamChannel = [[NSMutableArray alloc] init];
        self.remoteNotifications = 0;
        self.delegate = self;
        self.host = @"";
        self.port = @"";
        self.ddns = @"";
        self.cameraModel = CAMERA_MODEL_H264;
        reConnectTimes = 0;
    }
    return self;
}

- (id)initWithName:(NSString *)name viewAccount:(NSString *)viewAcc_ viewPassword:(NSString *)viewPwd_
{
    self = [super initWithName:name];
    
    if (self) {
        arrayStreamChannel = [[NSMutableArray alloc] init];
        self.user = viewAcc_;
        self.pwd = viewPwd_;
        self.remoteNotifications = 0;
        self.delegate = self;
        self.host = @"";
        self.port = @"";
        self.ddns = @"";
        self.cameraModel = CAMERA_MODEL_H264;
    }
    
    return self;
}
- (id)initWithUid:(NSString *)uid Name:(NSString*)name UserName:(NSString *)viewAcc_ Password:(NSString *)viewPwd_{
     self = [self initWithName:name viewAccount:viewAcc_ viewPassword:viewPwd_];
     if(self){
         self.uid = uid;
         self.nickName = name;
     }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didReceiveIOCtrl" object:nil];
    self.cameraDelegate = nil;
}

-(void)start{
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
    [self connect:self.uid];
    [self start:0];
}

-(void)connect{
     NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
     [self connect:self.uid];
}

-(void)stop{
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
    [self stop:0];
    [self disconnect];
}

- (void)start:(NSInteger)channel
{
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
    [super start:channel viewAccount:user viewPassword:pwd];
}

-(void)startVideo{
    [self startShow:0];
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
}

-(void)stopVideo{
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
    [self stopShow:0];
}

-(void)stopVideoAsync:(void (^)(void))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self stopVideo];
        if(block != nil){
            block();
        }
    });
}

-(void)startAudio{
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
    
    [self startSoundToPhone:0];
}
-(void)startAudio:(NSInteger)channel{
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
    [self startSoundToPhone:channel];
}
-(void)stopAudio{
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
    [self stopSoundToPhone:0];
}

-(void)startSpeak{
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
    [self startSoundToDevice:0];
}

-(void)stopSpeak{
    NSLog(@"%@ %@ %s %d",[self uid],[self class],__func__,__LINE__);
    [self stopSoundToDevice:0];
}


-(void)PTZ:(unsigned char)ctrl{
    if (ctrl == AVIOCTRL_PTZ_LEFT_UP) {
        [self send_PTZ:AVIOCTRL_PTZ_LEFT isStop:NO];
        [self send_PTZ:AVIOCTRL_PTZ_UP isStop:YES];
        return;
    }
    if (ctrl == AVIOCTRL_PTZ_LEFT_DOWN) {
        [self send_PTZ:AVIOCTRL_PTZ_LEFT isStop:NO];
        [self send_PTZ:AVIOCTRL_PTZ_DOWN isStop:YES];
        return;
    }
    if (ctrl == AVIOCTRL_PTZ_RIGHT_UP) {
        [self send_PTZ:AVIOCTRL_PTZ_RIGHT isStop:NO];
        [self send_PTZ:AVIOCTRL_PTZ_UP isStop:YES];
        return;
    }
    if (ctrl == AVIOCTRL_PTZ_RIGHT_DOWN) {
        [self send_PTZ:AVIOCTRL_PTZ_RIGHT isStop:NO];
        [self send_PTZ:AVIOCTRL_PTZ_DOWN isStop:YES];
        return;
    }
    [self send_PTZ:ctrl isStop:YES];
}

-(void)send_PTZ:(unsigned char)ctrl isStop:(BOOL)isStop{
    if (ctrl != AVIOCTRL_PTZ_STOP && isStop == YES) {
        if (ptz_timer) {
            [ptz_timer invalidate];
            ptz_timer = nil;
        }
        ptz_timer = [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(stopPT) userInfo:nil repeats:NO];
    }
    
    SMsgAVIoctrlPtzCmd *request = (SMsgAVIoctrlPtzCmd *)malloc(sizeof(SMsgAVIoctrlPtzCmd));
    request->control = ctrl;
    request->channel = 0;
    request->speed = 2;
    request->point = 0;
    request->limit = 0;
    request->aux = 0;
    NSLog(@"%d",ctrl);
    
    [self sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_PTZ_COMMAND Data:(char *)request DataSize:sizeof(SMsgAVIoctrlPtzCmd)];
    
    free(request);
    request = nil;
}

- (void)stopPT
{
    ptz_timer = nil;
    [self send_PTZ:AVIOCTRL_PTZ_STOP isStop:NO];
}

-(void)setResolutionModel:(int)resolutionModel{
    NSLog(@"%@ %s %d",[self class],__func__,__LINE__);
    [self stopVideo];
    
    SMsgAVIoctrlSetStreamCtrlReq *s = malloc(sizeof(SMsgAVIoctrlSetStreamCtrlReq));
    memset(s, 0, sizeof(SMsgAVIoctrlSetStreamCtrlReq));
    s->channel = 0;
    
    if (resolutionModel == Resolution_MODEL_SPEED) {
        s->quality = AVIOCTRL_QUALITY_MIN;
    }else if (resolutionModel == Resolution_MODEL_HD) {
        s->quality = AVIOCTRL_QUALITY_MIDDLE;
    }else if (resolutionModel == Resolution_MODEL_UHD) {
        s->quality = AVIOCTRL_QUALITY_MAX;
    }
    
    [self sendIOCtrlToChannel:0
                         Type:IOTYPE_USER_IPCAM_SETSTREAMCTRL_REQ
                         Data:(char *)s
                     DataSize:sizeof(SMsgAVIoctrlSetStreamCtrlReq)];
    
    free(s);
    s = nil;
}

- (void)setRemoteNotification:(NSInteger)type EventTime:(long)time
{
    NSLog(@"setRemoteNotification %@ %@ %s %d",[self class],[self.cameraDelegate class],__func__,__LINE__);
    if(self.remoteNotifications > 0){
        self.remoteNotifications++;
        [GBase editCamera:(BaseCamera*)self];
        if(self.cameraDelegate != nil && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceiveRemoteNotification:EventTime:)]){
            [self.cameraDelegate camera:self.baseCamera _didReceiveRemoteNotification:type EventTime:time];
        }
    }
}

- (void)clearRemoteNotifications
{
    if(self.remoteNotifications > 0){
        self.remoteNotifications = 1;
    }
    else{
        self.remoteNotifications = 0;
    }
    [GBase editCamera:(BaseCamera*)self];
}

#pragma mark - CameraDelegate Methods
- (void)camera:(Camera *)camera didReceiveRawDataFrame:(NSData *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height
{
    if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceiveRawDataFrame:VideoWidth:VideoHeight:)]) {
        [self.cameraDelegate camera:self.baseCamera _didReceiveRawDataFrame:[imgData bytes] VideoWidth:width VideoHeight:height];
    }
}

- (void)camera:(Camera *)camera didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size
{
    if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceiveJPEGDataFrame:DataSize:)]) {
        [self.cameraDelegate camera:self.baseCamera _didReceiveJPEGDataFrame:imgData DataSize:size];
    }
}

- (void)camera:(Camera *)camera didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount
{
    if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceiveFrameInfoWithVideoWidth:VideoHeight:VideoFPS:VideoBPS:AudioBPS:OnlineNm:FrameCount:IncompleteFrameCount:)]) {
        [self.cameraDelegate camera:self.baseCamera _didReceiveFrameInfoWithVideoWidth:videoWidth VideoHeight:videoHeight VideoFPS:fps VideoBPS:videoBps AudioBPS:audioBps OnlineNm:onlineNm FrameCount:frameCount IncompleteFrameCount:incompleteFrameCount];
    }
}

- (void)camera:(Camera *)camera didChangeSessionStatus:(NSInteger)status
{
    

    //手动调用stop接口才是CONNECTION_STATE_DISCONNECTED ||
    if(status == CONNECTION_STATE_TIMEOUT || status == CONNECTION_STATE_CONNECT_FAILED ||  status == CONNECTION_STATE_UNKNOWN_DEVICE || status == CONNECTION_STATE_NETWORK_FAILED){
        if(self.processState == CAMERASTATE_WILLREBOOTING){
            self.processState = CAMERASTATE_REBOOTING;
            _beginRebootTime = [NSDate timeIntervalSinceReferenceDate];
            _rebootTimeout = 120;
        }
        else if(self.processState == CAMERASTATE_WILLRESETING){
            self.processState = CAMERASTATE_RESETING;
            _beginRebootTime = [NSDate timeIntervalSinceReferenceDate];
            _rebootTimeout = 120;
            
        }
        if([NSDate timeIntervalSinceReferenceDate] - _beginRebootTime > _rebootTimeout){
            if(_processState != CAMERASTATE_NONE){
                _processState = CAMERASTATE_NONE;
            }
        }
        
        if(self.processState != CAMERASTATE_NONE){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stop];
                [self start];
            });
        }
        else if(status == CONNECTION_STATE_TIMEOUT){
            if(self.connectTimeoutBeginTime == 0){
                self.connectTimeoutBeginTime = [NSDate timeIntervalSinceReferenceDate];
            }
            if([NSDate timeIntervalSinceReferenceDate] - self.connectTimeoutBeginTime < CONNECT_TIMEOUT_WAITTIME){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stop];
                    [self start];
                });
            }
            else{
                [self stop];
            }
        }
        else{
            [self stop];
//            if(reConnectTimes < MAX_RECONNECT_TIMES){
//                reConnectTimes++;
//                [self stop];
//                [self start];
//            }
//            else{
//                [self stop];
//            }
        }
    }
    if(self.isSessionConnected){
        isWakingUp = NO;
        reConnectTimes = 0;
    }
    
    
    self.cameraConnectState = status;
    if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didChangeSessionStatus:)]) {
        [self.cameraDelegate camera:self.baseCamera _didChangeSessionStatus:status];
    }
    
}

- (void)camera:(Camera *)camera didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status
{
    LOG(@"%@ %@ %s %d %ld",[self uid],[self class],__func__,__LINE__,(long)status);
    if(status == CONNECTION_STATE_CONNECTED && self.processState != CAMERASTATE_WILLUPGRADING && self.processState != CAMERASTATE_WILLREBOOTING && self.processState != CAMERASTATE_WILLRESETING){
        self.processState = CAMERASTATE_NONE;
    }
    else if(status == CONNECTION_STATE_WRONG_PASSWORD){
        if(self.processState == CAMERASTATE_RESETING){
            LOG(@"%@ %@ %s %d %ld",[self uid],[self class],__func__,__LINE__,(long)status);
            [self setPwd:DEFAULT_PASSWORD];
            [GBase editCamera:(BaseCamera*)self];
            [self start:0];
        }
    }
    if(channel == 0){
        self.cameraConnectState = status;
    }
    LOG(@"%@ %@ %s %d %ld",[self uid],[self class],__func__,__LINE__,(long)status);
    if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didChangeChannelStatus:ChannelStatus:)]) {
        LOG(@"%@ %@ %s %d %ld",[self uid],[self class],__func__,__LINE__,(long)status);
        [self.cameraDelegate camera:self.baseCamera _didChangeChannelStatus:channel ChannelStatus:status];
    }
    
    if (status == CONNECTION_STATE_WRONG_PASSWORD) {
        isWakingUp = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
        });
    }
    else if(status == CONNECTION_STATE_CONNECTED){
        isWakingUp = NO;
        SMsgAVIoctrlGetAudioOutFormatReq *s = (SMsgAVIoctrlGetAudioOutFormatReq *)malloc(sizeof(SMsgAVIoctrlGetAudioOutFormatReq));
        s->channel = (unsigned int)channel;
        [self sendIOCtrlToChannel:channel Type:IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ Data:(char *)s DataSize:sizeof(SMsgAVIoctrlGetAudioOutFormatReq)];
        free(s);
        s = nil;
        
        [self getInitConfig];
    }
}

- (void)camera:(Camera *)camera didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size
{
    if(type == IOTYPE_USER_IPCAM_DEVINFO_RESP){
        self.deviceInfo = [[DeviceInfo_TUTK alloc] initWithData:(char*)data size:(int)size];
        if(self.modelName == nil || ![self.modelName isEqualToString:self.deviceInfo.model]){
            self.modelName = self.deviceInfo.model;
            [self getInitConfig];
        }
    }
    else if(type == IOTYPE_USER_IPCAM_GET_BAT_PRAM_RESP){
        SMsgGetBatPramResp *resp = (SMsgGetBatPramResp*)data;
        self.batterPercent = resp->bat_percent;
        self.batteryMode = resp->work_mode;
        self.batteryTime = [[NSDate date] timeIntervalSince1970];
        dispatch_async(dispatch_get_main_queue(), ^{
            [GBase editCamera:(BaseCamera*)self];
        });
        
    }
    
    
    if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceiveIOCtrlWithType:Data:DataSize:)]) {
        [self.cameraDelegate camera:self.baseCamera _didReceiveIOCtrlWithType:type Data:data DataSize:size];
    }
    
    NSData *buf = [NSData dataWithBytes:data length:size];
    NSNumber *t = [NSNumber numberWithLong:type];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: buf, @"recvData", t, @"type", self.uid, @"uid", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveIOCtrl" object:self userInfo:dict];
    
    if (type == (int)IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_RESP) {
        
        [arrayStreamChannel removeAllObjects];
        
        SMsgAVIoctrlGetSupportStreamResp *s = (SMsgAVIoctrlGetSupportStreamResp *)data;
        
        if (s->number > 0) {
            SStreamDef *def = malloc(size - (sizeof(s->number)));
            memcpy(def, s->streams, size - (sizeof(s->number)));
            
            for (int i = 0; i < s->number; i++) {
                
                SubStream_t ch;
                ch.index = def[i].index;
                ch.channel = def[i].channel;
                
                NSValue *objCh = [[NSValue alloc] initWithBytes:&ch objCType:@encode(SubStream_t)];
                [arrayStreamChannel addObject:objCh];
                
                if (def[i].channel != 0) {
                    [self start:def[i].channel viewAccount:self.user viewPassword:self.pwd];
                }
            }
            free(def);
            def = nil;
        }
    }
    else if(type == IOTYPE_USER_IPCAM_REBOOT_RESP || type == IOTYPE_USER_IPCAM_REBOOT_SYSTEM_RESP){
        SMsgAVIoctrlResultResp *resp = (SMsgAVIoctrlResultResp*)data;
        if(resp->result == 0){
            self.processState = CAMERASTATE_WILLREBOOTING;
        }
    }
    else if(type == IOTYPE_USER_IPCAM_RESET_DEFAULT_RESP){
        SMsgAVIoctrlResultResp *resp = (SMsgAVIoctrlResultResp*)data;
        if(resp->result == 0){
            self.processState = CAMERASTATE_WILLRESETING;
        }
    }
    else if(type == IOTYPE_USER_IPCAM_SET_UPRADE_RESP){
        SMsgAVIoctrlResultResp *resp = (SMsgAVIoctrlResultResp*)data;
        if(resp->result == 0){
            self.processState = CAMERASTATE_WILLUPGRADING;
            self.beginRebootTime = [NSDate timeIntervalSinceReferenceDate];
            self.rebootTimeout = 120;
        }
    }
    else if(type == IOTYPE_USER_IPCAM_UPGRADE_STATUS){
        SMsgAVIoctrlUpgradeStatus *resp = (SMsgAVIoctrlUpgradeStatus*)data;
        self.upgradePercent = resp->p;
        if(resp->p>=100){
            self.processState = CAMERASTATE_WILLREBOOTING;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[iToast makeText:LOCALSTR(@"Firmware update success, camera will reboot later, please wait a moment.")] setDuration:2] show];
            });
        }
    }
    else if(type == IOTYPE_USER_IPCAM_GET_TIME_INFO_RESP){
        SMsgAVIoctrlGetTimeResp *devTime = (SMsgAVIoctrlGetTimeResp*)data;
        
        if(devTime->TimeType == 0 && devTime->AdjustFlg == 0){
            [self syncWithPhoneTime];
//            if(self.timezone){
//                [self syncWithPhoneTime];
//            }
//            else{
//                [self getTimezone];
//            }
        }
    }
//    else if(type == IOTYPE_USER_IPCAM_GET_ZONE_INFO_RESP){
//        if(needSyncTime){
//            SMsgAVIoctrlGetDstResp *resp = (SMsgAVIoctrlGetDstResp*)data;
//            for(int i=0; i < [TimeZoneModel getAll].count; i++){
//                TimeZoneModel *tz = [[TimeZoneModel getAll] objectAtIndex:i];
//                if([tz.area isEqualToString:[NSString stringWithUTF8String:resp->DstDistrictInfo.DstDistId]]){
//                    self.timezone = [TimeZoneModel initObj:tz.timezone area:tz.area gmt:tz.strGMT daylight:tz.dst];
//                    self.timezone.dst = resp->enable && tz.dst;
//                    break;
//                }
//            }
//            [self syncWithPhoneTime];
//        }
//    }
}



//获取截图
- (UIImage *)image {
    
    if ([self fileExistsAtPath:self.imagePath]) {
        return [UIImage imageWithContentsOfFile:self.imagePath];
    }
    else {
        return [UIImage imageNamed:@"videoclip"];
    }
}


//保存截图至沙盒
- (void)saveImage:(UIImage *)image {
     NSString *extension = [[[self.imagePath componentsSeparatedByString:@"."] lastObject] lowercaseString];
    if([extension isEqualToString:@"png"]){
        [UIImagePNGRepresentation(image) writeToFile:self.imagePath atomically:YES];
    }
    else{
        [UIImageJPEGRepresentation(image, 0.5) writeToFile:self.imagePath atomically:YES];
    }
}

//判断一个文件是否存在
- (BOOL)fileExistsAtPath:(NSString *)filePath {
    NSFileManager *tFileManager = [NSFileManager defaultManager];
    return [tFileManager fileExistsAtPath:filePath];
}


//保存图片沙盒路径
- (NSString *)imagePath {
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", self.uid];
    NSString *filePath = [[self documents] stringByAppendingPathComponent:fileName];
    return filePath;
}

//获取截图
- (UIImage *)remoteRecordImage:(NSInteger)time type:(NSInteger)tp{
    if ([self fileExistsAtPath:[self remoteRecordImagePath:time type:tp]]) {
        return [UIImage imageWithContentsOfFile:[self remoteRecordImagePath:time type:tp]];
    }
    else {
        return nil;
    }
}


////保存截图至沙盒
//- (void)saveRemoteRecordImage:(UIImage *)image recordId:(NSInteger)time type:(NSInteger)tp {
//    //[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
//    [UIImagePNGRepresentation(image) writeToFile:[self remoteRecordImagePath:time type:tp] atomically:YES];
//}
//
//保存图片沙盒路径
- (NSString *)remoteRecordImagePath:(NSInteger)recordId type:(NSInteger)tp{
    NSString *fileName = [self remoteRecordThumbName:recordId type:tp];
    NSString *filePath = [[self documents] stringByAppendingPathComponent:fileName];
    return filePath;
}

- (NSString *)remoteRecordThumbName:(NSInteger)recordId type:(NSInteger)tp{
    NSString *fileName = [NSString stringWithFormat:@"%@_%d_%ld.jpg", self.uid,(int)tp,(long)recordId];
    return fileName;
}

//Documents
- (NSString *)documents {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


-(void)openPush:(void (^)(NSInteger code))successlock{
    if(!self.pushToken){
        if(successlock != nil){
            successlock(0x11);
        }
        return;
    }
    if(!self.uid){
        if(successlock != nil){
            successlock(0x12);
        }
        return;
    }
    
    NSString *timestamp = FORMAT(@"%ld",(long)[[NSDate date] timeIntervalSince1970]);
    NSString *appid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *key = @"tenvisapp";
    NSString *uid = self.uid;
    NSString *token2 = self.pushToken;
    NSString *token1 = @"";
    NSString *sign = [TwsTools createSign:@[appid,key,uid,token1,token2,timestamp]];
    NSString *url =FORMAT(@"http://push.tenvis.com:8001/api/push/open?token1=%@&token2=%@&uid=%@&timestamp=%@&appid=%@&sign=%@&platform=ios",token1,token2,uid,timestamp,appid,sign);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       NSInteger respCode = -1;
       NSString *result = [self getHttpResp:url];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        if(jsonObj != nil && [jsonObj isKindOfClass:[NSDictionary class]]){
            NSDictionary *jsonDic = (NSDictionary *)jsonObj;
            NSNumber *numberCode = [jsonDic objectForKey:@"ret_code"];
            if(numberCode){
                if(numberCode.intValue == 0){
                    self.remoteNotifications = 1;
                    [GBase editCamera:(BaseCamera*)self];
                }
                respCode = numberCode.intValue;
            }
        }
        if(successlock != nil){
            successlock(respCode);
        }
    });
   
    
}
-(NSString*)getHttpResp:(NSString*)url{
    NSString* webStringURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url1 = [NSURL URLWithString:webStringURL];
    NSLog(@"webStringURL = %@", webStringURL);
    //創建一個請求
    NSURLRequest * pRequest = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //建立連接
    NSURLResponse * pResponse = nil;
    NSError * pError = nil;
    //向伺服器發起請求（發出後線程就會一直等待伺服器響應，知道超出最大響應事件），獲取數據後，轉換為NSData類型數據
    NSData * pData = [NSURLConnection sendSynchronousRequest:pRequest returningResponse:&pResponse error:&pError];
    //輸出數據，查看，??後期還可以解析數據
    NSString *responseStr = [[NSString alloc] initWithData:pData encoding:NSUTF8StringEncoding];
    NSLog(@"htmlString = %@", responseStr);
    return responseStr;
}
-(void)closePush:(void (^)(NSInteger code))successlock{
    if(!self.pushToken){
        if(successlock != nil){
            successlock(0x11);
        }
        return;
    }
    if(!self.uid){
        if(successlock != nil){
            successlock(0x12);
        }
        return;
    }
    NSString *timestamp = FORMAT(@"%ld",(long)[[NSDate date] timeIntervalSince1970]);
    NSString *appid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *key = @"tenvisapp";
    NSString *uid = self.uid;
    NSString *token1 = @"";
    NSString *token2 = self.pushToken;
    NSString *sign = [TwsTools createSign:@[appid,key,uid,token1,token2,timestamp]];
    NSString *url =FORMAT(@"http://push.tenvis.com:8001/api/push/close?token1=%@&token2=%@&uid=%@&timestamp=%@&appid=%@&sign=%@&platform=ios",token1,token2,uid,timestamp,appid,sign);
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSInteger respCode = -1;
        NSString *result = [self getHttpResp:url];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        if(jsonObj != nil && [jsonObj isKindOfClass:[NSDictionary class]]){
            NSDictionary *jsonDic = (NSDictionary *)jsonObj;
            NSNumber *numberCode = [jsonDic objectForKey:@"ret_code"];
            if(numberCode){
                if(numberCode.intValue == 0){
                    self.remoteNotifications = 0;
                    [GBase editCamera:(BaseCamera*)self];
                }
                respCode = numberCode.intValue;
            }
        }
        if(successlock != nil){
            successlock(respCode);
        }
    });
}

-(BOOL)isDisconnected{
    return self.cameraConnectState != CONNECTION_STATE_CONNECTING && self.cameraConnectState != CONNECTION_STATE_CONNECTED && self.cameraConnectState != CONNECTION_STATE_WRONG_PASSWORD;
}
-(NSString*)strConnectState{
    if(self.processState == CAMERASTATE_NONE){
        if(self.cameraConnectState == CONNECTION_STATE_CONNECTING){
           return LOCALSTR(@"Connecting");
        }
        else{
            if(self.cameraConnectState == CONNECTION_STATE_CONNECTED){
                return LOCALSTR(@"Online");
            }
            else if(self.cameraConnectState == CONNECTION_STATE_WRONG_PASSWORD){
                return LOCALSTR(@"Wrong Password");
            }
            else{
                return LOCALSTR(@"Offline");
            }
        }
    }
    else{
        if(self.processState == CAMERASTATE_WILLREBOOTING || self.processState == CAMERASTATE_REBOOTING){
            return LOCALSTR(@"Rebooting...");
        }
        else if(self.processState == CAMERASTATE_WILLRESETING || self.processState == CAMERASTATE_RESETING){
            return LOCALSTR(@"Reseting...");
        }
        else if(self.processState == CAMERASTATE_WILLUPGRADING || self.processState == CAMERASTATE_UPGRADING){
            if(self.upgradePercent > 0){
                return FORMAT(LOCALSTR(@"Upgrading %d%%"),self.upgradePercent);
            }
            else{
                return LOCALSTR(@"Upgrading...");
            }
        }
    }
    return @"";
}
//判断划动手势，返回摄像机转动方向
- (NSInteger)direction:(CGPoint)translation {
    
    if (fabs(translation.x) > fabs(translation.y)) {
        return translation.x > 0.0  ?AVIOCTRL_PTZ_LEFT :AVIOCTRL_PTZ_RIGHT;
    }
    else {
        return translation.y > 0.0 ? AVIOCTRL_PTZ_UP:AVIOCTRL_PTZ_DOWN;
    }
}

-(NSString*)pushToken{
    return [self.camDefaults objectForKey:@"push_deviceToken"];
}
- (NSUserDefaults *)camDefaults {
    if (!_camDefaults) {
        _camDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _camDefaults;
}

-(CGFloat)videoRatio{
    if(!_vRatio){
        _vRatio = [GBase getCameraVideoRatio:(BaseCamera*)self];
    }
    return _vRatio;
}
-(void)setVideoRatio:(CGFloat)videoRatio{
    _vRatio = videoRatio;
    [GBase setCameraVideoRatio:(BaseCamera*)self ratio:videoRatio];
}
-(BOOL)getCommandFunction:(int)cmd{
    return YES;
}

-(void)getTime{
    SMsgAVIoctrlGetTimeReq *req = malloc(sizeof(SMsgAVIoctrlGetTimeReq));
    //req->ReqTimeType = 0;
    [self sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_TIME_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetTimeReq)];
    free(req);
    req = nil;
}

-(void)getTimezone{
    SMsgAVIoctrlGetTimeReq *req = malloc(sizeof(SMsgAVIoctrlGetTimeReq));
    [self sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_ZONE_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetTimeReq)];
    free(req);
    req = nil;
}

-(void)wakeUp{
    isWakingUp = YES;
    [self stop];
    [super wakeup:self.uid];
}
-(BOOL)isSleeping{
    return self.cameraConnectState == CONNECTION_STATE_SLEEPING;
}

-(BOOL)isWakingUp{
    return self.cameraConnectState == CONNECTION_STATE_WAKINGUP || isWakingUp;
}
-(NSInteger)supplier{
    if(self.modelName == nil){
        return SUPLLIER_UNKNOWN;
    }
    else if([self.modelName isEqualToString:@"E936"]){
        return SUPLLIER_AN;
    }
    else{
        return SUPLLIER_FB;
    }
    //return self.deviceInfo == nil ? SUPLLIER_UNKNOWN : ([self.deviceInfo.] SUPLLIER_HX);
}

-(void)getInitConfig{
    if(self.modelName == nil){
        SMsgAVIoctrlDeviceInfoReq *req = malloc(sizeof(SMsgAVIoctrlDeviceInfoReq));
        [self sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_DEVINFO_REQ Data:(char *)req DataSize:sizeof(SMsgAVIoctrlDeviceInfoReq)];
        free(req);
        req = nil;
    }
    if(self.supplier == SUPLLIER_FB){
        [self getTime];
    }
    else if(self.supplier == SUPLLIER_AN){
        [self sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_BAT_PRAM_REQ Data:(char *)nil DataSize:0];
    }
}

@end
