/*
 * Copyright :	reecam
 * dev :		gao jun bin[开发者高俊斌]
 * dev :		deng you hua [开发者邓友华]
 * doucment :	deng you hua
 * bug email:	415137038@qq.com
 */

#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <time.h>
#import <signal.h>
#import <string.h>
#import <strings.h>
#import <sys/types.h>
#import <sys/times.h>
#import <sys/select.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <pthread.h>
#import "MjpegCamera.h"
#import "LANSearchDevice.h"
#import "FHVideoRecorder.h"

#define AUDIO_BUFFER_SIZE								640
#define AUDIO_PACKET_PAYLOAD_SIZE						160


FOUNDATION_EXPORT void camera_stream_video (UIImage * image);
FOUNDATION_EXPORT void camera_stream_audio (const void *data, int data_len);

//
//  camera_audio_metadata.h
//  g_ipcamera_play
//
//  Created by dengyouhua on 11-12-26.
//  Copyright 2011 415137038@qq.com. All rights reserved.
//

const AudioStreamBasicDescription asbd = {8000.0, kAudioFormatLinearPCM, 12, 2, 1, 2, 1, 16, 0};

static int index_adjust[8] = {-1, -1, -1, -1, 2, 4, 6, 8};
static int step_table[89] = {
	7,8,9,10,11,12,13,14,16,17,19,21,23,25,28,31,34,37,41,45,
	50,55,60,66,73,80,88,97,107,118,130,143,157,173,190,209,230,253,279,307,337,371,
	408,449,494,544,598,658,724,796,876,963,1060,1166,1282,1411,1552,1707,1878,2066,
	2272,2499,2749,3024,3327,3660,4026,4428,4871,5358,5894,6484,7132,7845,8630,9493,
	10442,11487,12635,13899,15289,16818,18500,20350,22385,24623,27086,29794,32767
};

void adpcm_encode(unsigned char * raw, int len, unsigned char * encoded, int * pre_sample, int * index) {
	short * pcm = (short *)raw;
	int cur_sample;
	int i;
	int delta;
	int sb;
	int code;
	len >>= 1;
	
	for (i = 0;i < len;i ++) {
		cur_sample = pcm[i];
		delta = cur_sample - * pre_sample;
		if (delta < 0) {
			delta = -delta;
			sb = 8;
		} else {
			sb = 0;
		}
		code = 4 * delta / step_table[* index];
		if (code>7)
			code=7;
		
		delta = (step_table[* index] * code) / 4 + step_table[* index] / 8;
		if (sb)
			delta = -delta;
		* pre_sample += delta;
		if (* pre_sample > 32767)
			* pre_sample = 32767;
		else if (* pre_sample < -32768)
			* pre_sample = -32768;
		
		* index += index_adjust[code];
		if (* index < 0)
			* index = 0;
		else if (* index > 88)
			* index = 88;
		
		if (i & 0x01)
			encoded[i >> 1] |= code | sb;
		else
			encoded[i >> 1] = (code | sb) << 4;
	}
}

void adpcm_decode(unsigned char * raw, int len, unsigned char * decoded, int * pre_sample, int * index) {
	int i;
	int code;
	int sb;
	int delta;
	short * pcm = (short *)decoded;
	len <<= 1;
    
	for (i = 0;i < len;i ++) {
		if (i & 0x01)
			code = raw[i >> 1] & 0x0f;
		else
			code = raw[i >> 1] >> 4;
		if ((code & 8) != 0)
			sb = 1;
		else
			sb = 0;
		code &= 7;
		
		delta = (step_table[* index] * code) / 4 + step_table[* index] / 8;
		if (sb)
			delta = -delta;
		* pre_sample += delta;
		if (* pre_sample > 32767)
			* pre_sample = 32767;
		else if (* pre_sample < -32768)
			* pre_sample = -32768;
		pcm[i] = * pre_sample;
		* index += index_adjust[code];
		if (* index < 0)
			* index = 0;
		if (* index > 88)
			* index = 88;
	}
	
}

NSString * get_file_path(NSString * filename) {
	if (!filename) {
		return nil;
	}
	
	return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent: filename];
}

@interface MjpegCamera ()
{
    
}
-(void) talk: (void *) data;
-(void) handle_camera_searched: (id) obj;
-(void) handle_search_ended: (id) obj;
-(void) init_op_stream;
-(void) init_av_stream;
-(void) op_stream_callback: (CFStreamEventType) eventType;
-(void) av_stream_callback: (CFStreamEventType) eventType;
-(void) on_op_stream_disconnected;
-(void) on_av_stream_disconnected;
-(void) parse_op_packet;
-(void) parse_op_login_resp: (unsigned int) content_length;
-(void) parse_op_verify_resp: (unsigned int) content_length;
-(void) parse_op_alarm_notify: (unsigned int) content_length;
-(void) parse_op_video_start_resp: (unsigned int) content_length;
-(void) parse_op_audio_start_resp: (unsigned int) content_length;
-(void) parse_op_talk_start_resp: (unsigned int) content_length;
-(void) parse_op_params_fetch_resp: (unsigned int) content_length;
-(void) parse_op_params_changed_notify: (unsigned int) content_length;
-(void) add_op_packet: (unsigned short) command : (unsigned char *) content : (unsigned int) content_length;
-(void) add_op_login_req;
-(void) add_op_verify_req;
-(void) add_op_keep_alive;
-(void) add_op_video_start_req;
-(void) add_op_video_end;
-(void) add_op_audio_start_req;
-(void) add_op_audio_end;
-(void) add_op_talk_start_req;
-(void) add_op_talk_end;
-(void) add_op_decoder_control_req : (unsigned char) command;
-(void) add_op_params_fetch_req;
-(void) add_op_params_set_req : (unsigned char) param : (unsigned char) value;
-(void) parse_av_packet;
-(void) parse_av_video_data: (unsigned int) content_length;
-(void) parse_av_audio_data: (unsigned int) content_length;
-(void) add_av_packet: (unsigned short) command : (unsigned char *) content : (unsigned int) content_length;
-(void) handle_timer: (NSTimer *)aTimer;

@end

NSString * const camera_search_begin_command = @"camera_search_begin_command";
NSString * const camera_search_end_command = @"camera_search_end_command";
NSString * const camera_status_changed_command = @"camera_status_changed_command";
NSString * const camera_video_status_changed_command = @"camera_video_status_changed_command";
NSString * const camera_audio_status_changed_command = @"camera_audio_status_changed_command";
NSString * const camera_talk_status_changed_command = @"camera_talk_status_changed_command";
NSString * const camera_alarm_status_changed_command = @"camera_alarm_status_changed_command";
NSString * const camera_image_command = @"camera_image_command";
NSString * const camera_get_ddns_command = @"camera_get_ddns_command";
NSString * const camera_audio_command=@"camera_audio_command";
NSString * const camera_param_changed_command=@"camera_param_changed_command";
NSString * const camera_get_stream_info = @"camera_get_stream_info" ;

static volatile int g_searching = 0;
static void * search_thread_func(void * arg) {
    NSLog(@"search_thread_func");
    //	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	MjpegCamera * ipcam = [[MjpegCamera alloc] init];
	int error = 0;
	NSDictionary * params;
	NSString * dev_id;
	NSString * dev_ip;
	NSNumber * dev_port;
    NSString * dev_ddns_user;
	
	int s = -1;
	int opt = 1;
	struct timeval tv;
	static char buffer[217];
	struct sockaddr_in addr;
	int ret;
	unsigned short val_s;
	unsigned long val_i;
	
	if (0 > (s = socket(AF_INET, SOCK_DGRAM, 0))) {
		error = errno;
        //		goto quit;
	}
	
	setsockopt(s, SOL_SOCKET, SO_BROADCAST, (char *)&opt, sizeof(int));
	tv.tv_sec = 5;     //search time
	tv.tv_usec = 0;
	setsockopt(s, SOL_SOCKET, SO_RCVTIMEO, (char *)&tv, sizeof(tv));
	
	memset(buffer, 0, 27);
	strcpy(buffer, "MO_I");
	buffer[4] = 0;
	buffer[15] = 4;
	buffer[26] = 1;
	
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr("255.255.255.255");
	addr.sin_port = htons(10000);
	if (27 != sendto(s, buffer, 27, 0, (const struct sockaddr *)&addr, sizeof(addr))) {
		error = errno;
        //		goto quit;
	}
	sendto(s, buffer, 27, 0, (const struct sockaddr *)&addr, sizeof(addr));
	
	while (1) {
        NSLog(@"search");
		ret = recv(s, buffer, 217, 0);
		if (ret < 0) {
			if (EAGAIN == (error = errno))
				error = 0;
			goto quit;
		}
        if (!g_searching) {
            goto quit;
        }
		
		if (ret == 0)
			goto quit;
		if ((ret < 87) || strncmp(buffer, "MO_I", 4))
			continue;
		memcpy(&val_s, buffer + 4, 2);
		memcpy(&val_i, buffer + 15, 4);
		if ((val_s != 1) || (val_i < 64))
			continue;
		
		dev_id = [NSString stringWithCString: (const char *)(buffer + 23) encoding: NSASCIIStringEncoding];
        
		memcpy(&addr.sin_addr.s_addr, buffer + 57, 4);
		dev_ip = [NSString stringWithCString: (const char *)(inet_ntoa(addr.sin_addr)) encoding: NSASCIIStringEncoding];
        
		memcpy(&val_s, buffer + 85, 2);
		val_s = ntohs(val_s);
		dev_port = [NSNumber numberWithInteger: val_s];
        
        dev_ddns_user = [NSString stringWithCString: (const char *)(buffer + 153) encoding: NSASCIIStringEncoding];
        
		params = [NSDictionary dictionaryWithObjectsAndKeys: dev_id, @"id", dev_ip, @"ip", dev_port, @"port", dev_ddns_user, @"ddns_user", nil];
		[ipcam performSelectorOnMainThread: @selector(handle_camera_searched:) withObject: params waitUntilDone: YES];
	}
    
quit:
    
	if (s > 0)
		close(s);
	
	NSNumber * result = [NSNumber numberWithInteger: error];
	params = [NSDictionary dictionaryWithObjectsAndKeys: result, @"error", nil];
	[ipcam performSelectorOnMainThread: @selector(handle_search_ended:) withObject: params waitUntilDone: YES];
	
	[ipcam release];
    g_searching = 0;
    //	[pool release];
    //	pthread_exit(NULL);
	
	return NULL;
}

