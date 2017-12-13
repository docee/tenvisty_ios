/*
 * Copyright :	reecam
 * URL :		www.reecam.net
 * dev :		gao jun bin[开发者高俊斌]　
 * dev :		deng you hua [开发者邓友华]
 * doucment :	deng you hua
 * bug email:	415137038@qq.com
 * require :	IOS sdk 4.3
 */

/* changelog : 20111110 - 20121219 deng you hua
 * 库的优化
 * 声音音量调节接口删除
 * 截图接口的更改
 * 开放录像开发接口
 * reecam_n 使用部分
 */

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "NSCamera.h"

#define D_CAMERA_COMMAND_RESPONSE_BEGIN_WITHOUT_ARG(camera_command)				[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(d_camera_respone_funtion:) name: camera_command object: nil]
#define D_CAMERA_COMMAND_RESPONSE_BEGIN_WITH_ARG(camera_command,camera_object)	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(d_camera_respone_funtion:) name: camera_command object: camera_object]
#define	D_CAMERA_COMMAND_RESPONSE_END()											[[NSNotificationCenter defaultCenter] removeObserver:self]

/*
 *  camera_color.h
 *  h264_merge
 *
 *  Created by dengyouhua on 12-6-12.
 *  Copyright 2012 415137038@qq.com. All rights reserved.
 *
 */

// for color 颜色部分仅供reecam_n系列使用，如有需要开发人员也可使用　[reecam_n 使用部分]
#define D_COLOR_BLACK		[UIColor blackColor]
#define D_COLOR_DARKGRAY	[UIColor darkGrayColor]
#define D_COLOR_LIGHTGRAY	[UIColor lightGrayColor]
#define D_COLOR_WHITE		[UIColor whiteColor]
#define D_COLOR_GRAY		[UIColor grayColor]
#define D_COLOR_RED			[UIColor redColor]
#define D_COLOR_GREEN		[UIColor greenColor]
#define D_COLOR_BLUE		[UIColor blueColor]
#define D_COLOR_CYAN		[UIColor cyanColor]
#define D_COLOR_YELLOW		[UIColor yellowColor]
#define D_COLOR_MAGENTA		[UIColor magentaColor]
#define D_COLOR_ORANGE		[UIColor orangeColor]
#define D_COLOR_PURPLE		[UIColor purpleColor]
#define D_COLOR_BROWN		[UIColor brownColor]
#define D_COLOR_CLEAR		[UIColor clearColor]


/*
 内部使用
 */
#define AUDIO_RECORD_BUFFERS_NUMBER						10
#define AUDIO_PLAY_BUFFERS_NUMBER						10

#define WAN_HOST_1 @".tenvis.info"
#define WAN_HOST_2 @".mytenvis.com"

#define LAN_CONNECT_TIME_S 2    //内网连接时间
#define WAN_CONNECT_TIME_S 10   //外网连接时间

/*
 相应注册函数
 */
FOUNDATION_EXPORT NSString * const camera_search_begin_command;
FOUNDATION_EXPORT NSString * const camera_search_end_command;
FOUNDATION_EXPORT NSString * const camera_status_changed_command;
FOUNDATION_EXPORT NSString * const camera_video_status_changed_command;
FOUNDATION_EXPORT NSString * const camera_audio_status_changed_command;
FOUNDATION_EXPORT NSString * const camera_talk_status_changed_command;
FOUNDATION_EXPORT NSString * const camera_alarm_status_changed_command;
FOUNDATION_EXPORT NSString * const camera_image_command;
FOUNDATION_EXPORT NSString * const camera_get_ddns_command;
FOUNDATION_EXPORT NSString * const camera_audio_command;
FOUNDATION_EXPORT NSString * const camera_param_changed_command;
FOUNDATION_EXPORT NSString * const camera_get_stream_info; //保留

/*
 [reecam_n 使用部分]
 */
FOUNDATION_EXPORT NSString * get_file_path (NSString * filename);

