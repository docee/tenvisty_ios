//
//  HichipCamera.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/18.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#define CONNECT_TIMEOUT_WAITTIME 30
#import "HichipCamera.h"
#import "CameraIOSessionProtocol.h"
#import "HiPushSDK.h"
#import "TimeZoneModel.h"
#import "CameraFunction.h"

@interface HichipCamera()<CameraIOSessionProtocol,OnPushResult>{
    BOOL isStopManually;
}


@property (nonatomic, assign) int subID;
@property (nonatomic, strong) NSUserDefaults *camDefaults;
@property (nonatomic, strong) HiPushSDK *pushSDK;

@property (nonatomic,assign) NSInteger beginRebootTime;
@property (nonatomic,assign) NSInteger rebootTimeout;
@property (nonatomic,assign) NSInteger connectTimeoutBeginTime;
@property (nonatomic, strong)  NetParam *netParam;

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
@synthesize isSessionConnecting;


-(NSString*)pwd{
    return super.password;
}

-(void)setPwd:(NSString *)pwd{
    super.password = pwd;
}

-(NSString*)user{
    return super.username;
}
-(void)setUser:(NSString *)user{
    super.username = user;
}

-(NSInteger)remoteNotifications{
    return [self isPushOn];
}

-(BOOL)isSessionConnected{
    return self.getConnectState == CAMERA_CONNECTION_STATE_CONNECTED || self.isAuthConnected || self.isWrongPassword;
}

-(BOOL)isAuthConnected{
    return self.getConnectState == CAMERA_CONNECTION_STATE_LOGIN;
}

-(BOOL)isConnecting{
    return self.getConnectState == CAMERA_CONNECTION_STATE_CONNECTING || self.getConnectState == CAMERA_CONNECTION_STATE_CONNECTED;
}
-(BOOL)isSessionConnecting{
    return self.getConnectState == CAMERA_CONNECTION_STATE_CONNECTING || self.getConnectState == CAMERA_CONNECTION_STATE_UIDERROR;
}

-(BOOL)isDisconnect{
    return self.getConnectState == CAMERA_CONNECTION_STATE_DISCONNECTED  || self.getConnectState == CAMERA_CONNECTION_STATE_UIDERROR;
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
    NSInteger direction = -1;
    if(ctrl == TwsDirectionTiltUp){
        direction = HI_P2P_PTZ_CTRL_UP;
    }
    else if(ctrl == TwsDirectionTiltDown){
        direction = HI_P2P_PTZ_CTRL_DOWN;
    }
    else if(ctrl == TwsDirectionPanLeft){
        direction = HI_P2P_PTZ_CTRL_LEFT;
    }
    else if(ctrl == TwsDirectionPanRight){
        direction = HI_P2P_PTZ_CTRL_RIGHT;
    }
    HI_P2P_S_PTZ_CTRL* ptz_ctrl =(HI_P2P_S_PTZ_CTRL *)malloc(sizeof(HI_P2P_S_PTZ_CTRL));
    ptz_ctrl->u32Channel = 0;
    ptz_ctrl->u32Ctrl = (HI_U32)direction;  //转动方向
    ptz_ctrl->u32Mode = (HI_U32)HI_P2P_PTZ_MODE_STEP;    //模式，step 单步， run 持续
    if (self.isGoke) {
        ptz_ctrl->u16TurnTime = 25;
        ptz_ctrl->u16Speed = 25;
    }else{
        ptz_ctrl->u16TurnTime = 50;
        ptz_ctrl->u16Speed = 50;
    }
    
    [self sendIOCtrl:HI_P2P_SET_PTZ_CTRL Data:(char *)ptz_ctrl Size:sizeof(HI_P2P_S_PTZ_CTRL)];
    
    free(ptz_ctrl);
    ptz_ctrl = nil;
}

- (void)clearRemoteNotifications {
    self.remoteNotifications = 1;
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
    LOG(@"开启信鸽推送");
    LOG(@"camera_subID : %@ %d", self.uid, (int)self.subID);
    
    // 支持新能力集才更换新推送服务器地址
    if ([self getCommandFunction:HI_P2P_ALARM_TOKEN_REGIST]) {
        NSLog(@"666 %@",[[NSUserDefaults standardUserDefaults] objectForKey:[self xingePushIPAddressKey]]);
        [self.pushSDK setAlarmPushServerIPAddress:[[NSUserDefaults standardUserDefaults] objectForKey:[self xingePushIPAddressKey]]];
        
    }
    
    [self.pushSDK bind];
}

