//
//  LocalVideoInfo.h
//  KncAngel
//
//  Created by zhao qi on 15/8/29.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalPictureInfo.h"

@interface LocalVideoInfo : LocalPictureInfo

//- (id)initWithID:(NSString*)path Time:(NSInteger)time;
- (id)initWithRecordingName:(NSString *)name path:(NSString*)path time:(NSInteger)time type:(NSInteger)type thumbPath:(NSString *)thumbPath thumbName:(NSString *)thumbName;


@property (nonatomic, copy) NSString *path; // 对应recordingName
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger type;   // 对应的录像类型（下载／本地录制）
@property (nonatomic, copy) NSString *videoType;    // mp4/avi/其他
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *thumbPath;//缩略图
@property (nonatomic,strong,readonly) NSString *date;
@property (nonatomic,strong,readonly) NSString *desc;

@end
