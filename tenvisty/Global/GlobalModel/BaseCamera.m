//
//  IMyCamera.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/18.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "BaseCamera.h"
#import "MyCamera.h"
#import "HichipCamera.h"

@interface BaseCamera(){
    NSArray *functionFlag;
    NSArray *defaultFunctionFlag;
}
@property (nonatomic, strong) id<BaseCameraProtocol> orginCamera;
@property (nonatomic, assign) NSInteger p2pType;
@property (nonatomic,assign) CGFloat vRatio;
//@property (nonatomic, strong) NSString* cameraStateDesc;
@end

@implementation BaseCamera

- (void)setCameraDelegate:(id<BaseCameraDelegate>)cameraDelegate{
    self.orginCamera.cameraDelegate = cameraDelegate;
}

- (id)initWithUid:(NSString *)uid Name:(NSString*)name UserName:(NSString *)viewAcc_ Password:(NSString *)viewPwd_{
    self = [self init];
    
    defaultFunctionFlag = DEFAULT_CAMERA_FUNCTION;// [NSArray arrayWithObjects:@"1",@"1",@"0",@"0",@"1", nil];
    //tutk p2p
    if(uid.length == 20){
        self.p2pType = P2P_Tutk;
        MyCamera *camera = [[MyCamera alloc] initWithUid:uid Name:name UserName:viewAcc_ Password:viewPwd_];
        camera.baseCamera = self;
        self.orginCamera = camera;
    }
    //hichip p2p
    else if(uid.length == 17){
        self.p2pType = P2P_Hichip;
        HichipCamera *camera = [[HichipCamera alloc] initWithUid:uid Name:name UserName:viewAcc_ Password:viewPwd_];
        camera.baseCamera = self;
        self.orginCamera = camera;
    }
    return self;
}

@synthesize cameraDelegate;
@synthesize uid;
@synthesize pwd;
@synthesize user;
@synthesize remoteNotifications;
@synthesize nickName;
@synthesize isPlaying;
@synthesize videoQuality;
@synthesize videoRatio;
@synthesize cameraConnectState;
@synthesize cameraStateDesc;
@synthesize p2pType;
@synthesize processState;
@synthesize upgradePercent;
@synthesize isSessionConnected;
@synthesize isAuthConnected;
@synthesize isConnecting;
@synthesize isDisconnect;
@synthesize isWrongPassword;

- (id<BaseCameraDelegate>)cameraDelegate{
    return self.orginCamera.cameraDelegate;
}

-(NSString*)uid{
    return self.orginCamera.uid;
}

-(void)setUid:(NSString *)uid{
    self.orginCamera.uid = uid;
}

-(NSString*)pwd{
    return self.orginCamera.pwd;
}

-(void)setPwd:(NSString *)pwd{
    self.orginCamera.pwd = pwd;
}

-(NSString*)user{
    return self.orginCamera.user;
}

-(void)setUser:(NSString *)user{
    self.user = user;
}

-(NSInteger)remoteNotifications{
    return self.orginCamera.remoteNotifications;
}

-(void)setRemoteNotifications:(NSInteger)remoteNotifications{
    self.orginCamera.remoteNotifications = remoteNotifications;
}

-(NSString*)nickName{
    return self.orginCamera.nickName;
}

-(void)setNickName:(NSString *)nickName{
    self.orginCamera.nickName = nickName;
}

-(BOOL)isPlaying{
    return self.orginCamera.isPlaying;
}

-(void)setIsPlaying:(BOOL)isPlaying{
    self.orginCamera.isPlaying = isPlaying;
}


-(NSInteger)videoQuality{
    return self.orginCamera.videoQuality;
}

-(void)setVideoQuality:(NSInteger)videoQuality{
    self.orginCamera.videoQuality = videoQuality;
}

-(CGFloat)videoRatio{
    if(!_vRatio){
        _vRatio = [GBase getCameraVideoRatio:self];
    }
    return _vRatio;
}