- (void)closePush:(void (^)(NSInteger))successlock {
    //[HXProgress showProgress];
    LOG(@"关闭信鸽推送")
    LOG(@"camera_subID : %@ %d", self.uid, (int)self.subID);
    // [HXProgress showText: [NSString stringWithFormat:@"uid:%@ subId:%d",self.uid,self.subID]];
    // 区分新老接口
    if (self.subID > 0) {
        
        [self.pushSDK unbindWithSubID:self.subID];
    }
    else{
        [self.pushSDK unbind];
    }
}
- (UIImage *)remoteRecordImage:(NSInteger)time type:(NSInteger)tp {
    return nil;
}

- (NSString *)remoteRecordThumbName:(NSInteger)recordId type:(NSInteger)tp {
    NSString *fileName = [NSString stringWithFormat:@"%@_%d_%ld.jpg", self.uid,(int)tp,(long)recordId];
    return fileName;
}

- (void)saveImage:(UIImage *)image {
    
}

- (void)sendIOCtrlToChannel:(NSInteger)channel Type:(NSInteger)type Data:(char *)buff DataSize:(NSInteger)size {
    [super sendIOCtrl:(int)type Data:buff Size:(int)size];
}

- (void)setRemoteNotification:(NSInteger)type EventTime:(long)time {
    
}

- (void)start {
    isStopManually = NO;
    if ([self shouldConnect]) {
        if ((self.getConnectState == CAMERA_CONNECTION_STATE_DISCONNECTED || self.getConnectState == CAMERA_CONNECTION_STATE_WRONG_PASSWORD)  && ([super getThreadState] == 0)){
            [super connect];
        }
    }
}

-(void)connect{
    isStopManually = NO;
    if ([self shouldConnect]) {
        if ((self.getConnectState == CAMERA_CONNECTION_STATE_DISCONNECTED || self.getConnectState == CAMERA_CONNECTION_STATE_WRONG_PASSWORD)  && ([super getThreadState] == 0)){
            [super connect];
        }
    }
}

- (void)startAudio {
    [self startListening];
}

- (void)startRecordVideo:(NSString *)filePath {
    [super startRecording:filePath];
}

- (void)startSpeak {
    [self startTalk];
}

- (void)startVideo {
    [super startLiveShow:(int)self.videoQuality == 1?0:1 Monitor:nil];
}

- (void)stop {
    isStopManually = YES;
     [self disconnect_session];
}

- (void)stopAudio {
    [self stopListening];
}

- (BOOL)stopRecordVideo {
    [super stopRecording];
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
    if(self.cameraConnectState == status || isStopManually){
        return;
    }
    self.cameraConnectState = status;
    
    //手动调用stop接口才是CONNECTION_STATE_DISCONNECTED ||
    if([self isDisconnect]){
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
        if(self.processState  != CAMERASTATE_NONE){
            if([NSDate timeIntervalSinceReferenceDate] - _beginRebootTime > _rebootTimeout){
                self.processState  = CAMERASTATE_NONE;
            }
        }
        
        if(self.processState != CAMERASTATE_NONE){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self start];
            });
        }
    }
    else if(self.isSessionConnected){
        if(self.isAuthConnected && self.processState != CAMERASTATE_WILLUPGRADING && self.processState != CAMERASTATE_WILLREBOOTING && self.processState != CAMERASTATE_WILLRESETING){
            self.processState = CAMERASTATE_NONE;
        }
        else if(self.isWrongPassword){
            if(self.processState == CAMERASTATE_RESETING){
                [self setPwd:DEFAULT_PASSWORD];
                [GBase editCamera:(BaseCamera*)self];
                [self start];
            }
        }
    }
    if(self.isAuthConnected){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didChangeChannelStatus:ChannelStatus:)]) {
                [self.cameraDelegate camera:self.baseCamera _didChangeChannelStatus:0 ChannelStatus:status];
            }
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didChangeSessionStatus:)]) {
                [self.cameraDelegate camera:self.baseCamera _didChangeSessionStatus:status];
            }
        });
    }
    LOG(@">>>HiCamera_receiveSessionState %@ %@ %x", camera.uid, self.cameraStateDesc, status);
    
    
    
    if(self.isAuthConnected) {
        if([super getCommandFunction:HI_P2P_GET_TIME_ZONE]){
            [self sendIOCtrl:HI_P2P_GET_TIME_ZONE Data:(char*)nil Size:0];
        }
        else if([super getCommandFunction:HI_P2P_GET_TIME_ZONE_EXT]){
            [self sendIOCtrl:HI_P2P_GET_TIME_ZONE_EXT Data:(char*)nil Size:0];
        }
        [self sendIOCtrl:HI_P2P_GET_TIME_PARAM Data:(char*)nil Size:0];
        [self sendIOCtrl:HI_P2P_GET_DEV_INFO_EXT Data:(char*)nil Size:0];
        [self sendIOCtrl:HI_P2P_GET_NET_PARAM Data:(char*)nil Size:0];
        
        if ([self getCommandFunction:HI_P2P_ALARM_ADDRESS_SET]) {//如果该相机支持设置服务器地址
            [self sendPushServerAddress:camera.uid];
        }
        
    }
}


