//
//  IMyCamera.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/18.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "BaseCamera.h"
#import "MyCamera.h"
#import "HiCamera.h"

@interface BaseCamera()
@property (nonatomic, assign) id<BaseCameraProtocol> orginCamera;
@property (nonatomic, assign) NSInteger p2pType;
@end

@implementation BaseCamera

- (void)setCameraDelegate:(id<BaseCameraDelegate>)cameraDelegate{
    _orginCamera.cameraDelegate = cameraDelegate;
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
    }
    return self;
}

@synthesize cameraDelegate;
@synthesize uid;
@synthesize remoteNotifications;
@synthesize nickName;
@synthesize isPlaying;
@synthesize videoQuality;
@synthesize videoRatio;
@synthesize connectState;
@synthesize cameraStateDesc;
@synthesize pwd;
@synthesize p2pType;
@synthesize processState;
@synthesize upgradePercent;

-(NSString*)getCameraStateDesc{
    return LOCALSTR(@"Online");
}


- (void)PTZ:(unsigned char)ctrl {
    
}

- (void)clearRemoteNotifications {
    
}

- (void)start {
    
}

- (void)startAudio {
    
}

- (void)startSpeak {
    
}

- (void)startVideo {
    
}

- (void)stop {
    
}

- (void)stopAudio {
    
}

- (void)stopSpeak {
    
}

- (void)stopVideo {
    
}

- (void)sendIOCtrlToChannel:(NSInteger)channel Type:(NSInteger)type Data:(char *)buff DataSize:(NSInteger)size {
    
}

- (void)stopVideoAsync:(void (^)(void))block {
    
}

- (void)saveImage:(UIImage *)image {
    
}


- (void)startRecordVideo:(NSString *)filePath {
    
}


- (BOOL)stopRecordVideo {
    return YES;
}

- (UIImage *)remoteRecordImage:(NSInteger)time type:(NSInteger)tp{
    return nil;
}
- (NSString *)remoteRecordThumbName:(NSInteger)recordId type:(NSInteger)tp{
    return @"";
}


- (UIImage *)image{
    return nil;
}

-(void)openPush:(void (^)(NSInteger code))successlock{
    
}

-(void)closePush:(void (^)(NSInteger code))successlock{
    
}

- (void)setRemoteNotification:(NSInteger)type EventTime:(long)time{
    
}




@synthesize user;

@end
