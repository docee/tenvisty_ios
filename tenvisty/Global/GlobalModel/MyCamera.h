//
//  MyCamera.h
//  IOTCamViewer
//
//  Created by Cloud Hsiao on 12/7/2.
//  Copyright (c) 2012年 TUTK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOTCamera/Camera.h>
#import <IOTCamera/NSCamera.h>
#import <IOTCamera/AVIOCTRLDEFs.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MyCamera : Camera
<CameraDelegate>
{
    
    NSInteger lastChannel;
    NSInteger remoteNotifications;
    NSMutableArray *arrayStreamChannel;
    NSString *viewAcc;
    NSString *viewPwd;
    
    NSTimer *ptz_timer;
}


@property NSInteger lastChannel;
@property (nonatomic,assign) NSInteger videoQuality;
@property (nonatomic,strong) NSString* nickName;
@property (nonatomic,assign) NSInteger eventNotification;

//  ---- 传感器 ---- //

/*********************      **************************************/
/* ªÒ»°Œ¬ ™∂»µƒ÷µ*/

#define      IOTYPE_USEREX_IPCAM_GET_HUMITURE_REQ             (0x6001)
#define      IOTYPE_USEREX_IPCAM_GET_HUMITURE_RESP            (0x6002)

/* ªÒ»°Œ¬ ™∂»µƒ∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_GET_HUMITURE_ALARM_REQ       (0x6003)
#define      IOTYPE_USEREX_IPCAM_GET_HUMITURE_ALARM_RESP      (0x6004)

/* …Ë÷√Œ¬ ™∂»µƒ∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_SET_HUMITURE_ALARM_REQ       (0x6005)
#define      IOTYPE_USEREX_IPCAM_SET_HUMITURE_ALARM_RESP      (0x6006)


/* ªÒ»° ±º‰∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_GET_TIME_ALARM_REQ           (0x6007)
#define      IOTYPE_USEREX_IPCAM_GET_TIME_ALARM_RESP          (0x6008)

/* …Ë÷√ ±º‰∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_SET_TIME_ALARM_REQ           (0x6009)
#define      IOTYPE_USEREX_IPCAM_SET_TIME_ALARM_RESP          (0x600A)

/* ªÒ»°PUSH∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_SET_PUSH_ALARM_REQ           (0x600B)
#define      IOTYPE_USEREX_IPCAM_SET_PUSH_ALARM_RESP          (0x600C)



/*********************   æﬂÃÂÀµ√˜   **************************************/
- (id)initWithUid:(NSString *)uid Name:(NSString*)name UserName:(NSString *)viewAcc_ Password:(NSString *)viewPwd_;
- (id)initWithName:(NSString *)name viewAccount:(NSString *)viewAcc viewPassword:(NSString *)viewPwd;
-(void)start;
- (void)start:(NSInteger)channel;
- (void)setRemoteNotification:(NSInteger)type EventTime:(long)time;
- (void)clearRemoteNotifications;
- (NSArray *)getSupportedStreams;
- (BOOL)getAudioInSupportOfChannel:(NSInteger)channel;
- (BOOL)getAudioOutSupportOfChannel:(NSInteger)channel;
- (BOOL)getPanTiltSupportOfChannel:(NSInteger)channel;
- (BOOL)getPlaybackSupportOfChannel:(NSInteger)channel;
- (BOOL)getWiFiSettingSupportOfChannel:(NSInteger)channel;
- (BOOL)getMotionDetectionSettingSupportOfChannel:(NSInteger)channel;
- (BOOL)getRecordSettingSupportOfChannel:(NSInteger)channel;
- (BOOL)getFormatSDCardSupportOfChannel:(NSInteger)channel;
- (BOOL)getVideoFlipSupportOfChannel:(NSInteger)channel;
- (BOOL)getEnvironmentModeSupportOfChannel:(NSInteger)channel;
- (BOOL)getMultiStreamSupportOfChannel:(NSInteger)channel;
- (NSInteger)getAudioOutFormatOfChannel:(NSInteger)channel;
- (BOOL)getVideoQualitySettingSupportOfChannel:(NSInteger)channel;
- (BOOL)getDeviceInfoSupportOfChannel:(NSInteger)channel;
-(NSString *)getCameraStatus;

@property (nonatomic,assign) NSInteger connectState;

- (void)saveImage:(UIImage *)image;
- (UIImage *)image;

-(void)openPush;
-(void)closePush;
-(BOOL)isDisconnected;
-(NSString*)strConnectState;
- (NSInteger)direction:(CGPoint)translation;
@end