- (void)receiveIOCtrl:(HiCamera *)camera Type:(int)type Data:(char*)data Size:(int)size Status:(int)status {
    LOG(@">>>HiCamera_receiveIOCtrl %@ %x %d %d",camera.uid, type, size, status);
    int needSize = 0;
    switch (type) {
            //获取时区（新命令）
        case HI_P2P_GET_TIME_ZONE_EXT:{
            needSize = sizeof(HI_P2P_S_TIME_ZONE_EXT);
            if(size >= needSize){
                self.zkGmTimeZone = [[newTimeZone alloc] initWithData:data withSize:size];
                if(self.deviceLoginTime != nil && self.deviceLoginTime.u32Year <= 1970){
                    self.deviceLoginTime = nil;
                    [self syncWithPhoneTime];
                }
            }
        }
            break;
        case HI_P2P_GET_TIME_ZONE:{
            needSize = sizeof(HI_P2P_S_TIME_ZONE);
            if(size >= needSize){
                self.gmTimeZone = [[TimeZone alloc] initWithData:data size:size];
                if(self.deviceLoginTime != nil && self.deviceLoginTime.u32Year <= 1970){
                    self.deviceLoginTime = nil;
                    [self syncWithPhoneTime];
                }
            }
        }
            break;
        case HI_P2P_GET_DEV_INFO_EXT:{
            needSize = sizeof(HI_P2P_S_DEV_INFO_EXT);
            if(size >= needSize){
                self.deviceInfoExt = [[DeviceInfoExt alloc] initWithData:data size:size];
                NSArray<NSString*> *arrWv =  [self.deviceInfoExt.aszWebVersion componentsSeparatedByString:@"."];
                if([arrWv count] >4){
                    NSString *strFunc = [arrWv objectAtIndex:4];
                    NSString *strBinFunc = [TwsTools toBinarySystemWithDecimalSystem:strFunc];
                    while(strBinFunc.length < 5){
                        strBinFunc = [NSString stringWithFormat:@"0%@",strBinFunc];
                    }
                    [self.baseCamera setStrFunctionFlag:strBinFunc];
                    
                }
            }
        }
            break;
        case HI_P2P_GET_NET_PARAM:{
                LOG(@"camera %@ HI_P2P_GET_DEV_INFO ",self.uid);
                needSize = sizeof(HI_P2P_S_NET_PARAM);
                if(size >= needSize){
                    self.netParam = [[NetParam alloc] initWithData:(char*)data size:(int)size];
                    if(![self.baseCamera hasSetFunctionFlag]){
                        [CameraFunction DoCameraFunctionFlag:self.baseCamera ip:self.netParam.strIPAddr netmask:self.netParam.strNetMask];
                        LOG(@"camera %@ SetFunctionFlag ",self.uid);
                    }
                }
        }
            break;
        case HI_P2P_GET_TIME_PARAM:{
            needSize = sizeof(HI_P2P_S_TIME_PARAM);
            if(size >= needSize){
                self.deviceLoginTime = [[TimeParam alloc] initWithData:data size:size];
                if(self.deviceLoginTime.u32Year <= 1970){
                    if(self.gmTimeZone || self.zkGmTimeZone){
                        self.deviceLoginTime = nil;
                        [self syncWithPhoneTime];
                    }
                }
            }
        }
            break;
        case HI_P2P_SET_TIME_PARAM:{
            [self sendIOCtrl:HI_P2P_GET_TIME_PARAM Data:(char*)nil Size:0];
        }
            break;
        case HI_P2P_SET_REBOOT:{
            if(size >= 0){
                self.processState = CAMERASTATE_WILLREBOOTING;
            }
        }
            break;
        case HI_P2P_SET_RESET:{
            if(size >= 0){
                self.processState = CAMERASTATE_WILLRESETING;
            }
        }
            break;
        case HI_P2P_SET_DOWNLOAD:{
            if(size >= 0){
                self.processState = CAMERASTATE_WILLUPGRADING;
                self.beginRebootTime = [NSDate timeIntervalSinceReferenceDate];
                self.rebootTimeout = 120;
            }
        }
            break;
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceiveIOCtrlWithType:Data:DataSize:)]) {
            [self.cameraDelegate camera:self.baseCamera _didReceiveIOCtrlWithType:type Data:data DataSize:size];
        }
    });
    switch (type) {
            break;
            //获取摄像机本地服务器地址
        case HI_P2P_ALARM_ADDRESS_GET:{
            NSLog(@"打印一下%d： %s",self.subID,data);
            NSString* DeviceIPAddress = [NSString stringWithFormat:@"%s",data];
            // 设备推送服务器地址保存到本地
            [[NSUserDefaults standardUserDefaults] setObject:DeviceIPAddress forKey:[self xingePushIPAddressKey]];
            
            //    修改报警推送服务器的前提是：
            //1.对象设备：支持获取该设备报警推送服务器地址&&也支持修改其报警推送服务器地址
            //2.APP端存储的报警推送服务器地址与设备端不同
            //3.推送开关开启以后
            //4.满足以上3点，重连或连接一次以后
            //以上4点缺一不可
            if ([self isNewAlarmPushServerIPAddress]) {//地址一样！！
                if (self.isPushOn) {//开关开启，地址又一样
                    [self.pushSDK setAlarmPushServerIPAddress:[[NSUserDefaults standardUserDefaults] objectForKey:[self xingePushIPAddressKey]]];
                    NSString* SDKAddress = [self checkAddressFromPushSDK];
                    if (SDKAddress.length > 0) {
                        [self sendPushServerIPAddress:SDKAddress];
                    }
                    [self registSubID];
                }else{//开关关闭，地址又一样
                    //                        [self turnOffXingePush];
                }
            }
            else {
                //[self unbindOldSubID];
                if (self.isPushOn) {//开关开启，地址又不一样
                    //先注销subid
                    [self unregistSubID];
                    [self.pushSDK bind];//绑定推送（为了获得subid）
                    [self.pushSDK setAlarmPushServerIPAddress:[[NSUserDefaults standardUserDefaults] objectForKey:[self xingePushIPAddressKey]]];
                    NSString* SDKAddress = [self checkAddressFromPushSDK];
                    if (SDKAddress.length > 0) {
                        [self sendPushServerIPAddress:SDKAddress];
                    }
                    NSLog(@"地址不一样，新地址发给设备：%@",[self.pushSDK getPushServer]);
                    [self registSubID];//注册一下subid
                    
                }else{//开关关闭，地址又不一样
                    //                        [self turnOffXingePush];//关闭推送
                }
                return;
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)receivePlayState:(HiCamera *)camera State:(int)state Width:(int)width Height:(int)height{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceivePlayState:witdh:height:)]) {
                [self.cameraDelegate camera:self.baseCamera _didReceivePlayState:state witdh:width height:height];
            }
        });
}
- (void)receivePlayUTC:(HiCamera *)camera Time:(int)time{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceivePlayUTC:)]) {
                [self.cameraDelegate camera:self.baseCamera _didReceivePlayUTC:time];
            }
        });
}

