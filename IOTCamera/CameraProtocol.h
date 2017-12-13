//
//  CameraProtocol.h
//  IOTCamera
//
//  Created by liuchan_xin on 13-9-30.
//
//

#define CAMERA_SEARCH_RESULT_NOTIFICATION @"CAMERA_SEARCH_RESULT_NOTIFICATION"
#define CAMERA_SEARCH_END_NOTIFICATION @"CAMERA_SEARCH_END_NOTIFICATION"

#import <Foundation/Foundation.h>



@protocol CameraProtocol <NSObject>

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
-(void)setResolutionModel:(int )resolutionModel;
-(void)PTZ:(unsigned char)ctrl;

- (BOOL)getEventListSupportOfChannel:(NSInteger)channel;

@end