static void OP_ReadStream_CallBack(CFReadStreamRef stream, CFStreamEventType eventType, void * clientCallBackInfo) {
	MjpegCamera * ipcam = (MjpegCamera *)clientCallBackInfo;
    if (ipcam && [ipcam respondsToSelector:@selector(op_stream_callback:)]) {
        NSLog(@"OP_ReadStream_CallBack %@",ipcam);
        [ipcam op_stream_callback: eventType];
    }
	
}

static void OP_WriteStream_CallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void * clientCallBackInfo) {
	MjpegCamera * ipcam = (MjpegCamera *)clientCallBackInfo;
	[ipcam op_stream_callback: eventType];
}

static void AV_ReadStream_CallBack(CFReadStreamRef stream, CFStreamEventType eventType, void * clientCallBackInfo) {
	MjpegCamera * ipcam = (MjpegCamera *)clientCallBackInfo;
	[ipcam av_stream_callback: eventType];
}

static void AV_WriteStream_CallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void * clientCallBackInfo) {
	MjpegCamera * ipcam = (MjpegCamera *)clientCallBackInfo;
	[ipcam av_stream_callback: eventType];
}

#define HEADER_LENGTH			23

#define MO_O					"MO_O"
#define MO_V					"MO_V"

#define OP_LOGIN_REQ			0
#define OP_LOGIN_RESP			1
#define OP_VERIFY_REQ			2
#define OP_VERIFY_RESP			3
#define OP_VIDEO_START_REQ		4
#define OP_VIDEO_START_RESP		5
#define OP_VIDEO_END			6
#define OP_AUDIO_START_REQ		8
#define OP_AUDIO_START_RESP		9
#define OP_AUDIO_END			10
#define OP_TALK_START_REQ		11
#define OP_TALK_START_RESP		12
#define OP_TALK_END				13
#define OP_DECODER_CONTROL_REQ	14
#define OP_PARAMS_FETCH_REQ		16
#define OP_PARAMS_FETCH_RESP	17
#define OP_PARAMS_CHANGED_NOTIFY 18
#define OP_PARAMS_SET_REQ		19
#define OP_ALARM_NOTIOFY		25
#define OP_KEEP_ALIVE			255

#define AV_LOGIN_REQ			0
#define AV_VIDEO_DATA			1
#define AV_AUDIO_DATA			2
#define AV_TALK_DATA			3

@implementation MjpegCamera

/*
 modify by thinker on 2013-01-30
 */
@synthesize host_type;//

@synthesize camera_status;
@synthesize video_status;
@synthesize audio_status;
@synthesize talk_status;
@synthesize alarm_status;
@synthesize error;
@synthesize started;
@synthesize video_queue;
@synthesize audio_queue;

#pragma mark - method

+(void) LanSearch {
    
    NSLog(@"LanSearch");
    
	if (! g_searching) {
        g_searching = 1;
        
		pthread_attr_t attr;
		pthread_t thread;
		pthread_attr_init(&attr);
		pthread_attr_setdetachstate(&attr,PTHREAD_CREATE_DETACHED);
		pthread_create(&thread, &attr, search_thread_func, NULL);
        
		pthread_attr_destroy(&attr);
		
	}
	
}

-(void) handle_camera_searched: (id) obj {
	NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    
    NSMutableArray *device_list = [[NSMutableArray alloc] init];
    
    LANSearchDevice *searchDevice = [[LANSearchDevice alloc] init];
    searchDevice.uid = [obj objectForKey:@"id"];
    searchDevice.ip = [obj objectForKey:@"ip"];
    searchDevice.port = [[obj objectForKey:@"port"] integerValue];
    searchDevice.ddns_user = [obj objectForKey:@"ddns_user"];
    searchDevice.cameraModel = CAMERA_MODEL_MJPEG;
    
    [device_list addObject:searchDevice];
    
    [searchDevice release];
    
	[nc postNotificationName: CAMERA_SEARCH_RESULT_NOTIFICATION object: self userInfo: [NSDictionary dictionaryWithObject:device_list forKey:CAMERA_SEARCH_RESULT_NOTIFICATION]];
    
    [device_list release];
}

-(void) handle_search_ended: (id) obj {
	NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    //	[nc postNotificationName: camera_search_end_command object: self userInfo: obj];
    [nc postNotificationName: CAMERA_SEARCH_END_NOTIFICATION object: self userInfo: nil];
	g_searching = 0;
}

+ (void) snapshot : (UIImageView *) video_image animation : (BOOL) yes_or_no {
	if (!video_image || ! video_image.image) {
		return;
	}
	
	if (yes_or_no) {
		[UIView beginAnimations:@"FlipAnim" context:NULL];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:video_image cache:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1];
		[UIView commitAnimations];
	}
	
	UIImageWriteToSavedPhotosAlbum(video_image.image, nil, nil, nil);
}

-(id) init {
	if (self = [super init]) {
        ;
    } else {
        return self;
    }
    
	self.uid = nil;
	self.name = nil;
	self.host = nil;
	self.port = nil;
	self.user = nil;
	self.pwd = nil;
	audio_buffer_time = [[NSNumber alloc]initWithInt:1000];
	/*
	 modify by thinker on 2013-01-30
	 */
	host_type  = nil;
    
	camera_status = DISCONNECTED;
	video_status = STOPPED;
	audio_status = STOPPED;
	talk_status = STOPPED;
	alarm_status = NONE;
	error = OK;
	
	started = NO;
	
	op_r_stream = NULL;
	op_w_stream = NULL;
	av_r_stream = NULL;
	av_w_stream = NULL;
	
	timer = nil;
	
	volume = 1.0;
	
	return self;
}

-(void) encodeWithCoder: (NSCoder *) aCoder {
	NSLog(@"%s:",__func__);
	[aCoder encodeObject: self.uid forKey: @"identity"];
	[aCoder encodeObject: self.name forKey: @"name"];
	[aCoder encodeObject: self.host forKey: @"host"];
	[aCoder encodeObject: self.port forKey: @"port"];
    [aCoder encodeObject: self.LANHost forKey: @"LANHost"];
	[aCoder encodeObject: self.LANPort forKey: @"LANPort"];
	[aCoder encodeObject: self.user forKey: @"user"];
	[aCoder encodeObject: self.pwd forKey: @"pwd"];
    [aCoder encodeObject: self.ddns forKey: @"ddns"];
	/*
	 modify by thinker on 2013-01-30
	 */
	[aCoder encodeObject: self.host_type forKey: @"host_type"];
}

-(id) initWithCoder: (NSCoder *) aDecoder {
	self = [self init];
	if (! self)
		return nil;
	
	self.uid = [aDecoder decodeObjectForKey: @"identity"];
	self.name = [aDecoder decodeObjectForKey: @"name"];;
	self.host = [aDecoder decodeObjectForKey: @"host"];
	self.port = [aDecoder decodeObjectForKey: @"port"];
    self.LANHost = [aDecoder decodeObjectForKey: @"LANHost"];
	self.LANPort = [aDecoder decodeObjectForKey: @"LANPort"];
	self.user = [aDecoder decodeObjectForKey: @"user"];
	self.pwd = [aDecoder decodeObjectForKey: @"pwd"];
    self.ddns = [aDecoder decodeObjectForKey: @"ddns"];
	/*
	 modify by thinker on 2013-01-30
	 */
	self.host_type = [aDecoder decodeObjectForKey: @"host_type"];
	return self;
}

-(void) dealloc {
	if (started) [self stop];
	
	if (self.uid) self.uid = nil;
	if (self.name) self.name = nil;
	if (self.host) self.host = nil;
	if (self.port) self.port = nil;
	if (self.user) self.user = nil;
	if (self.pwd) self.pwd = nil;
	if (audio_buffer_time) [audio_buffer_time release];
	/*
	 modify by thinker on 2013-01-30
	 */
	if (host_type) [host_type release];
	if (temp_ip) [temp_ip release];
	if (temp_port) [temp_port release];
	
	[super dealloc];
}

#pragma mark - start stop

-(camera_error_t) start {
	if ((! self.uid) || (! self.name) || (! self.host) || (! self.user) || (! self.pwd) || (! audio_buffer_time))
		return BAD_PARAMS;
	if ([self.host isEqualToString: @""] || [self.user isEqualToString: @""] || ([audio_buffer_time integerValue] <= 0) || ([audio_buffer_time integerValue] > 0xffff))
		return BAD_PARAMS;
	
	[self stop];
	
    camera_status = CONNECTING;
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_status_changed_command object: self];
    
    isConnectLAN = NO;
    connect_time_s = LAN_CONNECT_TIME_S;
    self.host = self.LANHost;
    self.port = self.LANPort;
    
    if ([self.LANHost rangeOfString:WAN_HOST_1].length > 0 || [self.LANHost rangeOfString:WAN_HOST_2].length > 0) {
        NSLog(@"connect ddns %@",self.LANHost);
        if ([self.LANHost rangeOfString:@"http://"].length <= 0) {
            self.LANHost = [NSString stringWithFormat:@"%@%@",@"http://",self.LANHost];
            
        }
        self.ddns = self.LANHost;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.ddns]];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }else{
        [self init_op_stream];
    }
	
	
    op_t = time(NULL);
	timer = [[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(handle_timer:) userInfo:nil repeats:YES] retain];
	
	started = YES;
	
	return OK;
}