- (void)receiveDownloadState:(HiCamera*)camera Total:(int)total CurSize:(int)curSize State:(int)state Path:(NSString*)path{
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceiveDownloadState:Total:CurSize:Path:)]) {
            [self.cameraDelegate camera:self.baseCamera _didReceiveDownloadState:state Total:total CurSize:curSize Path:path];
        }
    });
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

/**
 *  向设备端发送推送服务器地址
 *  @param  ipaddress 推送服务器地址
 */
- (void)sendPushServerIPAddress:(NSString *)ipaddress {
    // 无此能力集无需设置
    if ([self getCommandFunction:HI_P2P_ALARM_ADDRESS_SET]) {
        HI_P2P_ALARM_ADDRESS *alarm_address = (HI_P2P_ALARM_ADDRESS *)malloc(sizeof(HI_P2P_ALARM_ADDRESS));
        if(alarm_address){
            memset(alarm_address, 0, sizeof(HI_P2P_ALARM_ADDRESS));
            strcpy(alarm_address->szAlarmAddr, ipaddress.UTF8String);
            
            [self sendIOCtrl:HI_P2P_ALARM_ADDRESS_SET Data:(char *)alarm_address Size:sizeof(HI_P2P_ALARM_ADDRESS)];
            
            free(alarm_address);
            alarm_address = nil;
            [self registSubID];//注册一下subid
        }
        NSLog(@"设置报警推送服务器地址");
    }
    else {
        NSLog(@"无报警推送服务器地址设置能力集");
    }
}


