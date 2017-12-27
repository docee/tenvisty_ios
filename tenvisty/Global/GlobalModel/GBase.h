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
+ (void)addCamera:(MyCamera *)mycam;
+ (void)deleteCamera:(Camera *)mycam;
+ (void)editCamera:(MyCamera *)mycam;
+ (MyCamera*)getCamera:(NSInteger)index;
+(NSInteger)getCameraIndex:(MyCamera*)camera;
+ (BOOL)savePictureForCamera:(MyCamera *)mycam image:(UIImage*)img;
+ (NSString*)saveRecordingForCamera:(Camera *)mycam thumb:(UIImage*)img;
+ (BOOL)saveRemoteRecordPictureForCamera:(MyCamera *)mycam image:(UIImage*)img eventType:(NSInteger)evtType eventTime:(NSInteger)evtTime;
+(NSInteger)countSnapshot:(NSString*)uid;
+(NSInteger)countVideo:(NSString*)uid;
+(NSString*)thumbPath:(MyCamera*)uid;
// 屏幕快照
+ (NSMutableArray *)picturesForCamera:(Camera *)mycam;
// 摄像机本地录像
+ (NSMutableArray *)recordingsForCamera:(Camera *)mycam;
+ (void)deletePicture:(MyCamera*)camera name:(NSString *)pictureName;
+ (void)deleteRecording:(NSString *)recordingPath thumbPath:(NSString*)thumbPath camera:(Camera *)mycam;

+ (void)setPushToken:(NSString*)token;
+ (NSString*)getPushToken;
@end