-(void) stop {
	if (started) {
		if (timer != nil) {
			[timer invalidate];
			//[timer release];
			timer = nil;
		}

		started = NO;
		error = OK;
		
		[self on_op_stream_disconnected];
	}
}

-(camera_error_t) play_video {
	if (camera_status != CONNECTED)
		return BAD_STATUS;
	if (video_status == PLAYING)
		return OK;
	
	[self add_op_video_start_req];
	video_status = REQUESTING;
	
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_video_status_changed_command object: self];
	return OK;
}

-(void) stop_video {
	if (camera_status != CONNECTED)
		return;
	if (video_status == STOPPED)
		return;
	
	[self add_op_video_end];
	error = OK;
	video_status = STOPPED;
	
    //	[[NSNotificationCenter defaultCenter] postNotificationName: camera_video_status_changed_command object: self];
    //	if ((video_status == STOPPED) && (audio_status == STOPPED) && (talk_status == STOPPED))
    //		[self on_av_stream_disconnected];
}

-(camera_error_t) play_audio {
    NSLog(@"play_audio");
	if (camera_status != CONNECTED)
		return BAD_STATUS;
	
	if (audio_status == PLAYING)
		return OK;
	
	[self add_op_audio_start_req];
	audio_status = REQUESTING;
	NSLog(@"play_audio1");
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_audio_status_changed_command object: self];
	return OK;
}

-(void) stop_audio {
	if (camera_status != CONNECTED)
		return;
	if (audio_status == STOPPED)
		return;
	[self add_op_audio_end];
	error = OK;
	audio_status = STOPPED;
    
	[self stop_audio_play];
	
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_audio_status_changed_command object: self];
    //	if ((video_status == STOPPED) && (audio_status == STOPPED) && (talk_status == STOPPED))
    //		[self on_av_stream_disconnected];
}

-(camera_error_t) start_talk {
	if (camera_status != CONNECTED)
		return BAD_STATUS;
	
	if (talk_status == PLAYING)
		return OK;
	
	[self add_op_talk_start_req];
	talk_status = REQUESTING;
	
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_talk_status_changed_command object: self];
	
	return OK;
}

-(void) stop_talk {
	if (camera_status != CONNECTED)
		return;
	if (talk_status == STOPPED)
		return;
	[self add_op_talk_end];
	error = OK;
	talk_status = STOPPED;
	[self stop_audio_record];
	
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_talk_status_changed_command object: self];
    //	if ((video_status == STOPPED) && (audio_status == STOPPED) && (talk_status == STOPPED))
    //		[self on_av_stream_disconnected];
}

-(void) talk: (void *) data {
	unsigned char chunk[4 + 4 + 4 + 1 + 4 + AUDIO_PACKET_PAYLOAD_SIZE];
	
	if (talk_status != PLAYING)
		return;
	
	talk_tick += 40;
	
	int t = time(NULL);
	memcpy(chunk, &talk_tick, 4);
	memcpy(chunk + 4, &talk_seq, 4);
	talk_seq ++;
	memcpy(chunk + 8, &t, 4);
	chunk[12] = 0;
	int length = 160;
	memcpy(chunk + 13, &length, 4);
	adpcm_encode(data, AUDIO_BUFFER_SIZE, chunk + 17, &adpcm_encode_sample, &adpcm_encode_index);
	
	[self add_av_packet : AV_TALK_DATA : chunk : 4 + 4 + 4 + 1 + 4 + AUDIO_PACKET_PAYLOAD_SIZE];
}

-(camera_error_t) ptz_control: (camera_ptz_command_t) command {
    
    
	unsigned char ptz_command[] = {
		0,
		2,
		4,
		6,
		90,
		91,
		92,
		93,
		25,
		1,
		28,
		29,
		26,
		27,
		16,
		18,
		94,
		95,
		30,
		31,
		32,
		33,
		34,
		35,
		36,
		37,
		38,
		39,
		40,
		41,
		42,
		43,
		44,
		45,
		46,
		47,
		48,
		49,
		50,
		51,
		52,
		53,
		54,
		55,
		56,
		57,
		58,
		59,
		60,
		61,
	};
	if (camera_status != CONNECTED)
		return BAD_STATUS;
	if (command >= sizeof(ptz_command))
		return BAD_PARAMS;
	[self add_op_decoder_control_req: ptz_command[command]];
	return OK;
}

#pragma mark - stream

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse ddns %@ %@",response.URL.host,response.URL.port);
    self.host = response.URL.host;
    self.port = [NSString stringWithFormat:@"%d",[response.URL.port intValue]];
    
    [self init_op_stream];
}

-(void) handle_timer: (NSTimer *)aTimer {
	int t = time(NULL);
    //	NSLog(@"handle_timer %d %d %d %d",camera_status,t,op_t,t - op_t);
    //    NSLog(@"%s %@ camera_status:%d video_status:%d",__func__,self.uid,camera_status,video_status);
	if (camera_status == DISCONNECTED) {
        
		if (t - op_t >= connect_time_s) {
            
			camera_status = CONNECTING;
            [self connectLanOrWan];
			
			[[NSNotificationCenter defaultCenter] postNotificationName: camera_status_changed_command object: self];
		}
	} else if (camera_status == VERIFYING) {
		if (t - op_t > 20) {
			error = TIMEOUT;
			[self on_op_stream_disconnected];
		}
	} else if (camera_status == CONNECTED) {
		if (t - op_r_t > 2 * 60) {
			error = TIMEOUT;
			[self on_op_stream_disconnected];
		} else if (t - op_w_t > 1 * 60) {
			[self add_op_keep_alive];
		}
	}else if (camera_status == CONNECTING)
	{
		if (t - op_t >= connect_time_s )
		{
            [self connectLanOrWan];
		}
	}
}

-(void)connectLanOrWan{
    if ((isConnectLAN || self.ddns == NULL) && ([self.LANHost rangeOfString:WAN_HOST_1].length <= 0 && [self.LANHost rangeOfString:WAN_HOST_2].length <= 0)) {
        NSLog(@"connect LAN %@",self.LANHost);
        
        self.host = self.LANHost;
        self.port = self.LANPort;
        
        error = TIMEOUT;
        [self init_op_stream];
    }else{
        NSLog(@"connect WAN %@",self.ddns);
        
        if ([self.ddns rangeOfString:WAN_HOST_1].length > 0 || [self.ddns rangeOfString:WAN_HOST_2].length > 0) {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.ddns]];
            [NSURLConnection connectionWithRequest:request delegate:self];
        }else{
            NSRange httpRange = [self.ddns rangeOfString:@"http://"];
            self.host = [self.ddns substringFromIndex:httpRange.length];   //把它看成ip地址而不是http域名
            self.port = self.LANPort;
            
            error = TIMEOUT;
            [self init_op_stream];
        }
        
    }
    isConnectLAN = !isConnectLAN;
    if (isConnectLAN) {
        connect_time_s = LAN_CONNECT_TIME_S;
    }else{
        connect_time_s = WAN_CONNECT_TIME_S;
    }
}