- (void)registSubID {
    
    // HI_P2P_ALARM_TOKEN_REGIST
    
    int t_subID = self.subID;
    int t_enable = (int)self.isPushOn;
    NSLog(@"regissubID %ld    开关: %ld",(long)self.subID,self.isPushOn);
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    
    HI_P2P_ALARM_TOKEN_INFO *alarm_token_info = (HI_P2P_ALARM_TOKEN_INFO *)malloc(sizeof(HI_P2P_ALARM_TOKEN_INFO));
    if(alarm_token_info){
        memset(alarm_token_info, 0, sizeof(HI_P2P_ALARM_TOKEN_INFO));
        memcpy(alarm_token_info->szTokenId, &t_subID, sizeof(int));
        
        
        alarm_token_info->u32UtcTime = time/3600;
        alarm_token_info->s8Enable = t_enable;
        
        if ([self getCommandFunction:HI_P2P_ALARM_TOKEN_REGIST]) {
            [self sendIOCtrl:HI_P2P_ALARM_TOKEN_REGIST Data:(char *)alarm_token_info Size:sizeof(HI_P2P_ALARM_TOKEN_INFO)];
        }
        
        free(alarm_token_info);
        alarm_token_info = nil;
    }
}

//本地app记录不同设备推送开关状态
- (NSString *)xingePushKey {
    return [NSString stringWithFormat:@"%@-XingePushOn", self.uid];
}
//
- (NSString *)xingePushSubIDKey {
    return [NSString stringWithFormat:@"%@-XingePushSubID", self.uid];
}

- (NSString *)xingePushIPAddressKey {
    return [NSString stringWithFormat:@"%@-%@", self.uid, AlarmPushServerIPAddressKey];
}


- (int)subID {
    return [[self.camDefaults objectForKey:self.xingePushSubIDKey] intValue];
}

