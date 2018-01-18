//
//  HiPlayer.h
//  HiP2PSDK
//
//  Created by zhao qi on 16/9/8.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#define PLAYLOCALSTATE_ERROR  -1
#define PLAYLOCALSTATE_OPEN  0
#define PLAYLOCALSTATE_START  1
#define PLAYLOCALSTATE_ING    2
#define PLAYLOCALSTATE_END    3
#define PLAYLOCALSTATE_STOP    4


#define LOCAL2MP4_STATE_ERROR -11
#define LOCAL2MP4_STATE_OPEN 10
#define LOCAL2MP4_STATE_START 11
#define LOCAL2MP4_STATE_ING 12
#define LOCAL2MP4_STATE_END 13
#define LOCAL2MP4_STATE_STOP 14

#import <Foundation/Foundation.h>
#import "HiGLMonitor.h"

@protocol HiPlayerDelegate <NSObject>

@required

//
-(void)CallBackPlayLocalVideo:(int)Width Height:(int)Height Total:(int)videotime CURSec:(unsigned long long)cursec AudioType:(int)aType STATE:(int)state;


@end

@interface HiPlayer : NSObject
{
    HiGLMonitor* monitor;
}

@property (nonatomic, retain) HiGLMonitor *monitor;


-(id) init;

- (void) startPlay:(NSString*)dir  Monitor:(HiGLMonitor*)monitor;

- (void) stopPlay;
//20170819新增：
-(void) setDelegate:(id<HiPlayerDelegate>)delg;

- (void) SetImgview:(UIImageView*) imgview;

-(void)RemImgview;

-(void)SetImgviewFrame:(CGRect)frame;

-(void) startPlayLocalFile:(NSString*)dir ;

- (void) stopPlayLocalFile;

//先获取文件格式
//seektime   AVI  传时间    H264  百分比
//seeking   是否在拖动   true   拖动中
-(int)PlayLocal_Seek:(float) seektime AndSeeking:(BOOL) seeking;

/*
 int  speedvalue    等级  1-20   值越大越快
 int  interval   间隔时间  /毫秒   如果是0 则用默认值 50 ms
 */
-(void)PlayLocal_Speed:(int) speedvalue IntervalT:(int) interval;
-(void)PlayLocal_pause;

-(void)PlayLocal_Resume;

//20170829新增：
- (void) start2MP4:(NSString*)dir OutPath:(NSString * ) outdir ;
- (void) stop2MP4;
//-(void)CallBack2MP4File:(int)state;

@end
