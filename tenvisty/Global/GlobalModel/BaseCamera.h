//
//  IMyCamera.h
//  tenvisty
//
//  Created by Tenvis on 2018/1/18.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#define P2P_Tutk 0
#define P2P_Hichip 1

#define CAMERASTATE_NONE 0
#define CAMERASTATE_WILLREBOOTING 1
#define CAMERASTATE_REBOOTING 2
#define CAMERASTATE_WILLRESETING 3
#define CAMERASTATE_RESETING 4
#define CAMERASTATE_WILLUPGRADING 5
#define CAMERASTATE_UPGRADING 6

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@protocol BaseCameraDelegate;


@protocol BaseCameraProtocol <NSObject>
@property (nonatomic, assign) id<BaseCameraDelegate> cameraDelegate;
@property (nonatomic,assign) NSInteger remoteNotifications;
@property (nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *pwd;
@property(nonatomic,strong) NSString *user;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) NSInteger videoQuality;
@property (nonatomic,assign) CGFloat videoRatio;
@property (nonatomic,assign) NSInteger connectState;
@property(nonatomic,strong,readonly) NSString *cameraStateDesc;
@property(nonatomic,assign,readonly) NSInteger p2pType;
@property (nonatomic,assign) NSInteger processState;
@property (nonatomic,assign) NSInteger upgradePercent;

- (id)initWithUid:(NSString *)uid Name:(NSString*)name UserName:(NSString *)viewAcc_ Password:(NSString *)viewPwd_;
-(id)init;
-(void)start;
-(void)stop;
-(void)startVideo;
-(void)stopVideo;
-(void)startAudio;
-(void)stopAudio;
-(void)startSpeak;
-(void)stopSpeak;
-(void)PTZ:(unsigned char)ctrl;
- (void)clearRemoteNotifications;
- (void)sendIOCtrlToChannel:(NSInteger)channel Type:(NSInteger)type Data:(char *)buff DataSize:(NSInteger)size;
-(void)stopVideoAsync:(void (^)(void))block;
- (void)saveImage:(UIImage *)image;
-(void)startRecordVideo:(NSString *)filePath;
-(BOOL)stopRecordVideo;
- (UIImage *)remoteRecordImage:(NSInteger)time type:(NSInteger)tp;
- (NSString *)remoteRecordThumbName:(NSInteger)recordId type:(NSInteger)tp;
- (UIImage *)image;
-(void)openPush:(void (^)(NSInteger code))successlock;
-(void)closePush:(void (^)(NSInteger code))successlock;
- (void)setRemoteNotification:(NSInteger)type EventTime:(long)time;


@end
@interface BaseCamera : NSObject<BaseCameraProtocol>
@property (nonatomic, strong,readonly) id<BaseCameraProtocol> orginCamera;

@end


@protocol BaseCameraDelegate <NSObject>
@optional
- (void)camera:(BaseCamera *)camera _didReceiveRemoteNotification:(NSInteger)eventType EventTime:(long)eventTime;
- (void)camera:(BaseCamera *)camera _didReceiveRawDataFrame:(const char *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height;
- (void)camera:(BaseCamera *)camera _didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size;
- (void)camera:(BaseCamera *)camera _didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount;
- (void)camera:(BaseCamera *)camera _didChangeSessionStatus:(NSInteger)status;
- (void)camera:(BaseCamera *)camera _didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status;
- (void)camera:(BaseCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size;
@end