- (NSUserDefaults *)camDefaults {
    if (!_camDefaults) {
        _camDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _camDefaults;
}

// 是否是新的服务器地址，不一样就更新保存到本地
- (BOOL)isNewAlarmPushServerIPAddress {
    //    [[NSUserDefaults standardUserDefaults] objectForKey:[self xingePushIPAddressKey]]
    NSString *localIPAddress = [[NSUserDefaults standardUserDefaults] objectForKey:[self xingePushIPAddressKey]];
    NSString* uidFour = [self.uid substringToIndex:4];
    NSLog(@"uidfour111 %@ 地址：%@ ",uidFour,[[NSUserDefaults standardUserDefaults] objectForKey:[self xingePushIPAddressKey]]);
    
    NSArray* arr = @[@"XXXX",@"YYYY",@"ZZZZ"];
    NSString* address ;
    if ([arr containsObject:uidFour]) {
        address = ThreeAPSAddress;
    }else{
        address = AlarmPushServerIPAddress;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:address forKey:self.xingePushIPAddressKey];
    NSLog(@"uidfour222 %@ 地址：%@ ",uidFour,[[NSUserDefaults standardUserDefaults] objectForKey:[self xingePushIPAddressKey]]);
    
    if ([localIPAddress isEqualToString:address]) {
        return YES;
    }
    
    LOG(@"新服务器地址 %@", AlarmPushServerIPAddress);
    return NO;
}


// 开启关闭信鸽报警推送代理返回
- (void)pushBindResult:(int)subID Type:(int)type Result:(int)result {
    
    NSLog(@">>>pushBindResult  subID:%d, %@, %@", subID, type == 0 ? @"bind" : @"unbind", result == 0 ? @"success" : @"failed");
    
    // 本地保存subID
    [self.camDefaults setObject:[NSNumber numberWithInt:subID] forKey:self.xingePushSubIDKey];
    if([self.username isEqualToString:LSUID]){
        if (type == PUSH_TYPE_BIND) {
//            if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceivePushResult:type:subId:)]) {
//                [self.cameraDelegate camera:self.baseCamera _didReceivePushResult:result type:type subId:subID];
//            }
            [self closePush:nil];
        }else if (type == PUSH_TYPE_UNBIND && result == 0){
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@-%@",self.uid,AlarmPushServerIPAddressKey]];//删除存储的该设备的服务器地址
        }
            return ;
    }
    
    if (type == PUSH_TYPE_BIND) {
        if (result == PUSH_RESULT_SUCCESS) {
            [self.camDefaults setObject:[NSNumber numberWithInteger:1] forKey:self.xingePushKey];
            // 打开信鸽推送成功后向服务器注册
            NSString* SDKAddress = [self checkAddressFromPushSDK];
            if (SDKAddress.length > 0) {
                [self sendPushServerIPAddress:SDKAddress];
            }
            NSLog(@"地址，新地址发给设备：%@",[self.pushSDK getPushServer]);
            
            //            // 更新本地存储服务器地址
            //            [[NSUserDefaults standardUserDefaults] setObject:AlarmPushServerIPAddress forKey:[self xingePushIPAddressKey]];
            
            [self registSubID];
        }
        
        
        if (result == PUSH_RESULT_FAIL) {
            [self.camDefaults setObject:[NSNumber numberWithInteger:0] forKey:self.xingePushKey];
        }
        
    }
    
    
    //
    if (type == PUSH_TYPE_UNBIND) {
        
        if (result == PUSH_RESULT_SUCCESS) {
            [self.camDefaults setObject:[NSNumber numberWithInteger:0 ] forKey:self.xingePushKey];
            
            // 关闭信鸽推送成功后清除报警显示状态
            [self clearRemoteNotifications];
            [self unregistSubID];
            
        }
        if (result == PUSH_RESULT_FAIL) {
            [self.camDefaults setObject:[NSNumber numberWithInteger:0] forKey:self.xingePushKey];
        }
        
    }
    
    
    // block返回
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [HXProgress dismiss];
        
        if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceivePushResult:type:subId:)]) {
            [self.cameraDelegate camera:self.baseCamera _didReceivePushResult:result type:type subId:subID];
        }
    });
    
    
    
}

- (NSInteger)isPushOn {
    return [[self.camDefaults objectForKey:self.xingePushKey] integerValue];
}

#pragma mark - OnPushResult/信鸽推送
- (HiPushSDK *)pushSDK {
    if (!_pushSDK) {
        
        //注册信鸽推送返回的deviceToken
        NSString *token     = [self.camDefaults objectForKey:@"push_deviceToken"];
        NSString *company   = [self.camDefaults objectForKey:@"xinge_push_company"];
        
        LOG(@"push_deviceToken : %@", token)
        NSLog(@"xinge_push_company : %@", company);
        LOG(@"xinge_push_uid : %@", self.uid)
        
        
        _pushSDK = [[HiPushSDK alloc] initWithXGToken:token Uid:self.uid Company:company Delegate:self];
    }
    return _pushSDK;
}