/*
 录像部分
 录像部分分为录像开始与结束，使用应注意，录像的时候有且只有一个在录像，不能同时开启多个录像
 camera_stream_begin　录像开始，传入参数应为当前使用分辨率，相对来讲这个是只读到，不推荐认为设定，做法是先获取再设定。
 camera_stream_end　	录像结束，录像结束后，录像文件自动存取到photo之中。
					应当注意到是，啥时候需要停止录像，如用户进行正常到录像开始与录像结束到操作，正常调用即可，开发人员对应到app，有将要离开录像操作画面的也需要调用此函数来停止录像。
					当然还有一些其他到情况，开发人员应根据自身的app做相应思考处理。
					通常用户并不需要录制很长时间到录像，建议按照自身到实际情况，做出一定到时限，录像是会很耗内存，低端设备会强制终止消耗性很大的app，reecam_n系列目前设置为２分钟，可结合自身app做相应处理
					
 */
FOUNDATION_EXPORT void camera_stream_begin (int width, int height);
FOUNDATION_EXPORT void camera_stream_end ();


typedef enum {
	DISCONNECTED,
	CONNECTING,
	VERIFYING,
	CONNECTED,
} camera_status_t;

typedef enum {
	STOPPED,
	REQUESTING,
	PLAYING,
} camera_playing_status_t;

typedef enum {
	NONE,
	MOTION_DETECTING,
	TRIGGER_DETECTING,
	SOUND_DETECTING,
	UNKNOWN_ALARM,
} camera_alarm_status_t;

typedef enum {
	OK,
	BAD_PARAMS,
	BAD_STATUS,
	INTERNAL_ERROR,
	SOCKET_ERROR,
	CANT_CONNECT,
	PEER_CLOSED,
	UNKNOWN_ERROR,
	BAD_ID,
	MAX_SESSION,
	BAD_AUTH,
	TIMEOUT,
	FORBIDDEN,
	UNSUPPORT,
} camera_error_t;

typedef enum {
	T_UP = 0,
	T_DOWN,
	P_LEFT,
	P_RIGHT,
	PT_LEFT_UP,
	PT_RIGHT_UP,
	PT_LEFT_DOWN,
	PT_RIGHT_DOWN,
	PT_CENTER,
	PT_STOP,
	P_PATROL,
	P_PATROL_STOP,
	T_PATROL,
	T_PATROL_STOP,
	ZOOM_WIDE,
	ZOOM_TELE,
	IO_ON,
	IO_OFF,
	PT_SET_RESET1,
	PT_GO_RESET1,
	PT_SET_RESET2,
	PT_GO_RESET2,
	PT_SET_RESET3,
	PT_GO_RESET3,
	PT_SET_RESET4,
	PT_GO_RESET4,
	PT_SET_RESET5,
	PT_GO_RESET5,
	PT_SET_RESET6,
	PT_GO_RESET6,
	PT_SET_RESET7,
	PT_GO_RESET7,
	PT_SET_RESET8,
	PT_GO_RESET8,
	PT_SET_RESET9,
	PT_GO_RESET9,
	PT_SET_RESET10,
	PT_GO_RESET10,
	PT_SET_RESET11,
	PT_GO_RESET11,
	PT_SET_RESET12,
	PT_GO_RESET12,
	PT_SET_RESET13,
	PT_GO_RESET13,
	PT_SET_RESET14,
	PT_GO_RESET14,
	PT_SET_RESET15,
	PT_GO_RESET15,
	PT_SET_RESET16,
	PT_GO_RESET16,
} camera_ptz_command_t;

@protocol CameraDelegate;

@interface MjpegCamera : NSCamera <NSCoding> {
	@public
	NSNumber * audio_buffer_time;
	
	/*
	 modify by thinker on 2013-01-30 
	 */
	NSNumber * host_type;//
	
