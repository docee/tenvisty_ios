//
//  GBase.h
//  tenvisty
//
//  Created by Tenvis on 2017/12/13.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_CAMERA_LIMIT 64
@interface GBase : NSObject


@property (nonatomic, copy) NSString *Documents;
@property (nonatomic, strong) NSMutableArray *cameras;

+ (GBase *)sharedInstance;
+ (void)initCameras;
+ (void)addCamera:(BaseCamera *)mycam;
+ (void)deleteCamera:(BaseCamera *)mycam;
+ (void)editCamera:(BaseCamera *)mycam;
+ (BaseCamera*)getCamera:(NSInteger)index;
+(NSInteger)getCameraIndex:(BaseCamera*)camera;
+ (BOOL)savePictureForCamera:(BaseCamera *)mycam image:(UIImage*)img;
+ (NSString*)saveRecordingForCamera:(BaseCamera *)mycam thumb:(UIImage*)img;
+ (BOOL)saveRemoteRecordPictureForCamera:(BaseCamera *)mycam image:(UIImage*)img eventType:(NSInteger)evtType eventTime:(NSInteger)evtTime;
+(NSInteger)countSnapshot:(NSString*)uid;
+(NSInteger)countVideo:(NSString*)uid;
+(NSString*)thumbPath:(BaseCamera*)uid;
// 屏幕快照
+ (NSMutableArray *)picturesForCamera:(BaseCamera *)mycam;
// 摄像机本地录像
+ (NSMutableArray *)recordingsForCamera:(BaseCamera *)mycam;
+ (void)deletePicture:(BaseCamera*)camera name:(NSString *)pictureName;
+ (void)deleteRecording:(NSString *)recordingPath thumbPath:(NSString*)thumbPath camera:(BaseCamera *)mycam;
+(CGFloat)getCameraVideoRatio:(BaseCamera *)mycam;
+(void)setCameraVideoRatio:(BaseCamera*)mycam ratio:(CGFloat)ratio;
+ (void)setCameraFunction:(NSString *)uid function:(NSString *)function;
+ (NSString *)getCameraFunction:(NSString *)uid;
+ (BOOL)saveRemoteRecordForCamera:(BaseCamera *)mycam image:(UIImage*)img eventType:(NSInteger)evtType eventTime:(NSInteger)evtTime;
+(BOOL)isVideoRecordExitForCamera:(BaseCamera *)mycam fileName:(NSString*)fileName;
@end