//对SDK返回的报警服务器地址进行判断
-(NSString* )checkAddressFromPushSDK{
    NSString* str = [self.pushSDK getPushServer];
    NSArray* arrStr = [str componentsSeparatedByString:@"."];
    if (arrStr.count == 4) {
        __block BOOL isCurrectNumStr = YES;
        [arrStr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* strObj = obj;
            if (![self isNum:strObj]) {
                isCurrectNumStr = NO;
                *stop = YES;
            }
        }];
        if (isCurrectNumStr) {
            return str;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

//过滤掉纯数字，剩下的为空才是正确的
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}


- (void)unregistSubID {
    
    // HI_P2P_ALARM_TOKEN_UNREGIST
    NSLog(@"unregissubID %ld    开关 : %ld",(long)self.subID,self.isPushOn);
    
    int t_subID = self.subID;
    int t_enable = (int)self.isPushOn;
    
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    
    HI_P2P_ALARM_TOKEN_INFO *alarm_token_info = (HI_P2P_ALARM_TOKEN_INFO *)malloc(sizeof(HI_P2P_ALARM_TOKEN_INFO));
    if(alarm_token_info){
        memset(alarm_token_info, 0, sizeof(HI_P2P_ALARM_TOKEN_INFO));
        
        memcpy(alarm_token_info->szTokenId, &t_subID, sizeof(int));
        
        alarm_token_info->u32UtcTime = time/3600;
        alarm_token_info->s8Enable = t_enable;
        
        if ([self getCommandFunction:HI_P2P_ALARM_TOKEN_UNREGIST]) {
            [self sendIOCtrl:HI_P2P_ALARM_TOKEN_UNREGIST Data:(char *)alarm_token_info Size:sizeof(HI_P2P_ALARM_TOKEN_INFO)];
        }
        
        free(alarm_token_info);
        alarm_token_info = nil;
    }
}

// 关闭信鸽推送
- (void)turnOffXingePush {
    //    [HXProgress showProgress];
    
    LOG(@"关闭信鸽推送")
    LOG(@"camera_subID : %@ %d", self.uid, (int)self.subID);
    
    //     区分新老接口
    if (self.subID > 0) {
        [self.pushSDK unbindWithSubID:self.subID];
        //        NSLog(@"3333333");
    }
    else {
        [self.pushSDK unbind];
        NSLog(@"4444444");
    }
    
}

- (void)syncWithPhoneTime{
    long offset = 0;
    if(self.zkGmTimeZone){
        for (int i = 0; i < [TimeZoneModel getAll].count; i++) {
            TimeZoneModel *model = [TimeZoneModel getAll][i];
            if([model.area isEqualToString:self.zkGmTimeZone.timeName]){
                offset = model.timezone * 60 * 60;
                break;
            }
        }
    }
    else if(self.gmTimeZone){
        offset = self.gmTimeZone.model->s32TimeZone * 60 *60;
    }
    
    NSDate *dates = [NSDate date];
    if((self.zkGmTimeZone && self.zkGmTimeZone.dst == 1) || (self.gmTimeZone && self.gmTimeZone.u32DstMode == 1))
    {
        NSArray *names= [NSTimeZone knownTimeZoneNames];
        for (int i = 0; i < [names count]; i++) {
            
            NSTimeZone *nsTzTmp = [NSTimeZone timeZoneWithName:[names objectAtIndex:i]];
            if([nsTzTmp isDaylightSavingTime]){
                if([nsTzTmp secondsFromGMT] - [nsTzTmp daylightSavingTimeOffsetForDate:dates] == offset){
                    offset += 60*60;
                    break;
                }
            }
        }
    }
    
    NSTimeZone *timezone = [NSTimeZone timeZoneForSecondsFromGMT:offset];
    TimeParam *timeParams = [[TimeParam alloc] init];
    NSCalendar *myCal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [myCal componentsInTimeZone:timezone fromDate:dates];
    [timeParams setU32Year:(unsigned int)dateComponents.year];
    [timeParams setU32Month:(unsigned int)dateComponents.month];
    [timeParams setU32Day:(unsigned int)dateComponents.day];
    [timeParams setU32Hour:(unsigned int)dateComponents.hour];
    [timeParams setU32Minute:(unsigned int)dateComponents.minute];
    [timeParams setU32Second:(unsigned int)dateComponents.second];
    HI_P2P_S_TIME_PARAM *p = [timeParams model];
    [self sendIOCtrl:HI_P2P_SET_TIME_PARAM Data:(char*)p Size:sizeof(HI_P2P_S_TIME_PARAM)];
    free(p);
    p = nil;
}

-(BOOL)getCommandFunction:(int)cmd{
    return [super getCommandFunction:cmd];
}
- (void) SetImgview:(UIImageView*) imgview{
    [super SetImgview:imgview];
}
-(void) RemImgview{
    [super RemImgview];
}
@end
