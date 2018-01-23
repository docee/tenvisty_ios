//
//  NSCamera.h
//  IOTCamera
//
//  Created by liuchan_xin on 13-10-12.
//
//
/* used for display status */
#define CONNECTION_STATE_NONE 0
#define CONNECTION_STATE_CONNECTING 1
#define CONNECTION_STATE_CONNECTED 2
#define CONNECTION_STATE_DISCONNECTED 3
#define CONNECTION_STATE_UNKNOWN_DEVICE 4
#define CONNECTION_STATE_WRONG_PASSWORD 5
#define CONNECTION_STATE_TIMEOUT 6
#define CONNECTION_STATE_UNSUPPORTED 7
#define CONNECTION_STATE_CONNECT_FAILED 8
#define CONNECTION_STATE_NETWORK_FAILED 9
#define CONNECTION_STATE_CONNECTED_SESSION 10

#import <Foundation/Foundation.h>
#import "CameraProtocol.h"
#import <UIKit/UIKit.h>

typedef enum{
    CAMERA_MODEL_H264 = 0,
    CAMERA_MODEL_MJPEG = 1,
}CameraModel;

typedef enum{
    Resolution_MODEL_SPEED = 0,
    Resolution_MODEL_HD = 1,
    Resolution_MODEL_UHD = 2,
}ResolutionModel;

@protocol CameraDelegate,MyCameraDelegate,myCameraProtocol,CameraProtocol;

@interface NSCamera : NSObject <CameraProtocol>

@property (nonatomic,assign)CameraModel cameraModel;

@property (nonatomic, retain)	NSString * uid;
@property (nonatomic, retain)	NSString * name;
@property (nonatomic, retain)	NSString * host;
@property (nonatomic, retain)	NSString * port;
@property (nonatomic, retain)	NSString * LANHost;
@property (nonatomic, retain)	NSString * LANPort;
@property (nonatomic, retain)	NSString * user;
@property (nonatomic, retain)	NSString * pwd;
@property (nonatomic, retain)	NSString * ddns;
@property (nonatomic, retain)	NSString * shareFrom;

@property (nonatomic,  retain) NSString * cameramodelADD;

@property (readwrite) NSInteger sessionState;
@property (readwrite) NSInteger sdTotal;
@property(readwrite) NSInteger remoteNotifications;

@property (nonatomic, assign) id<CameraDelegate> delegateForMonitor;
@property (nonatomic, retain) id<MyCameraDelegate> delegate2;
@property (nonatomic, retain)NSMutableString *databaseId;

@property (nonatomic) int   nStatus;


//+(void)LanSearch;
//-(id)init;
//-(void)start;
//-(void)stop;
//-(void)startVideo;
//-(void)stopVideo;
//-(void)startAudio;
//-(void)stopAudio;
//-(void)startSpeak;
//-(void)stopSpeak;
-(void)startRecordVideo:(NSString *)filePath;
-(BOOL)stopRecordVideo;
//-(void)setResolutionModel:(ResolutionModel )resolutionModel;
//-(void)PTZ:(unsigned char)ctrl;
//
//- (BOOL)getEventListSupportOfChannel:(NSInteger)channel;

@end

@protocol CameraDelegate <NSObject>
@optional
- (void)camera:(NSCamera *)camera didReceiveJPEG:(UIImage *)image;
- (void)camera:(NSCamera *)camera didReceiveRawDataFrame:( NSData *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height;
- (void)camera:(NSCamera *)camera didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size;
- (void)camera:(NSCamera *)camera didReceiveJPEGDataFrame2:(NSData *)imgData;
- (void)camera:(NSCamera *)camera didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount;
- (void)camera:(NSCamera *)camera didChangeSessionStatus:(NSInteger)status;
- (void)camera:(NSCamera *)camera didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status;
- (void)camera:(NSCamera *)camera didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size;

@end


@protocol MyCameraDelegate <NSObject>
@optional
- (void)camera:(NSCamera *)camera _didReceiveRemoteNotification:(NSInteger)eventType EventTime:(long)eventTime;
- (void)camera:(NSCamera *)camera _didReceiveRawDataFrame:(const char *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height;
- (void)camera:(NSCamera *)camera _didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size;
- (void)camera:(NSCamera *)camera _didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount;
- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status;
- (void)camera:(NSCamera *)camera _didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status;
- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size;
@end
