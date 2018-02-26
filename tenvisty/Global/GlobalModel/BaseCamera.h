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

typedef enum
{
    TwsDirectionNone = 0,
    TwsDirectionTiltUp = 1,
    TwsDirectionTiltDown = 2,
    TwsDirectionPanLeft = 3,
    TwsDirectionPanRight = 4,
} TwsCameraDirection;
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
@property (nonatomic,assign) NSInteger cameraConnectState;
@property(nonatomic,strong,readonly) NSString *cameraStateDesc;
@property(nonatomic,assign,readonly) NSInteger p2pType;
@property (nonatomic,assign) NSInteger processState;
@property (nonatomic,assign) NSInteger upgradePercent;
@property(nonatomic,assign,readonly) BOOL isSessionConnected;
@property(nonatomic,assign,readonly) BOOL isAuthConnected;
@property(nonatomic,assign,readonly) BOOL isConnecting;
@property(nonatomic,assign,readonly) BOOL isDisconnect;
@property(nonatomic,assign,readonly) BOOL isWrongPassword;
@property(nonatomic,assign) BOOL isSessionConnecting;
- (id)initWithUid:(NSString *)uid Name:(NSString*)name UserName:(NSString *)viewAcc_ Password:(NSString *)viewPwd_;
-(id)init;
-(void)connect;
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
- (void)syncWithPhoneTime;
-(BOOL)getCommandFunction:(int)cmd;
//begin 添加摄像机功能标识位，yilu20170316
- (void)setFunctionFlag:(NSArray *)functionFlag;
- (void)setStrFunctionFlag:(NSString *)strFuncFlag;
- (BOOL)hasSetFunctionFlag;
- (BOOL)hasPTZ;
- (BOOL)hasListen;
- (BOOL)hasPreset;
- (BOOL)hasZoom;
- (BOOL)hasSDSlot;
- (void) SetImgview:(UIImageView*) imgview;
-(void) RemImgview;
- (NSString *)remoteRecordName:(NSInteger)recordId type:(NSInteger)tp;
- (NSString *)remoteRecordDir;
- (UIImage *)thumbImage:(NSString*)defaultImg;

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
- (void)camera:(BaseCamera *)camera _didReceivePushResult:(NSInteger)result type:(NSInteger)type subId:(NSInteger)subId;
- (void)camera:(BaseCamera *)camera _didReceivePlayState:(NSInteger)state witdh:(NSInteger)w height:(NSInteger)h;
- (void)camera:(BaseCamera *)camera _didReceivePlayUTC:(NSInteger)time;
- (void)camera:(BaseCamera *)camera _didReceiveDownloadState:(int)state Total:(int)total CurSize:(int)curSize Path:(NSString*)path;


@end

