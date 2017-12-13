//
//  Camera.h
//  IOTCamViewer
//
//  Created by Cloud Hsiao on 12/5/11.
//  Copyright (c) 2011 TUTK. All rights reserved.
//

#define CHANNEL_VIDEO_FPS 110
#define CHANNEL_VIDEO_BPS 111
#define CHANNEL_VIDEO_FRAMECOUNT 112
#define CHANNEL_VIDEO_INCOMPLETE_FRAMECOUNT 113
#define CHANNEL_VIDEO_ONLINENM 114

#define CONNECTION_MODE_NONE -1
#define CONNECTION_MODE_P2P 0
#define CONNECTION_MODE_RELAY 1
#define CONNECTION_MODE_LAN 2



struct LAN_SEARCH 
{
	char UID[21];
	char IP[17];
	unsigned short port;
	char DeviceName[24];
	char DevicePWD[24];
};
//typedef struct LAN_SEARCH LanSearch_t;
typedef struct st_LanSearchInfo LanSearch_t;


struct SUB_STREAM
{
    int index;
    int channel;
};
typedef struct SUB_STREAM SubStream_t;

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LANSearchDevice.h"
#import "NSCamera.h"

@protocol CameraDelegate;

@interface Camera : NSCamera {
    
}

@property (readonly) NSInteger sessionID;
@property (readonly) NSInteger sessionMode;
@property (nonatomic, assign) id<CameraDelegate> delegate;

+ (void)initIOTC;
+ (void)uninitIOTC;
+ (NSString *)getIOTCAPIsVerion;
+ (NSString *)getAVAPIsVersion;
+ (void) LanSearch;
+ (LanSearch_t *)LanSearchT:(int *)num timeout:(int)timeoutVal;

- (id)initWithName:(NSString *)name;
- (void)connect:(NSString *)uid;
- (void)connect:(NSString *)uid AesKey:(NSString *)aesKey;
- (void)disconnect;
- (void)start:(NSInteger)channel viewAccount:(NSString *)viewAccount viewPassword:(NSString *)viewPassword;
- (void)stop:(NSInteger)channel;
- (Boolean)isStarting:(NSInteger)channel;
- (void)startShow:(NSInteger)channel;
- (void)stopShow:(NSInteger)channel;
- (void)startSoundToPhone:(NSInteger)channel;
- (void)stopSoundToPhone:(NSInteger)channel;
- (void)startSoundToDevice:(NSInteger)channel;
- (void)stopSoundToDevice:(NSInteger)channel;
- (void)sendIOCtrlToChannel:(NSInteger)channel Type:(NSInteger)type Data:(char *)buff DataSize:(NSInteger)size;
- (unsigned int)getChannel:(NSInteger)channel Snapshot:(char *)imgData dataSize:(unsigned long)size WithImageWidth:(unsigned int *)width ImageHeight:(unsigned int *)height;
- (unsigned int)getChannel:(NSInteger)channel Snapshot:(char *)imgData DataSize:(unsigned long)size ImageType:(unsigned int*)codec_id WithImageWidth:(unsigned int *)width ImageHeight:(unsigned int *)height;
- (NSString *)getViewAccountOfChannel:(NSInteger)channel;
- (NSString *)getViewPasswordOfChannel:(NSInteger)channel;
- (unsigned long)getServiceTypeOfChannel:(NSInteger)channel;
@end

