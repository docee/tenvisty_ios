//
//  IMyCamera.h
//  tenvisty
//
//  Created by Tenvis on 2018/1/18.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMyCamera : NSObject

@end

@protocol BaseCameraDelegate <NSObject>
@optional
- (void)camera:(IMyCamera *)camera _didReceiveRemoteNotification:(NSInteger)eventType EventTime:(long)eventTime;
- (void)camera:(IMyCamera *)camera _didReceiveRawDataFrame:(const char *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height;
- (void)camera:(IMyCamera *)camera _didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size;
- (void)camera:(IMyCamera *)camera _didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount;
- (void)camera:(IMyCamera *)camera _didChangeSessionStatus:(NSInteger)status;
- (void)camera:(IMyCamera *)camera _didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status;
- (void)camera:(IMyCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size;
@end


@protocol BaseCameraProtocol <NSObject>

+(void)LanSearch;
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


@end
