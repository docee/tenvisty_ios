//
//  HichipCamera.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/18.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "HichipCamera.h"
#import "CameraIOSessionProtocol.h"

@interface HichipCamera()<CameraIOSessionProtocol>


@end

@implementation HichipCamera

@synthesize isSessionConnected;

@synthesize isAuthConnected;

@synthesize processState;

@synthesize isDisconnect;

@synthesize isWrongPassword;


@synthesize cameraDelegate;

@synthesize pwd;

@synthesize nickName;

@synthesize videoQuality;

@synthesize cameraConnectState;

@synthesize isConnecting;

@synthesize p2pType;

@synthesize upgradePercent;

@synthesize remoteNotifications;

@synthesize user;

@synthesize isPlaying;

@synthesize videoRatio;

@synthesize cameraStateDesc;


-(NSString*)pwd{
    return super.password;
}

-(NSString*)user{
    return super.username;
}

-(NSInteger)remoteNotifications{
    return 0;
}

-(BOOL)isSessionConnected{
    return self.getConnectState == CAMERA_CONNECTION_STATE_CONNECTED;
}

-(BOOL)isAuthConnected{
    return self.getConnectState == CAMERA_CONNECTION_STATE_LOGIN;
}

-(BOOL)isConnecting{
    return self.getConnectState == CAMERA_CONNECTION_STATE_CONNECTING || [self isSessionConnected];
}

-(BOOL)isDisconnect{
    return self.getConnectState == CAMERA_CONNECTION_STATE_DISCONNECTED || self.getConnectState == CAMERA_CONNECTION_STATE_UIDERROR;
}

-(BOOL)isWrongPassword{
    return self.getConnectState == CAMERA_CONNECTION_STATE_WRONG_PASSWORD;
}

-(NSString*)cameraStateDesc{
    if(self.processState == CAMERASTATE_NONE){
        if(self.isConnecting){
            return LOCALSTR(@"Connecting");
        }
        else{
            if(self.isAuthConnected){
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

- (void)PTZ:(unsigned char)ctrl {
    
}

- (void)clearRemoteNotifications {
    
}

- (void)closePush:(void (^)(NSInteger))successlock {
    
}



- (UIImage *)image {
    return nil;
}

- (id)initWithUid:(NSString *)uid Name:(NSString *)name UserName:(NSString *)viewAcc_ Password:(NSString *)viewPwd_ {
    if (self = [super initWithUid:uid Username:viewAcc_ Password:viewPwd_]) {
        self.nickName = name;
        [self registerIOSessionDelegate:self];
    }
    return self;
}

- (void)openPush:(void (^)(NSInteger))successlock {
    
}

- (UIImage *)remoteRecordImage:(NSInteger)time type:(NSInteger)tp {
    return nil;
}

- (NSString *)remoteRecordThumbName:(NSInteger)recordId type:(NSInteger)tp {
     return nil;
}

- (void)saveImage:(UIImage *)image {
    
}

- (void)sendIOCtrlToChannel:(NSInteger)channel Type:(NSInteger)type Data:(char *)buff DataSize:(NSInteger)size {
    
}

- (void)setRemoteNotification:(NSInteger)type EventTime:(long)time {
    
}

- (void)start {
    if ([self shouldConnect]) {
        if ((self.getConnectState == CAMERA_CONNECTION_STATE_DISCONNECTED || self.getConnectState == CAMERA_CONNECTION_STATE_WRONG_PASSWORD)  && ([super getThreadState] == 0)){
            [self connect];
        }
    }
}

- (void)startAudio {
    [self startListening];
}

- (void)startRecordVideo:(NSString *)filePath {
    
}

- (void)startSpeak {
    [self startTalk];
}

- (void)startVideo {
    
}

- (void)stop {
     [self disconnect_session];
}

- (void)stopAudio {
    [self stopListening];
}

- (BOOL)stopRecordVideo {
    return YES;
}

- (void)stopSpeak {
    [self stopTalk];
}

- (void)stopVideo {
    [self stopLiveShow];
}

- (void)stopVideoAsync:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self stopVideo];
        if(block != nil){
            block();
        }
    });
}