-(void) init_op_stream{
	NSLog(@"%@ %s %d",[self class],__func__,__LINE__);
    
    op_t = time(NULL);
	
    temp_ip = [self.host retain];
    temp_port = [self.port retain];
    
    
	NSLog(@"CFStreamCreatePairWithSocketToHost before  :  %@ %@", temp_ip, temp_port);
	
	CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)temp_ip, [temp_port integerValue], &op_r_stream, &op_w_stream);
	CFStreamClientContext c;
	c.version = 0;
	c.info = self;
	c.retain = NULL;
	c.release = NULL;
	c.copyDescription = NULL;
	CFReadStreamSetClient(op_r_stream,
						  kCFStreamEventOpenCompleted|kCFStreamEventHasBytesAvailable|kCFStreamEventErrorOccurred|kCFStreamEventEndEncountered,
						  OP_ReadStream_CallBack,
						  &c);
	CFReadStreamScheduleWithRunLoop(op_r_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	CFWriteStreamSetClient(op_w_stream,
						   kCFStreamEventOpenCompleted|kCFStreamEventCanAcceptBytes|kCFStreamEventErrorOccurred|kCFStreamEventEndEncountered,
						   OP_WriteStream_CallBack,
						   &c);
	CFWriteStreamScheduleWithRunLoop(op_w_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	CFReadStreamOpen(op_r_stream);
	CFWriteStreamOpen(op_w_stream);
    if (op_r_data) {
        [op_r_data release];
        op_r_data = nil;
    }
	op_r_data = [[NSMutableData alloc] init];
    if (op_w_data) {
        [op_w_data release];
        op_w_data = nil;
    }
	op_w_data = [[NSMutableData alloc] init];
	[self add_op_login_req];
}


-(void) init_av_stream {
	NSLog(@"%@ %s %d",[self class],__func__,__LINE__);
    
	CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)temp_ip, [temp_port integerValue], &av_r_stream, &av_w_stream);
	CFStreamClientContext c;
	c.version = 0;
	c.info = self;
	c.retain = NULL;
	c.release = NULL;
	c.copyDescription = NULL;
    
    
	CFReadStreamSetClient(av_r_stream,
						  kCFStreamEventOpenCompleted|kCFStreamEventHasBytesAvailable|kCFStreamEventErrorOccurred|kCFStreamEventEndEncountered,
						  AV_ReadStream_CallBack,
						  &c);
	CFReadStreamScheduleWithRunLoop(av_r_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	CFWriteStreamSetClient(av_w_stream,
						   kCFStreamEventOpenCompleted|kCFStreamEventCanAcceptBytes|kCFStreamEventErrorOccurred|kCFStreamEventEndEncountered,
						   AV_WriteStream_CallBack,
						   &c);
	CFWriteStreamScheduleWithRunLoop(av_w_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	CFReadStreamOpen(av_r_stream);
	CFWriteStreamOpen(av_w_stream);
    if (av_r_data) {
        [av_r_data release];
        av_r_data = NULL;
    }
	av_r_data = [[NSMutableData alloc] init];
    if (av_w_data) {
        [av_w_data release];
        av_w_data = NULL;
    }
	av_w_data = [[NSMutableData alloc] init];
	[self add_av_packet : AV_LOGIN_REQ : [op_r_data mutableBytes] + HEADER_LENGTH + 2 : 4];
    
}

-(void) op_stream_callback: (CFStreamEventType) eventType {
    NSLog(@"op_stream_callback %ld",eventType);
	if (camera_status == DISCONNECTED)
		return;
	
	int ret;
	unsigned char buffer[1024];
	
	switch(eventType) {
		case kCFStreamEventOpenCompleted:
			if (camera_status != VERIFYING) {
				camera_status = VERIFYING;
				[[NSNotificationCenter defaultCenter] postNotificationName: camera_status_changed_command object: self];
				op_t = time(NULL);
			}
			break;
		case kCFStreamEventHasBytesAvailable:
            if (CFReadStreamHasBytesAvailable(op_r_stream)) {
                ret = CFReadStreamRead(op_r_stream, buffer, 1024);
                if (0 < ret) {
                    [op_r_data appendBytes : buffer length : ret];
                    [self parse_op_packet];
                } else if (0 > ret){
                    error = PEER_CLOSED;
                    NSLog(@"PEER_CLOSED 1 %d",ret);
                    //				[self on_op_stream_disconnected];
                }
            }
			
			break;
		case kCFStreamEventCanAcceptBytes:
			if ([op_w_data length] > 0 && CFWriteStreamCanAcceptBytes(op_w_stream)) {
				if (0 < (ret = CFWriteStreamWrite(op_w_stream, [op_w_data mutableBytes], [op_w_data length]))) {
					op_w_t = time(NULL);
                    if (ret <= [op_w_data length]) {
                        [op_w_data replaceBytesInRange : NSMakeRange(0, ret) withBytes : NULL length : 0];
                    }
					
				}
			}
			
			break;
		case kCFStreamEventErrorOccurred:
			if (camera_status == CONNECTING)
				error = CANT_CONNECT;
			else
				error = SOCKET_ERROR;
			[self on_op_stream_disconnected];
			break;
		case kCFStreamEventEndEncountered:
            
			break;
        case kCFStreamEventNone:
			break;
	}
}

-(void) av_stream_callback: (CFStreamEventType) eventType {
    
	if ((video_status != PLAYING) && (audio_status != PLAYING) && (talk_status != PLAYING))
		return;
    
	int ret;
	unsigned char buffer[1024];
    
	switch(eventType) {
		case kCFStreamEventOpenCompleted:
			break;
		case kCFStreamEventHasBytesAvailable:
            if (CFReadStreamHasBytesAvailable(av_r_stream)) {
                ret = CFReadStreamRead(av_r_stream, buffer, 1024);
                if (0 < ret) {
                    [av_r_data appendBytes : buffer length : ret];
                    [self parse_av_packet];
                } else if (0 > ret){
                    error = PEER_CLOSED;
                    NSLog(@"PEER_CLOSED 3");
                    //				[self on_av_stream_disconnected];
                }
            }
			
			break;
		case kCFStreamEventCanAcceptBytes:
			if ([av_w_data length] && CFWriteStreamCanAcceptBytes(av_w_stream)) {
				if (0 < (ret = CFWriteStreamWrite(av_w_stream, [av_w_data mutableBytes], [av_w_data length]))) {
                    if (ret <= [av_w_data length]) {
                        [av_w_data replaceBytesInRange : NSMakeRange(0, ret) withBytes : NULL length : 0];
                    }
					
				}
			}
			
			break;
		case kCFStreamEventErrorOccurred:
			error = SOCKET_ERROR;
            NSLog(@"%@ %s %d kCFStreamEventErrorOccurred",[self class],__func__,__LINE__);
			[self on_av_stream_disconnected];
			break;
		case kCFStreamEventEndEncountered:
            NSLog(@"%@ %s %d kCFStreamEventEndEncountered",[self class],__func__,__LINE__);
			error = PEER_CLOSED;
			[self on_av_stream_disconnected];
			break;
        case kCFStreamEventNone:
			break;
	}
}

-(void) on_op_stream_disconnected {
    NSLog(@"%@ %s %d ",[self class],__func__,__LINE__);
	[self on_av_stream_disconnected];
	
	if (op_r_stream) {
		CFReadStreamClose(op_r_stream);
		CFRelease(op_r_stream);
		op_r_stream = NULL;
		[op_r_data release];
        op_r_data = nil;
	}
    
	if (op_w_stream) {
		CFWriteStreamClose(op_w_stream);
		CFRelease(op_w_stream);
		op_w_stream = NULL;
		[op_w_data release];
        op_w_data = nil;
	}
	
	NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
	
	if (alarm_status != NONE) {
		alarm_status = NONE;
		[nc postNotificationName: camera_alarm_status_changed_command object: self];
	}
    
	if (camera_status != DISCONNECTED) {
		op_t = time(NULL);
		camera_status = DISCONNECTED;
		
		[nc postNotificationName: camera_status_changed_command object: self];
	}
    
	
}

-(void) on_av_stream_disconnected {
    NSLog(@"%@ %s %d ",[self class],__func__,__LINE__);
    
	if (av_r_stream) {
		CFReadStreamClose(av_r_stream);
		CFRelease(av_r_stream);
		av_r_stream = NULL;
		[av_r_data release];
        av_r_data = NULL;
	}
    
	if (av_w_stream) {
		CFWriteStreamClose(av_w_stream);
		CFRelease(av_w_stream);
		av_w_stream = NULL;
		[av_w_data release];
        av_w_data = NULL;
	}
    
    //    if (video_status == PLAYING) {
    //        [self start];
    //    }
	
	NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
	
	if (video_status != STOPPED) {
		video_status = STOPPED;
		
		[nc postNotificationName: camera_video_status_changed_command object: self];
	}
    
	if (audio_status != STOPPED) {
		audio_status = STOPPED;
		[self stop_audio_play];
		[nc postNotificationName: camera_audio_status_changed_command object: self];
	}
    
	if (talk_status != STOPPED) {
		talk_status = STOPPED;
		[self stop_audio_record];
		[nc postNotificationName: camera_talk_status_changed_command object: self];
	}
    
	
}



#pragma mark - get set

-(int) get_resolution {
	return resolution;
}

-(camera_error_t) set_resolution: (int) value {
	if (camera_status != CONNECTED)
		return BAD_STATUS;
	[self add_op_params_set_req : 0 : (unsigned char)value];
	return OK;
}

-(int) get_brightness {
	return brightness;
}

-(camera_error_t) set_brightness: (int) value {
	if (camera_status != CONNECTED)
		return BAD_STATUS;
	[self add_op_params_set_req : 1 : (unsigned char)value];
	return OK;
}

-(int) get_contrast {
	return contrast;
}

-(camera_error_t) set_contrast: (int) value {
	if (camera_status != CONNECTED)
		return BAD_STATUS;
	[self add_op_params_set_req : 2 : (unsigned char)value];
	return OK;
}

-(int) get_mode {
	return mode;
}

-(camera_error_t) set_mode: (int) value {
	if (camera_status != CONNECTED)
		return BAD_STATUS;
	[self add_op_params_set_req : 3 : (unsigned char)value];
	return OK;
}

-(int) get_flip {
	return flip;
}

-(camera_error_t) set_flip: (int) value {
	if (camera_status != CONNECTED)
		return BAD_STATUS;
	[self add_op_params_set_req : 5 : (unsigned char)value];
	return OK;
}

-(float) get_volume {
	return volume;
}

-(void) set_volume: (float) value {
}

-(void) parse_op_packet {
    
	int i;
	unsigned short command;
	unsigned int content_length;
	
loop:
	
	if (! [op_r_data length])
		return;
	
	for (i = 0;i < [op_r_data length] - 3;i ++) {
		if (0 == memcmp([op_r_data mutableBytes] + i, MO_O, 4))
			break;
	}
	
	if (i) [op_r_data replaceBytesInRange : NSMakeRange(0, i) withBytes : NULL length : 0];
	
	if ([op_r_data length] < HEADER_LENGTH)
		return;
	
	memcpy(&command, [op_r_data mutableBytes] + 4, 2);
	memcpy(&content_length, [op_r_data mutableBytes] + 15, 4);
	
	if ([op_r_data length] < HEADER_LENGTH + content_length)
		return;
	
	op_r_t = time(NULL);
	NSLog(@"parse_op_packet %d",command);
	switch(command) {
		case OP_LOGIN_RESP:
			[self parse_op_login_resp : content_length];
			break;
		case OP_VERIFY_RESP:
			[self parse_op_verify_resp : content_length];
			break;
		case OP_ALARM_NOTIOFY:
			[self parse_op_alarm_notify : content_length];
			break;
		case OP_VIDEO_START_RESP:
			[self parse_op_video_start_resp : content_length];
			break;
		case OP_AUDIO_START_RESP:
			[self parse_op_audio_start_resp : content_length];
			break;
		case OP_TALK_START_RESP:
			[self parse_op_talk_start_resp : content_length];
			break;
		case OP_PARAMS_FETCH_RESP:
			[self parse_op_params_fetch_resp : content_length];
			break;
		case OP_PARAMS_CHANGED_NOTIFY:
			[self parse_op_params_changed_notify : content_length];
			break;
	}
	
	if (camera_status != DISCONNECTED) {
        if (HEADER_LENGTH + content_length <= [op_r_data length]) {
            [op_r_data replaceBytesInRange : NSMakeRange(0, HEADER_LENGTH + content_length) withBytes : NULL length : 0];
        }
		
		goto loop;
	}
}

-(void) parse_op_login_resp : (unsigned int) content_length {
	NSLog(@"parse op login resp ");
	unsigned short result;
	if (content_length != 27) {
		error = UNKNOWN_ERROR;
		[self on_op_stream_disconnected];
		return;
	}
	
	memcpy(&result, [op_r_data mutableBytes] + HEADER_LENGTH, 2);
	if (result == 0) {
		if ([self.uid isEqualToString : @""]) {
            
			self.uid = [NSString stringWithCString: (const char *)[op_r_data mutableBytes] + HEADER_LENGTH + 2 encoding: NSASCIIStringEncoding];
		} else {
			if (strcmp([self.uid cStringUsingEncoding : NSASCIIStringEncoding], (const char *)[op_r_data mutableBytes] + HEADER_LENGTH + 2)) {
			}
		}
        
		[self add_op_verify_req];
        
	} else if (result == 2) {
        
		error = MAX_SESSION;
		[self on_op_stream_disconnected];
		return;
	} else {
        
		error = UNKNOWN_ERROR;
		[self on_op_stream_disconnected];
		return;
	}
}

-(void) parse_op_verify_resp: (unsigned int) content_length {
	NSLog(@"parse_op_verify_resp ");
	unsigned short result;
	if (content_length < 2) {
		error = UNKNOWN_ERROR;
		[self on_op_stream_disconnected];
		return;
	}
	memcpy(&result, [op_r_data mutableBytes] + HEADER_LENGTH, 2);
	if (result == 0) {
		camera_status = CONNECTED;
        NSLog(@"camera_status = CONNECTED;");
        
		[self add_op_params_fetch_req];
        
		[[NSNotificationCenter defaultCenter] postNotificationName: camera_status_changed_command object: self];
	} else {
		error = BAD_AUTH;
        NSLog(@"%@ CONNECTION_STATE_WRONG_PASSWORD %@ %@",self.uid,self.user,self.pwd);
        self.sessionState = CONNECTION_STATE_WRONG_PASSWORD;
        if (self.delegate2 && [self.delegate2 respondsToSelector:@selector(camera:_didChangeChannelStatus:ChannelStatus:)]) {
            [self.delegate2 camera:self _didChangeChannelStatus:0 ChannelStatus:self.sessionState];
        }
        if (self.delegate2 && [self.delegate2 respondsToSelector:@selector(camera:_didChangeSessionStatus:)]) {
            [self.delegate2 camera:self _didChangeSessionStatus:self.sessionState];
        }
        //		[self on_op_stream_disconnected];
		return;
	}
}

-(void) parse_op_alarm_notify: (unsigned int) content_length {
    
	if (content_length != 9)
		return;
	unsigned char alarm = * ((unsigned char *)[op_r_data mutableBytes] + HEADER_LENGTH);
	if (alarm == 0)
		alarm_status = NONE;
	else if (alarm == 1)
		alarm_status = MOTION_DETECTING;
	else if (alarm == 2)
		alarm_status = TRIGGER_DETECTING;
	else if (alarm == 3)
		alarm_status = SOUND_DETECTING;
	else
		alarm_status = UNKNOWN_ALARM;
	
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_alarm_status_changed_command object: self];
}