-(void)setVideoRatio:(CGFloat)videoRatio{
    _vRatio = videoRatio;
    [GBase setCameraVideoRatio:self ratio:videoRatio];
}

-(NSInteger)cameraConnectState{
    return self.orginCamera.cameraConnectState;
}


-(NSString*)cameraStateDesc{
    return self.orginCamera.cameraStateDesc;
}


-(NSInteger)processState{
    return self.orginCamera.processState;
}

-(void)setProcessState:(NSInteger)processState{
    self.processState = processState;
}

-(NSInteger)upgradePercent{
    return self.orginCamera.upgradePercent;
}
-(void)setUpgradePercent:(NSInteger)upgradePercent{
    self.orginCamera.upgradePercent = upgradePercent;
}

-(BOOL)isSessionConnected{
    return self.orginCamera.isSessionConnected;
}

-(BOOL)isAuthConnected{
    return self.orginCamera.isAuthConnected;
}

-(BOOL)isConnecting{
    return self.orginCamera.isConnecting;
}

-(BOOL)isDisconnect{
    return self.orginCamera.isDisconnect;
}

-(BOOL)isWrongPassword{
    return self.orginCamera.isWrongPassword;
}

- (void)PTZ:(unsigned char)ctrl {
    [self.orginCamera PTZ:ctrl];
}

- (void)clearRemoteNotifications {
    if(self.remoteNotifications > 0){
        self.remoteNotifications = 1;
    }
    else{
        self.remoteNotifications = 0;
    }
    [GBase editCamera:(BaseCamera*)self];
    //[self.orginCamera clearRemoteNotifications];
}

- (void)start {
    [self.orginCamera start];
}

-(void)connect{
    [self.orginCamera connect];
}
- (void)startAudio {
    [self.orginCamera startAudio];
}

- (void)startSpeak {
    [self.orginCamera startSpeak];
}

- (void)startVideo {
    [self.orginCamera startVideo];
}

- (void)stop {
    [self.orginCamera stop];
}

- (void)stopAudio {
    [self.orginCamera stopAudio];
}

- (void)stopSpeak {
    [self.orginCamera stopSpeak];
}

- (void)stopVideo {
    [self.orginCamera stopVideo];
}

- (void)sendIOCtrlToChannel:(NSInteger)channel Type:(NSInteger)type Data:(char *)buff DataSize:(NSInteger)size {
    [self.orginCamera sendIOCtrlToChannel:channel Type:type Data:buff DataSize:size];
}

- (void)stopVideoAsync:(void (^)(void))block {
    [self.orginCamera stopVideoAsync:block];
}

- (void)saveImage:(UIImage *)image {
    if(image){
        NSString *extension = [[[self.imagePath componentsSeparatedByString:@"."] lastObject] lowercaseString];
        if([extension isEqualToString:@"png"]){
            [UIImagePNGRepresentation(image) writeToFile:self.imagePath atomically:YES];
        }
        else{
            [UIImageJPEGRepresentation(image, 0.5) writeToFile:self.imagePath atomically:YES];
        }
    }
}


- (void)startRecordVideo:(NSString *)filePath {
    [self.orginCamera startRecordVideo:filePath];
}


- (BOOL)stopRecordVideo {
    return [self.orginCamera stopRecordVideo];
}
//保存图片沙盒路径
- (NSString *)remoteRecordImagePath:(NSInteger)recordId type:(NSInteger)tp{
    NSString *fileName = [self remoteRecordThumbName:recordId type:tp];
    NSString *filePath = [[self documents] stringByAppendingPathComponent:fileName];
    return filePath;
}
- (UIImage *)remoteRecordImage:(NSInteger)time type:(NSInteger)tp{
    if ([self fileExistsAtPath:[self remoteRecordImagePath:time type:tp]]) {
        return [UIImage imageWithContentsOfFile:[self remoteRecordImagePath:time type:tp]];
    }
    else {
        return nil;
    }
}
- (NSString *)remoteRecordThumbName:(NSInteger)recordId type:(NSInteger)tp{
    NSString *fileName = [NSString stringWithFormat:@"%@_%d_%ld.jpg", self.uid,(int)tp,(long)recordId];
    return fileName;
}
- (NSString *)remoteRecordName:(NSInteger)recordId type:(NSInteger)tp{
    NSString *fileName = [NSString stringWithFormat:@"%@_%d_%ld.mp4", self.uid,(int)tp,(long)recordId];
    return fileName;
}

