//
//  HiCamera.h
//  HiP2PSDK
//
//  Created by zhao qi on 16/6/16.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hi_p2p_ipc_protocol.h"
#import "HiGLMonitor.h"

#define CHIP_VERSION_GOKE 1
#define CHIP_VERSION_HISI 0


#define CAMERA_CONNECTION_STATE_DISCONNECTED  0
#define CAMERA_CONNECTION_STATE_CONNECTING  1
#define CAMERA_CONNECTION_STATE_CONNECTED  2
#define CAMERA_CONNECTION_STATE_WRONG_PASSWORD  3
#define CAMERA_CONNECTION_STATE_LOGIN  4
#define CAMERA_CONNECTION_STATE_UIDERROR  -8
//20170629新增：
#define CAMERA_CHANNEL_STREAM_ERROR  5//流错误
#define CAMERA_CHANNEL_CMD_ERROR  6


@interface HiCamera : NSObject
{
    NSString *uid;
    NSString *username;
    NSString *password;
    
    HiGLMonitor* monitor;
}

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, retain) HiGLMonitor *monitor;

- (void)setQos:(BOOL)isqos; // 支持流控
- (BOOL)getP2PAlarm;
- (void)setP2PAlarm:(BOOL)b;

//20170717新增：
-(void)SetImgviewFrame:(CGRect)frame;
//20170714 新增：
- (NSMutableDictionary *)GetAllTimeZoneDictionary;//获取时区

- (id)initWithUid:(NSString*)uid_ Username:(NSString *)username_ Password:(NSString *)password_;

/*add bruce 20170622**these two functions must be used in concert and cannot use disconnect*/
- (void)disconnect_session;
- (void)delete_camera;
/***end*/
- (void)connect;
- (void)disconnect;

- (void) SetCallBackYUV:(BOOL)Flag;

- (void) startLiveSetImgview:(UIImageView*) imgview;
- (void) SetImgview:(UIImageView*) imgview;
-(void) RemImgview;
- (void) startLiveSetImgview:(UIImageView*) imgview;
- (void) startLiveShow:(int)quality Monitor:(HiGLMonitor*)monitor;

- (void) stopLiveShow;
- (void) setLiveShowMonitor:(HiGLMonitor*)monitor;

//engel 20170313
- (void) ResumeLiveShow;
- (void) PauseLiveShow;

- (UIImage*) getSnapshot;


- (void) startListening;
- (void) stopListening;


- (void) startTalk;
- (void) stopTalk;

-(void) PausePlayAudio;
-(void) ResumePlayAudio;




- (BOOL) getCommandFunction:(int)cmd;
- (int) getChipVersion;
- (HI_P2P_S_DEV_INFO_EXT*)getDeviceInfo;



- (void) startPlayback:(STimeDay*)startTiem Monitor:(HiGLMonitor*)monitor;
- (void) startPlayback2:(STimeDay)startTiem Monitor:(HiGLMonitor*)monitor;
- (void) stopPlayback;
- (void) setPlaybackMonitor:(HiGLMonitor*)monitor;


- (void)startRecording:(NSString*)path;
- (void)stopRecording;


- (void)sendIOCtrl:(int)type Data:(char*)data Size:(int)size;


-(void) registerIOSessionDelegate:(id)delegate;
-(void) unregisterIOSessionDelegate:(id)delegate;


-(int) getConnectState;
-(void) setReconnectTimes:(int) times;

- (void) startDownloadRecording:(STimeDay*)startTiem Dir:(NSString*)dir File:(NSString*)file ;
- (void) startDownloadRecording2:(STimeDay)startTiem Dir:(NSString*)dir File:(NSString*)file ;

//20170821新增:
- (void) startDownloadRecording3:(STimeDay)startTiem Dir:(NSString*)dir File:(NSString*)file LocalType:(int) filetype;
- (void) stopDownloadRecording;

-(int) getThreadState;

//20171101新增：获取设备model，0为非鱼眼机，1为鱼眼机
-(int)getmold;


/*
 ipaddr   ip 地址
 ipport   端口
 version  版本
 s32Timeout   秒、s  小于10s  默认10s   建议设置15-20s
 */
-(void*)getRedirectUrl_EXT:(char*)ipaddr PORT:(int)ipport VERSION:(char*)version  TIMEOUT:(int)s32Timeout;
-(void*)getRedirectUrl:(char*)ipaddr PORT:(int)ipport VERSION:(char*)version;


//20170918  add  for fisheye
- (void) SetFishImgview:(UIImageView*) imgview MODE: (int)mode SCREEN_NUM: (int)No ;
-(void) CameraSetFishCruise:(BOOL)bEnable SPEED:(int) speed;
-(void) CameraSetFishZoomOut;
-(void) CameraSetFishZoomIn;
-(void) CameraSetFishGesture:(int) direction SCREEN_NUM:(int) No;
-(void) CameraSetFishDoubleClicked:(BOOL)bYes SCREEN_NUM:(int) No;
-(void) CameraSetFishShowMode:(int)mode_type SCREEN_NUM:(int) No;
-(float) CameraGetFishLager;

@end