-(void) parse_op_video_start_resp: (unsigned int) content_length {
    NSLog(@"%@ %s %d start",[self class],__func__,__LINE__);
	if (video_status != REQUESTING) return;
	
	if (content_length < 2) {
		error = UNKNOWN_ERROR;
		goto fail;
	}
    
	
	unsigned short result;
	memcpy(&result, [op_r_data mutableBytes] + HEADER_LENGTH, 2);
	if (result == 0) {
		if (content_length == 2) {
			video_status = PLAYING;
			
			[[NSNotificationCenter defaultCenter] postNotificationName: camera_video_status_changed_command object: self];
			return ;
		} else if (content_length == 6) {
            
            if (video_status != PLAYING && audio_status != PLAYING && talk_status != PLAYING) {
                
                [self init_av_stream];
                
            }
            
			video_status = PLAYING;
			
			[[NSNotificationCenter defaultCenter] postNotificationName: camera_video_status_changed_command object: self];
			return ;
		} else {
			error = UNKNOWN_ERROR;
			goto fail;
		}
	} else if (result == 2) {
		error = MAX_SESSION;
		goto fail;
	} else if (result == 8) {
		error = FORBIDDEN;
		goto fail;
	} else {
		error = UNKNOWN_ERROR;
		goto fail;
	}
	NSLog(@"%@ %s %d end",[self class],__func__,__LINE__);
	return;
	
fail:
	video_status = STOPPED;
	
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_video_status_changed_command object: self];
    
    NSLog(@"%@ %s %d fail",[self class],__func__,__LINE__);
	return ;
}

-(void) parse_op_audio_start_resp: (unsigned int) content_length {
	if (audio_status != REQUESTING) return;
	
	if (content_length < 2) {
		error = UNKNOWN_ERROR;
		goto fail;
	}
	
	unsigned short result;
	memcpy(&result, [op_r_data mutableBytes] + HEADER_LENGTH, 2);
	if (result == 0) {
		adpcm_decode_sample = adpcm_decode_index = 0;
		if (content_length == 2) {
			audio_status = PLAYING;
			[self start_audio_play];
			[[NSNotificationCenter defaultCenter] postNotificationName: camera_audio_status_changed_command object: self];
			return ;
		} else if (content_length == 6) {
            if (video_status != PLAYING && audio_status != PLAYING && talk_status != PLAYING) {
                [self init_av_stream];
            }
			
			audio_status = PLAYING;
			[self start_audio_play];
			[[NSNotificationCenter defaultCenter] postNotificationName: camera_audio_status_changed_command object: self];
			return ;
		} else {
			error = UNKNOWN_ERROR;
			goto fail;
		}
	} else if (result == 2) {
		error = MAX_SESSION;
		goto fail;
	} else if (result == 7) {
		error = UNSUPPORT;
		goto fail;
	} else if (result == 8) {
		error = FORBIDDEN;
		goto fail;
	} else {
		error = UNKNOWN_ERROR;
		goto fail;
	}
	
	return;
	
fail:
	audio_status = STOPPED;
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_audio_status_changed_command object: self];
	return ;
}

-(void) parse_op_talk_start_resp: (unsigned int) content_length {
	if (talk_status != REQUESTING) return;
	
	if (content_length < 2) {
		error = UNKNOWN_ERROR;
		goto fail;
	}
	
	unsigned short result;
	memcpy(&result, [op_r_data mutableBytes] + HEADER_LENGTH, 2);
	if (result == 0) {
		talk_tick = talk_seq = adpcm_encode_sample = adpcm_encode_index = 0;
		if (content_length == 2) {
			talk_status = PLAYING;
			[self start_audio_record];
			[[NSNotificationCenter defaultCenter] postNotificationName: camera_talk_status_changed_command object: self];
			return ;
		} else if (content_length == 6) {
            if (video_status != PLAYING && audio_status != PLAYING && talk_status != PLAYING) {
                [self init_av_stream];
            }
			
			talk_status = PLAYING;
			[self start_audio_record];
			[[NSNotificationCenter defaultCenter] postNotificationName: camera_talk_status_changed_command object: self];
			return ;
		} else {
			error = UNKNOWN_ERROR;
			goto fail;
		}
	} else if (result == 2) {
		error = MAX_SESSION;
		goto fail;
	} else if (result == 7) {
		error = UNSUPPORT;
		goto fail;
	} else if (result == 8) {
		error = FORBIDDEN;
		goto fail;
	} else {
		error = UNKNOWN_ERROR;
		goto fail;
	}
	
	return;
	
fail:
	talk_status = STOPPED;
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_talk_status_changed_command object: self];
	return ;
}

-(void) parse_op_params_fetch_resp: (unsigned int) content_length {
	if (content_length < 6)
		return;
    
	resolution = * ((unsigned char *)([op_r_data mutableBytes] + HEADER_LENGTH));
	brightness = * ((unsigned char *)([op_r_data mutableBytes] + HEADER_LENGTH + 1));
	contrast = * ((unsigned char *)([op_r_data mutableBytes] + HEADER_LENGTH + 2));
	mode = * ((unsigned char *)([op_r_data mutableBytes] + HEADER_LENGTH + 3));
	flip = * ((unsigned char *)([op_r_data mutableBytes] + HEADER_LENGTH + 5));
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_param_changed_command object: self];
	return;
}

-(void) parse_op_params_changed_notify: (unsigned int) content_length {
	if (content_length != 2)
		return;
	
	unsigned char command = * ((unsigned char *)([op_r_data mutableBytes] + HEADER_LENGTH));
	unsigned char value = * ((unsigned char *)([op_r_data mutableBytes] + HEADER_LENGTH + 1));
	
	switch (command) {
		case 0:
			resolution = value;
			break;
		case 1:
			brightness = value;
			break;
		case 2:
			contrast = value;
			break;
		case 3:
			mode = value;
			break;
		case 5:
			flip = value;
			break;
		default:
			break;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName: camera_param_changed_command object: self];
	return;
}

-(void) add_op_packet: (unsigned short) command : (unsigned char *) content : (unsigned int) content_length {
	unsigned char header[HEADER_LENGTH];
	memset(header, 0, HEADER_LENGTH);
	memcpy(header, MO_O, 4);
	memcpy(header + 4, &command, 2);
	memcpy(header + 15, &content_length, 4);
	
	[op_w_data appendBytes : header length: HEADER_LENGTH];
	if (content_length) [op_w_data appendBytes : content length: content_length];
	
	if (CFWriteStreamCanAcceptBytes(op_w_stream)) {
		int ret;
		if (0 < (ret = CFWriteStreamWrite(op_w_stream, [op_w_data mutableBytes], [op_w_data length]))) {
			op_w_t = time(NULL);
            if (ret <= [op_w_data length]) {
                [op_w_data replaceBytesInRange : NSMakeRange(0, ret) withBytes : NULL length : 0];
            }
		}
	}
}

