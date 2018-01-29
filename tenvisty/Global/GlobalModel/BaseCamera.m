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

@interface BaseCamera()
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
    [self.orginCamera clearRemoteNotifications];
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

- (UIImage *)remoteRecordImage:(NSInteger)time type:(NSInteger)tp{
    return [self.orginCamera remoteRecordImage:time type:tp];
}
- (NSString *)remoteRecordThumbName:(NSInteger)recordId type:(NSInteger)tp{
    return [self.orginCamera remoteRecordThumbName:recordId type:tp];
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

@end