- (BOOL)shouldConnect {
    
    if (self.uid && self.uid.length > 4) {
        NSArray *temps = nil;
        
        // 艾赛德类型的设备
        if ([DisplayName isEqualToString:@"Security Visual"]) {
            
            NSString *temp = [self.uid substringWithRange:NSMakeRange(0, 4)];
            temps = @[@"AAES"];
            for (NSString *t_uid in temps) {
                // 不区分大小写
                if ([t_uid caseInsensitiveCompare:temp] == NSOrderedSame) {
                    return YES;
                }
            }
            
        }else {
            
            //20171116 ZK修改：
            temps = @[@"FDTAA",@"DEAA",@"AAES"];//其他的APP不能连接的UID
            __block NSString *behind = [self.uid substringWithRange:NSMakeRange(0, 5)];
            __block BOOL couldConnect = YES;
            [temps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString* temStr = obj;
                if ([behind hasPrefix:temStr]) {
                    couldConnect = NO;
                    *stop = YES;
                }
            }];
            return couldConnect;
            
        }
    }
    return NO;
}

- (void)receiveSessionState:(HiCamera *)camera Status:(int)status {
    self.cameraConnectState = status;
    if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didChangeSessionStatus:)]) {
        [self.cameraDelegate camera:self.baseCamera _didChangeSessionStatus:status];
    }
    LOG(@">>>HiCamera_receiveSessionState %@ %@ %x", camera.uid, self.cameraStateDesc, status);
    
    
    
    if(status == CAMERA_CONNECTION_STATE_LOGIN) {
        
        //[self sendIOCtrl:HI_P2P_GET_TIME_ZONE Data:(char *)nil Size:0];
        //同步时间
        [self sendIOCtrl:HI_P2P_GET_TIME_PARAM Data:nil Size:0];
        //        ListReq *listReq = [[ListReq alloc] init];
        //        [self request:HI_P2P_PB_QUERY_START dson:[self dic:listReq]];
        // 链接成功后，发送推送服务器地址, 检测是否开启信鸽推送，开启时向服务器注册subID
        if ([self getCommandFunction:HI_P2P_ALARM_ADDRESS_SET]) {//如果该相机支持设置服务器地址
            [self sendPushServerAddress:camera.uid];
        }
        
    }
}


- (void)receiveIOCtrl:(HiCamera *)camera Type:(int)type Data:(char*)data Size:(int)size Status:(int)status {
    LOG(@">>>HiCamera_receiveIOCtrl %@ %x %d %d",camera.uid, type, size, status);
    
    
}
- (void)receivePlayState:(HiCamera *)camera State:(int)state Width:(int)width Height:(int)height{
    
}
- (void)receivePlayUTC:(HiCamera *)camera Time:(int)time{
    
}

- (void)receiveDownloadState:(HiCamera*)camera Total:(int)total CurSize:(int)curSize State:(int)state Path:(NSString*)path{
    
}

- (BOOL)isGoke {
    return [self getChipVersion] == CHIP_VERSION_GOKE ? YES : NO;
}
// 发送推送服务器地址
- (void)sendPushServerAddress:(NSString* )uidd {
    [self getDeviceServerIPAddress];//先获取一次设备地址
    NSLog(@"UIDwe aaaadddsi:%@   %@",uidd,AlarmPushServerIPAddress);
}

-(void)getDeviceServerIPAddress{
    if ([self getCommandFunction:HI_P2P_ALARM_ADDRESS_GET]) {
        [self sendIOCtrl:HI_P2P_ALARM_ADDRESS_GET Data:(char*)nil Size:0];
    }
}

@end
