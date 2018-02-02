//
//  HichipCamera.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/18.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "HichipCamera.h"
#import "CameraIOSessionProtocol.h"
#import "HiPushSDK.h"

@interface HichipCamera()<CameraIOSessionProtocol,OnPushResult>{
    BOOL isStopManually;
}


@property (nonatomic, assign) int subID;
@property (nonatomic, strong) NSUserDefaults *camDefaults;
@property (nonatomic, strong) HiPushSDK *pushSDK;
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
    return 0;
}

-(BOOL)isSessionConnected{
    return self.getConnectState == CAMERA_CONNECTION_STATE_CONNECTED || self.isAuthConnected;
}

-(BOOL)isAuthConnected{
    return self.getConnectState == CAMERA_CONNECTION_STATE_LOGIN;
}

-(BOOL)isConnecting{
    return self.getConnectState == CAMERA_CONNECTION_STATE_CONNECTING || [self isSessionConnected];
}
-(BOOL)isSessionConnecting{
    return self.getConnectState == CAMERA_CONNECTION_STATE_CONNECTING;
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
    [super startLiveShow:(int)self.videoQuality == 1?1:0 Monitor:nil];
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
    if(self.isAuthConnected){
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didChangeChannelStatus:ChannelStatus:)]) {
                [self.cameraDelegate camera:self.baseCamera _didChangeChannelStatus:0 ChannelStatus:status];
            }
        });
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didChangeSessionStatus:)]) {
                [self.cameraDelegate camera:self.baseCamera _didChangeSessionStatus:status];
            }
        });
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
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceiveIOCtrlWithType:Data:DataSize:)]) {
            [self.cameraDelegate camera:self.baseCamera _didReceiveIOCtrlWithType:type Data:data DataSize:size];
        }
    });
    switch (type) {
        case HI_P2P_GET_TIME_PARAM:
            
            break;
        case HI_P2P_GET_TIME_ZONE:{
        
        }
            break;
            //获取时区（新命令）
        case HI_P2P_GET_TIME_ZONE_EXT:{
        
        }
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
    if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceivePlayState:witdh:height:)]) {
        [self.cameraDelegate camera:self.baseCamera _didReceivePlayState:state witdh:width height:height];
    }
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
            if (self.cameraDelegate && [self.cameraDelegate respondsToSelector:@selector(camera:_didReceivePushResult:type:subId:)]) {
                [self.cameraDelegate camera:self.baseCamera _didReceivePushResult:result type:type subId:subID];
            }
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
        NSString *token     = [self.camDefaults objectForKey:@"xinge_push_deviceToken"];
        NSString *company   = [self.camDefaults objectForKey:@"xinge_push_company"];
        
        LOG(@"xinge_push_deviceToken : %@", token)
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



@end