	camera_status_t			camera_status;
	camera_playing_status_t video_status;
	camera_playing_status_t audio_status;
	camera_playing_status_t talk_status;
	camera_alarm_status_t	alarm_status;
	camera_error_t			error;

	@private
	CFReadStreamRef		op_r_stream;
	CFWriteStreamRef	op_w_stream;
	CFReadStreamRef		av_r_stream;
	CFWriteStreamRef	av_w_stream;
	
	NSMutableData * op_r_data;
	NSMutableData * op_w_data;
	NSMutableData * av_r_data;
	NSMutableData * av_w_data;
	
	int op_t;
	int op_r_t;
	int op_w_t;
	
	NSTimer * timer;

	int		resolution;
	int		brightness;
	int		contrast;
	int		mode;
	int		flip;
	
	float	volume;
	
	int adpcm_decode_sample;
	int	adpcm_decode_index;
	int	adpcm_encode_sample;
	
	int	adpcm_encode_index;
	
	
	AudioQueueRef		audio_record_queue;
	AudioQueueBufferRef audio_record_buffers[AUDIO_RECORD_BUFFERS_NUMBER];
	
	AudioQueueRef		audio_play_queue;
	AudioQueueBufferRef audio_play_buffers[AUDIO_PLAY_BUFFERS_NUMBER];
	
	unsigned long		talk_seq;
	unsigned long		talk_tick;
	unsigned long		local_start_tick;
	unsigned long		camera_start_tick;
	
	
	/*
	 modify by thinker on 2013-01-3１ 
	 */	
	NSString * temp_port;
	NSString * temp_ip;
    
    BOOL isConnectLAN;
    int connect_time_s; //LAN:2s WAN:10s
}

/*
 modify by thinker on 2013-01-30
 */
@property (nonatomic, retain)	NSNumber * host_type;

@property (nonatomic, readonly)	camera_status_t camera_status;
@property (nonatomic, readonly)	camera_playing_status_t video_status;
@property (nonatomic, readonly)	camera_playing_status_t audio_status;
@property (nonatomic, readonly)	camera_playing_status_t talk_status;
@property (nonatomic, readonly)	camera_alarm_status_t alarm_status;
@property (nonatomic, readonly)	camera_error_t error;

@property (nonatomic, readonly)	BOOL started;
@property (nonatomic, readonly)	NSMutableArray * video_queue;
@property (nonatomic, readonly)	NSMutableArray * audio_queue;

/*
 搜索局域网中到设备
 */
+(void) LanSearch;
/*
 结束搜索局域网中的设备
 */
+(void)endSearch;

/*
 截取当前视频图片
 animation是否具有动画效果
 */
+ (void) snapshot : (UIImageView *) video_image animation : (BOOL) yes_or_no;

/*
 这部分为固定方式，参考例子，不需要考虑。
 */
+ (void) camera_audio_runtime_init;
+ (void) camera_audio_runtime_start;
+ (void) camera_audio_runtime_stop;

/*
 控制部分
 */
-(camera_error_t) start;
-(camera_error_t) play_video;
-(camera_error_t) play_audio;
-(camera_error_t) start_talk;

-(camera_error_t) ptz_control: (camera_ptz_command_t) command;

-(void) stop;
-(void) stop_video;
-(void) stop_audio;
-(void) stop_talk;

-(void) start_audio_record;
-(void) stop_audio_record;

//-(void) start_audio_play;
//-(void) stop_audio_play;

/*
 设置参数
 */
-(camera_error_t) set_resolution: (int) value;
-(camera_error_t) set_brightness: (int) value;
-(camera_error_t) set_contrast: (int) value;
-(camera_error_t) set_mode: (int) value;
-(camera_error_t) set_flip: (int) value;

/*
 获取参数
 */
-(int) get_resolution;
-(int) get_brightness;
-(int) get_contrast;
-(int) get_mode;
-(int) get_flip;


/*
 这部分为删除，用户直接用声音按钮控制
 */
-(void) set_volume: (float) value;
-(float) get_volume;

@end
