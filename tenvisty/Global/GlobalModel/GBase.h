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
+ (NSString*)saveRecordingForCamera:(Camera *)mycam;
@end