-(void) add_op_login_req {
	NSLog(@"%s: ",__func__);
	[self add_op_packet : OP_LOGIN_REQ : NULL : 0];
}

-(void) add_op_verify_req {
    NSLog(@"add_op_verify_req");
    
	unsigned char content[26];
	memset(content, 0, 26);
	strncpy((char *)content, [self.user cStringUsingEncoding : NSASCIIStringEncoding], 12);
	strncpy((char *)content + 13, [self.pwd cStringUsingEncoding : NSASCIIStringEncoding], 12);
	[self add_op_packet : OP_VERIFY_REQ : content : 26];
}

-(void) add_op_keep_alive {
	[self add_op_packet : OP_KEEP_ALIVE : NULL : 0];
}

-(void) add_op_video_start_req {
	NSLog(@"add_op_video_start_req ");
	unsigned char buffer = 1;
	[self add_op_packet : OP_VIDEO_START_REQ : &buffer : 1];
}

-(void) add_op_video_end {
	[self add_op_packet : OP_VIDEO_END : NULL : 0];
}

-(void) add_op_audio_start_req {
	unsigned char buffer = 1;
	[self add_op_packet : OP_AUDIO_START_REQ : &buffer : 1];
}

-(void) add_op_audio_end {
	[self add_op_packet : OP_AUDIO_END : NULL : 0];
}

-(void) add_op_talk_start_req {
	unsigned char buffer = [audio_buffer_time integerValue] / 1000;
	if (! buffer) buffer = 1;
	[self add_op_packet : OP_TALK_START_REQ : &buffer : 1];
}

-(void) add_op_talk_end {
	[self add_op_packet : OP_TALK_END : NULL : 0];
}

-(void) add_op_decoder_control_req : (unsigned char) command {
	[self add_op_packet : OP_DECODER_CONTROL_REQ : &command : 1];
}

-(void) add_op_params_fetch_req {
	[self add_op_packet : OP_PARAMS_FETCH_REQ : NULL : 0];
}

-(void) add_op_params_set_req : (unsigned char) param : (unsigned char) value {
    
	unsigned char buffer[2];
	buffer[0] = param;
	buffer[1] = value ;
	[self add_op_packet : OP_PARAMS_SET_REQ : buffer : 2];
}

-(void) parse_av_packet {
	int i;
	unsigned short command;
	unsigned int content_length;
    
loop:
	
	if (! [av_r_data length])
		return;
	
	for (i = 0;i < [av_r_data length] - 3;i ++) {
		if (0 == memcmp([av_r_data mutableBytes] + i, MO_V, 4))
			break;
	}
	
	if (i) [av_r_data replaceBytesInRange : NSMakeRange(0, i) withBytes : NULL length : 0];
	
	if ([av_r_data length] < HEADER_LENGTH)
		return;
	
	memcpy(&command, [av_r_data mutableBytes] + 4, 2);
	memcpy(&content_length, [av_r_data mutableBytes] + 15, 4);
	
	if ([av_r_data length] < HEADER_LENGTH + content_length)
		return;
	
	switch(command) {
		case AV_VIDEO_DATA:
			[self parse_av_video_data : content_length];
			break;
		case AV_AUDIO_DATA:
			[self parse_av_audio_data : content_length];
			break;
	}
	if (HEADER_LENGTH + content_length <= [av_r_data length]) {
        [av_r_data replaceBytesInRange : NSMakeRange(0, HEADER_LENGTH + content_length) withBytes : NULL length : 0];
    }
    
	goto loop;
}

-(void) parse_av_video_data: (unsigned int) content_length {
    
	if (video_status != PLAYING)
		return;
	if (content_length < 13)
		return;
    
	long t;
	unsigned long tick, length;
	memcpy(&tick, [av_r_data mutableBytes] + HEADER_LENGTH, 4);
	memcpy(&t, [av_r_data mutableBytes] + HEADER_LENGTH + 4, 4);
	memcpy(&length, [av_r_data mutableBytes] + HEADER_LENGTH + 9, 4);
	
	if (content_length != 13 + length)
		return;
	
	NSNumber * image_tick;
	NSDictionary * params;
	NSNumber * image_t = [NSNumber numberWithLong: t];
	NSData * image_data = [NSData dataWithBytes : [av_r_data mutableBytes] + HEADER_LENGTH + 13 length: length];
	if (audio_status == PLAYING) {
		if (local_start_tick) {
			image_tick = [NSNumber numberWithUnsignedLong: local_start_tick + tick - camera_start_tick];
			params = [NSDictionary dictionaryWithObjectsAndKeys: image_t, @"t", image_tick, @"tick", image_data, @"data", nil];
			[video_queue addObject : params];
		}
	} else {
		image_tick = [NSNumber numberWithUnsignedLong: tick];
		params = [NSDictionary dictionaryWithObjectsAndKeys: image_t, @"t", image_tick, @"tick", image_data, @"data", nil];
		[self.delegateForMonitor camera:self didReceiveJPEG:[UIImage imageWithData: [params objectForKey: @"data"]]];
        [[NSNotificationCenter defaultCenter] postNotificationName: camera_image_command object: self userInfo: params];
        //		camera_stream_video([UIImage imageWithData: image_data]);
	}
}

-(void) parse_av_audio_data: (unsigned int) content_length {
    //    NSLog(@"parse_av_audio_data");
	if (audio_status != PLAYING)
		return;
	if (content_length < 13)
		return;
	long t;
	unsigned long tick, length;
	short sample_temp;
	char index_temp;
	unsigned char * decoded;
	
	memcpy(&tick, [av_r_data mutableBytes] + HEADER_LENGTH, 4);
	memcpy(&t, [av_r_data mutableBytes] + HEADER_LENGTH + 8, 4);
	memcpy(&length, [av_r_data mutableBytes] + HEADER_LENGTH + 13, 4);
    //	NSLog(@"parse_av_audio_data1 %d %ld %ld %ld",content_length,20 + length,tick,t);
	if (content_length == 20 + length) {
		memcpy(&sample_temp, [av_r_data mutableBytes] + HEADER_LENGTH + 17 + length, 2);
		index_temp = *((char *)([av_r_data mutableBytes] + HEADER_LENGTH + 17 + length + 2));
		adpcm_decode_sample = sample_temp;
		adpcm_decode_index = index_temp;
	} else if (content_length != 17 + length)
		return;
    
    decoded = (unsigned char *)malloc(length << 2);
    
    adpcm_decode([av_r_data mutableBytes] + HEADER_LENGTH + 17, length, decoded, &adpcm_decode_sample, &adpcm_decode_index);
    
    NSNumber * chunk_t = [NSNumber numberWithLong: t];
    if (local_start_tick == 0) {
        struct tms tms_buffer;
        local_start_tick = times(&tms_buffer) + [audio_buffer_time integerValue] / 10;
        camera_start_tick = tick;
    }
    
    NSNumber * chunk_tick = [NSNumber numberWithUnsignedLong: local_start_tick + tick - camera_start_tick];
    NSData * chunk_data = [NSData dataWithBytesNoCopy: decoded length:(length << 2) freeWhenDone: YES];
    //NSLog(@"audio length：%d",[chunk_data length]);
    //    NSLog(@"%@",chunk_data);
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: chunk_t, @"t", chunk_tick, @"tick", chunk_data, @"data", nil];
    [audio_queue addObject : params];
    
}

-(void) add_av_packet: (unsigned short) command : (unsigned char *) content : (unsigned int) content_length {
	unsigned char header[HEADER_LENGTH];
	memset(header, 0, HEADER_LENGTH);
	memcpy(header, MO_V, 4);
	memcpy(header + 4, &command, 2);
	memcpy(header + 15, &content_length, 4);
	
	[av_w_data appendBytes : header length: HEADER_LENGTH];
	if (content_length) [av_w_data appendBytes : content length: content_length];
    int ret = 0;
	if (CFWriteStreamCanAcceptBytes(av_w_stream)) {
		NSLog(@"%@ %s %d ret:%d",[self class],__func__,__LINE__,ret);
		if (0 < (ret = CFWriteStreamWrite(av_w_stream, [av_w_data mutableBytes], [av_w_data length])))
            if (ret <= [av_w_data length]) {
                [av_w_data replaceBytesInRange : NSMakeRange(0, ret) withBytes : NULL length : 0];
            }
        
	}
    
    //    NSLog(@"%@ %s %d ret:%d",[self class],__func__,__LINE__,ret);
    //    NSLog(@"%@",av_w_data);
}