- (NSString *)remoteRecordDir{
    NSString *document_uid = [self.documents stringByAppendingPathComponent: self.uid];
    [self.gFileManager createDirectoryAtPath:document_uid withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *document_uid_download = [document_uid stringByAppendingString:@"/Download"];
    [self.gFileManager createDirectoryAtPath:document_uid_download withIntermediateDirectories:YES attributes:nil error:nil];
    
    return document_uid_download;
}
#pragma mark - NSFileManager
- (NSFileManager *)gFileManager {
    return [NSFileManager defaultManager];
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

-(void)openPush:(void (^)(NSInteger code))successlock{
    [self.orginCamera openPush:successlock];
}

-(void)closePush:(void (^)(NSInteger code))successlock{
    [self.orginCamera closePush:successlock];
}

- (void)setRemoteNotification:(NSInteger)type EventTime:(long)time{
    [self.orginCamera setRemoteNotification:type EventTime:time];
}


//保存图片沙盒路径
- (NSString *)imagePath {
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", self.uid];
    NSString *filePath = [[self documents] stringByAppendingPathComponent:fileName];
    return filePath;
}

//Documents
- (NSString *)documents {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
//判断一个文件是否存在
- (BOOL)fileExistsAtPath:(NSString *)filePath {
    NSFileManager *tFileManager = [NSFileManager defaultManager];
    return [tFileManager fileExistsAtPath:filePath];
}
- (void)syncWithPhoneTime{
    [self.orginCamera syncWithPhoneTime];
}
-(BOOL)getCommandFunction:(int)cmd{
    return [self.orginCamera getCommandFunction:cmd];
}

//begin 添加摄像机功能标识位，yilu20170316
- (NSArray *)getFunctionFlag{
    if(functionFlag == nil || [functionFlag count] == 0){
        return defaultFunctionFlag;
    }
    return functionFlag;
}
- (void)setFunctionFlag:(NSArray *)funcFlag{
    functionFlag = funcFlag;
}
- (void)setStrFunctionFlag:(NSString *)strFuncFlag{
    if(strFuncFlag != nil && strFuncFlag.length > 0){
        NSMutableArray *arrFuc = [[NSMutableArray alloc] initWithCapacity:strFuncFlag.length];
        for(int i = 0; i < strFuncFlag.length; i++){
            [arrFuc setObject:[NSString stringWithFormat:@"%c",[strFuncFlag characterAtIndex:i]] atIndexedSubscript:i];
        }
        functionFlag = [arrFuc copy];
    }
}
- (BOOL)hasSetFunctionFlag{
    return functionFlag != nil && [functionFlag count] > 0;
}
- (BOOL)hasPTZ{
    return [((NSString *)[[self getFunctionFlag] objectAtIndex:0]) isEqual:@"1"];
}
- (BOOL)hasListen{
    return [((NSString *)[[self getFunctionFlag] objectAtIndex:1]) isEqual:@"1"];
}
- (BOOL)hasPreset{
    return [((NSString *)[[self getFunctionFlag] objectAtIndex:2]) isEqual:@"1"];
}
- (BOOL)hasZoom{
    return [((NSString *)[[self getFunctionFlag] objectAtIndex:3]) isEqual:@"1"];
}
- (BOOL)hasSDSlot{
    return [((NSString *)[[self getFunctionFlag] objectAtIndex:4]) isEqual:@"1"];
}
- (void) SetImgview:(UIImageView*) imgview{
    [self.orginCamera SetImgview:imgview];
}
-(void) RemImgview{
    [self.orginCamera RemImgview];
}
@end