static void MyAudioQueueInputCallback (void * inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp * inStartTime, UInt32 inNumberPacketDescriptions, const AudioStreamPacketDescription * inPacketDescs) {
	MjpegCamera * ipcam = (MjpegCamera *)inUserData;
	[ipcam talk: inBuffer->mAudioData];
	AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

-(void) start_audio_record {
	AudioQueueNewInput(&asbd, MyAudioQueueInputCallback, self, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 0, &audio_record_queue);
	
	int i;
	for (i = 0; i < AUDIO_RECORD_BUFFERS_NUMBER; i++) {
		AudioQueueAllocateBuffer(audio_record_queue, AUDIO_BUFFER_SIZE, &audio_record_buffers[i]);
		AudioQueueEnqueueBuffer(audio_record_queue, audio_record_buffers[i], 0, NULL);
	}
	AudioQueueSetParameter(audio_record_queue, kAudioQueueParam_Volume, volume);
	AudioQueueStart(audio_record_queue, NULL);
}

-(void) stop_audio_record {
	int i;
	
	AudioQueueFlush(audio_record_queue);
	AudioQueueStop(audio_record_queue, YES);
	for (i = 0; i < AUDIO_RECORD_BUFFERS_NUMBER; i++)
		AudioQueueFreeBuffer(audio_record_queue, audio_record_buffers[i]);
	AudioQueueDispose(audio_record_queue, YES);
}

static void MyAudioQueueOutputCallback(void * inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
	struct tms tms_buffer;
	unsigned long tick = times(&tms_buffer);
	NSDictionary * params;
	unsigned long play_tick;
	BOOL find = NO;
	MjpegCamera * camera = inBuffer->mUserData;
    int audio_size = AUDIO_BUFFER_SIZE;
    
	while (camera.audio_queue.count) {
		params = [camera.audio_queue objectAtIndex : 0];
		play_tick = [[params objectForKey: @"tick"] unsignedLongValue];
        
		if (tick >= play_tick) {
			if (tick - play_tick <= 25) {
                audio_size = [[params objectForKey: @"data"] length];
                NSLog(@"MyAudioQueueOutputCallback %d",audio_size);
				memcpy(inBuffer->mAudioData, [[params objectForKey: @"data"] bytes], audio_size);
                [[FHVideoRecorder getInstance]writeAudioFrame:[params objectForKey: @"data"]];
				camera_stream_audio([[params objectForKey: @"data"] bytes], audio_size);
				find = YES;
			}
			
			[camera.audio_queue removeObjectAtIndex: 0];
            
            if (find == YES) {
				break;
			}
		} else {
			break;
		}
	}
	
	if (! find) {
        audio_size = AUDIO_BUFFER_SIZE;
		memset(inBuffer->mAudioData, 0, AUDIO_BUFFER_SIZE);
	}
    
	inBuffer->mAudioDataByteSize = audio_size;
	AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
	
	while (camera.video_queue.count) {
		params = [camera.video_queue objectAtIndex : 0];
		play_tick = [[params objectForKey: @"tick"] unsignedLongValue];
		if (tick >= play_tick) {
			if (tick - play_tick <= 10) {
                
                [camera.delegateForMonitor camera:camera didReceiveJPEG:[UIImage imageWithData: [params objectForKey: @"data"]]];
                [[NSNotificationCenter defaultCenter] postNotificationName: camera_image_command object: camera userInfo: params];
                
				camera_stream_video([UIImage imageWithData: [params objectForKey: @"data"]]);
			}
			[camera.video_queue removeObjectAtIndex: 0];
		} else {
			break;
		}
	}
}

-(void) start_audio_play {
	AudioQueueNewOutput(&asbd, MyAudioQueueOutputCallback, self, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 0, &audio_play_queue);
	//for (i = 0; i < AUDIO_PLAY_BUFFERS_NUMBER; i++)
	int i;
	for (i = 0; i < 4; i++) {
		AudioQueueAllocateBuffer(audio_play_queue, AUDIO_BUFFER_SIZE, &audio_play_buffers[i]);
		audio_play_buffers[i]->mUserData = self;
		memset(audio_play_buffers[i]->mAudioData, 0, AUDIO_BUFFER_SIZE);
		audio_play_buffers[i]->mAudioDataByteSize = AUDIO_BUFFER_SIZE;
		AudioQueueEnqueueBuffer(audio_play_queue, audio_play_buffers[i], 0, NULL);
	}
    
	AudioQueueSetParameter(audio_play_queue, kAudioQueueParam_Volume, volume);
	AudioQueueStart(audio_play_queue, NULL);
	
	video_queue = [[NSMutableArray alloc] init];
	audio_queue = [[NSMutableArray alloc] init];
	
	local_start_tick = 0;
    
}

-(void) stop_audio_play {
	AudioQueueStop(audio_play_queue, YES);
	int i;
	for (i = 0; i < AUDIO_PLAY_BUFFERS_NUMBER; i++)
		AudioQueueFreeBuffer(audio_play_queue, audio_play_buffers[i]);
	AudioQueueDispose(audio_play_queue, YES);
	
	if (video_queue) {
        [video_queue release];
        video_queue = nil;
    }
    if (audio_queue) {
        [audio_queue release];
        audio_queue = nil;
    }
	
	local_start_tick = 0;
}


#define D_AUDIO_SESSION_SHARE			[AVAudioSession sharedInstance]

+ (void) camera_audio_runtime_init {
	[D_AUDIO_SESSION_SHARE setActive: NO error: nil];
	[D_AUDIO_SESSION_SHARE setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    
    UInt32 y = 1; AudioSessionSetProperty( kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (y), &y);
}

+ (void) camera_audio_runtime_start {
	[D_AUDIO_SESSION_SHARE setActive: YES error: nil];
}

+ (void) camera_audio_runtime_stop {
	[D_AUDIO_SESSION_SHARE setActive: NO error: nil];
}

@end

//
//  camera_recorder_cell.h
//  g_ipcamera_play
//
//  Created by dengyouhua on 12-2-13.
//  Copyright 2012 415137038@qq.com. All rights reserved.
//

//#import <Foundation/Foundation.h>


@interface camera_recorder_cell : NSObject {
	AVAssetWriter *d_stream_file;
	AVAssetWriterInput *d_video_stream;
	AVAssetWriterInput *d_audio_stream;
	AVAssetWriterInputPixelBufferAdaptor *d_stream_buffer;
	
	CGSize	d_stream_size;
	BOOL	d_stream_is_running;
	
	NSDictionary *d_video_stream_settings;
	NSDictionary *d_audio_stream_settings;
	NSDictionary *d_option_stream_settings;
}

@property (assign) CGSize	d_stream_size;
@property (assign) BOOL		d_stream_is_running;
@property (nonatomic, retain) NSDictionary *d_video_stream_settings;
@property (nonatomic, retain) NSDictionary *d_audio_stream_settings;
@property (nonatomic, retain) NSDictionary *d_option_stream_settings;

- (void) stream_start;
- (void) stream_video: (UIImage *) image;
- (void) stream_audio: (const void *)data length: (int) len;
- (void) stream_update_settings :(int) width height: (int) height;
- (void) stream_stop;

@end


//
//  camera_recorder_cell.m
//  g_ipcamera_play
//
//  Created by dengyouhua on 12-2-13.
//  Copyright 2012 415137038@qq.com. All rights reserved.
//

//#import "camera_recorder_cell.h"

#define D_CAMERA_RECODER_MOV					@"camera_recorder.mov"

#define D_CAMERA_RECODER_FRAME_WIDTH			320
#define D_CAMERA_RECODER_FRAME_HEIGHT			240
#define D_CAMERA_RECODER_MIN_RESOLUTION_WIDTH	50
#define D_CAMERA_RECODER_MIN_RESOLUTION_HEIGHT	50
#define D_CAMERA_RECODER_MAX_RESOLUTION_WIDTH	5000
#define D_CAMERA_RECODER_MAX_RESOLUTION_HEIGHT	5000

static CFAbsoluteTime d_stream_time;

@implementation camera_recorder_cell
@synthesize d_stream_size;
@synthesize d_stream_is_running;
@synthesize d_video_stream_settings;
@synthesize d_audio_stream_settings;
@synthesize d_option_stream_settings;

- (id) init {
	if (self = [super init]) {
		d_stream_file = nil;
		d_stream_is_running = NO;
		d_video_stream = d_audio_stream = nil;
		d_video_stream_settings = d_audio_stream_settings = nil;
	}
	
	return self;
}

- (void) init_metadata {
	AudioChannelLayout acl = {kAudioChannelLayoutTag_Mono};
	d_audio_stream_settings = [NSDictionary dictionaryWithObjectsAndKeys:
							   [NSNumber numberWithFloat: 8000], AVSampleRateKey,
							   [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
							   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
							   [NSNumber numberWithInt: 16], AVLinearPCMBitDepthKey,
							   [NSNumber numberWithBool: NO], AVLinearPCMIsFloatKey,
							   [NSNumber numberWithBool: NO], AVLinearPCMIsBigEndianKey,
							   [NSNumber numberWithBool: NO], AVLinearPCMIsNonInterleaved,
							   [NSData dataWithBytes: &acl length: sizeof (acl)], AVChannelLayoutKey,
							   nil
							   ];
	
	d_option_stream_settings = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool: YES], kCVPixelBufferCGImageCompatibilityKey, [NSNumber numberWithBool: YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
}


- (void) stream_init {
	NSString *f = get_file_path(D_CAMERA_RECODER_MOV);
	NSURL *url = [NSURL fileURLWithPath: f];
	[[NSFileManager defaultManager] removeItemAtPath: f error: nil];
	
	d_stream_file = [[AVAssetWriter alloc] initWithURL: url fileType: AVFileTypeQuickTimeMovie error: nil];
	f = nil;
	url = nil;
}

- (void) stream_init_destroy {
	if (d_stream_file) {
		[d_stream_file release];
		d_stream_file = nil;
		d_stream_is_running = NO;
	}
}

- (void) stream_video_destroy {
	if (d_stream_buffer) {
		[d_stream_buffer release];
		d_stream_buffer = nil;
	}
	
	if (d_video_stream) {
		[d_video_stream release];
		d_video_stream = nil;
	}
}

- (void) stream_audio_destroy {
	if (d_audio_stream) {
		[d_audio_stream release];
		d_audio_stream = nil;
	}
}

- (void) stream_all_destroy {
	d_stream_is_running = NO;
	[self stream_video_destroy];
	[self stream_audio_destroy];
	[self stream_init_destroy];
}


- (void) stream_update_settings :(int) width height: (int) height {
	if (width < D_CAMERA_RECODER_MIN_RESOLUTION_WIDTH || width > D_CAMERA_RECODER_MAX_RESOLUTION_WIDTH) {
		return;
	}
	
	if (height < D_CAMERA_RECODER_MIN_RESOLUTION_HEIGHT || height > D_CAMERA_RECODER_MAX_RESOLUTION_HEIGHT) {
		return;
	}
	
	d_video_stream_settings = [NSDictionary dictionaryWithObjectsAndKeys: AVVideoCodecH264, AVVideoCodecKey, [NSNumber numberWithInt: width], AVVideoWidthKey, [NSNumber numberWithInt: height], AVVideoHeightKey, nil];
}


- (void) stream_start {
	[self init_metadata];
	[self stream_init];
	
	if ((!d_stream_file) || (d_stream_file.error)) {
		[self stream_init_destroy];
		return;
	} else {
		d_video_stream = [[AVAssetWriterInput alloc] initWithMediaType: AVMediaTypeVideo outputSettings: d_video_stream_settings];
		d_audio_stream = [[AVAssetWriterInput alloc] initWithMediaType: AVMediaTypeAudio outputSettings: d_audio_stream_settings];
		d_video_stream.expectsMediaDataInRealTime = d_audio_stream.expectsMediaDataInRealTime = YES;
		d_video_stream.mediaTimeScale = 600;
	}
	
	if (!d_video_stream_settings) {
		d_video_stream_settings = [NSDictionary dictionaryWithObjectsAndKeys: AVVideoCodecH264, AVVideoCodecKey, [NSNumber numberWithInt: D_CAMERA_RECODER_FRAME_WIDTH], AVVideoWidthKey, [NSNumber numberWithInt: D_CAMERA_RECODER_FRAME_HEIGHT], AVVideoHeightKey, nil];
	}
	
	if ([d_stream_file canApplyOutputSettings: d_video_stream_settings forMediaType: AVMediaTypeVideo]) {
		if (d_stream_file && d_video_stream && ([d_stream_file canAddInput: d_video_stream])) {
			[d_stream_file addInput: d_video_stream];
			d_stream_buffer = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput: d_video_stream sourcePixelBufferAttributes: d_option_stream_settings];
		} else {
			[self stream_video_destroy];
		}
	}
	
	if ([d_stream_file canApplyOutputSettings: d_audio_stream_settings forMediaType: AVMediaTypeAudio]) {
		if ([d_stream_file canAddInput: d_audio_stream]) {
			[d_stream_file addInput: d_audio_stream];
		} else {
			[self stream_audio_destroy];
		}
	}
	
	if ((d_video_stream == nil) && (d_audio_stream == nil)) {
		[self stream_all_destroy];
		return;
	}
	
	d_stream_is_running = YES;
	if ([d_stream_file startWriting]) {
		if (d_stream_file.status != AVAssetWriterStatusWriting) {
			[d_stream_file cancelWriting];
			[self stream_all_destroy];
			return;
		} else {
			[d_stream_file startSessionAtSourceTime: CMTimeMake(0, d_video_stream.mediaTimeScale)];
			d_stream_time = CFAbsoluteTimeGetCurrent();
		}
	} else {
		[self stream_all_destroy];
		return;
	}
}


- (void) stream_video: (UIImage *) image {
	if (!d_stream_is_running || !image) {
		return;
	}
	
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	if (d_video_stream.readyForMoreMediaData) {
		CGSize size;
		CVPixelBufferRef buffer = nil;
		if (d_stream_size.width < D_CAMERA_RECODER_MIN_RESOLUTION_WIDTH) {
			size = CGSizeMake(D_CAMERA_RECODER_FRAME_WIDTH, D_CAMERA_RECODER_FRAME_HEIGHT);
		} else {
			size = d_stream_size;
		}
		CVReturn status = CVPixelBufferCreate(NULL, size.width, size.height, kCVPixelFormatType_32ARGB, (CFDictionaryRef) d_option_stream_settings, &buffer);
		NSParameterAssert (status == kCVReturnSuccess && buffer != NULL);
		CVPixelBufferLockBaseAddress(buffer, 0);
		void *data = CVPixelBufferGetBaseAddress(buffer);
		NSParameterAssert (data != NULL);
		CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
		CGContextRef c = CGBitmapContextCreate(data, size.width, size.height, 8, 4 * size.width, space, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
		CGContextConcatCTM(c, CGAffineTransformMakeRotation(0));
		CGContextDrawImage(c, CGRectMake(0, 0, CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage)), image.CGImage);
		CGColorSpaceRelease(space);
		CGContextRelease(c);
		CVPixelBufferUnlockBaseAddress(buffer, 0);
		BOOL appended = [d_stream_buffer appendPixelBuffer: buffer withPresentationTime: CMTimeMake((CFAbsoluteTimeGetCurrent() - d_stream_time) * d_video_stream.mediaTimeScale, d_video_stream.mediaTimeScale)];
		CVBufferRelease(buffer);
		if (!appended) {
			[self stream_stop];
		}
	}
	
	[p release];
}

#define D_CAMERA_RECODER_ERROR(status) if (status != kCMBlockBufferNoErr) {printf ("status error : %s and error code : %lu", #status, status);}
- (void) stream_audio: (const void *)data length: (int) len {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	if (!d_stream_is_running || !data || !len) {
		return;
	}
	NSLog(@"stream_audio %d",len);
	if (d_audio_stream.readyForMoreMediaData) {
		CMBlockBufferRef			block_buffer;
		CMSampleBufferRef			sample_buffer;
		CMAudioFormatDescriptionRef audio_format;
		
		int number = len / 2;
		CMTime time = CMTimeMakeWithSeconds(number / 8000.0, 1);
		const AudioStreamPacketDescription packet = {0, number, len};
		if (d_audio_stream.readyForMoreMediaData) {
			OSStatus block_buffer_create_status		= CMBlockBufferCreateWithMemoryBlock(NULL, NULL, len, NULL, NULL, 0, len, kCMBlockBufferAssureMemoryNowFlag, &block_buffer);
			OSStatus block_buffer_repalce_status	= CMBlockBufferReplaceDataBytes(data, block_buffer, 0, len);
			OSStatus audio_format_status			= CMAudioFormatDescriptionCreate(NULL, &asbd, 0, NULL, 0, NULL, NULL,  &audio_format);
			OSStatus audio_sample_buffer_status		= CMAudioSampleBufferCreateWithPacketDescriptions(NULL, block_buffer, YES, NULL, NULL, audio_format, number, time, &packet, &sample_buffer);
			
			if (!sample_buffer) {
				CFRelease(block_buffer);
				CFRelease(audio_format);
				return;
			} else {
				OSStatus append_sample = [d_audio_stream appendSampleBuffer:sample_buffer];
				append_sample = ! append_sample;
				CFRelease(sample_buffer);
				CFRelease(block_buffer);
				CFRelease(audio_format);
				
				D_CAMERA_RECODER_ERROR (block_buffer_create_status);
				D_CAMERA_RECODER_ERROR (block_buffer_repalce_status);
				D_CAMERA_RECODER_ERROR (audio_format_status);
				D_CAMERA_RECODER_ERROR (audio_sample_buffer_status);
				D_CAMERA_RECODER_ERROR (append_sample);
			}
		}
	}
	
	[p release];
}


- (void) stream_stop {
	d_stream_is_running = NO;
	[d_stream_file finishWriting];
	
	[self stream_all_destroy];
	
	NSString *path = get_file_path(D_CAMERA_RECODER_MOV);
	if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
		UISaveVideoAtPathToSavedPhotosAlbum(path, self, nil, nil);
	} else {
		NSLog(@"cannt support mov");
	}
	
	path = nil;
}


- (void) dealloc {
	[super dealloc];
}

@end

//
//  camera_stream_mange.h
//  g_ipcamera_play
//
//  Created by dengyouhua on 12-2-17.
//  Copyright 2012 415137038@qq.com. All rights reserved.
//

//#import <Foundation/Foundation.h>

FOUNDATION_EXPORT camera_recorder_cell *camera_stream;

FOUNDATION_EXPORT void camera_stream_begin (int width, int height);
FOUNDATION_EXPORT void camera_stream_video (UIImage * image);
FOUNDATION_EXPORT void camera_stream_audio (const void *data, int data_len);
FOUNDATION_EXPORT void camera_stream_end ();

//
//  camera_stream_mange.m
//  g_ipcamera_play

//
//  Created by dengyouhua on 12-2-17.
//  Copyright 2012 415137038@qq.com. All rights reserved.
//

//#import "camera_stream_mange.h"


static BOOL stream_sync = NO;
camera_recorder_cell *camera_stream = nil;

void camera_stream_begin (int width, int height) {
	if (width < D_CAMERA_RECODER_MIN_RESOLUTION_WIDTH || height < D_CAMERA_RECODER_MIN_RESOLUTION_HEIGHT) {
		return;
	}
	
	stream_sync = NO;
	if (camera_stream) {
		[camera_stream release];
		camera_stream = nil;
	} else {
		camera_stream = [[camera_recorder_cell alloc] init];
		[camera_stream stream_update_settings: width height: height];
		camera_stream.d_stream_size = CGSizeMake(width, height);
		[camera_stream stream_start];
	}
}

void camera_stream_video (UIImage * image) {
	if (camera_stream && camera_stream.d_stream_is_running) {
		[camera_stream stream_video: image];
		stream_sync = YES;
	}
}

void camera_stream_audio (const void *data, int data_len) {
    //	if (!data || (data_len != 640)) {
    //		return;
    //	}
	//NSLog(@"youhua test");
	
	if (camera_stream && camera_stream.d_stream_is_running) {
		if (stream_sync) {
			[camera_stream stream_audio:data length:data_len];
		} else {
			return;
		}
	}
}

void camera_stream_end () {
	if (camera_stream) {
		[camera_stream stream_stop];
		[camera_stream release];
		camera_stream = nil;
		stream_sync = NO;
	}
}

