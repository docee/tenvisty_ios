//
//  PlaybackViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#define MEDIA_STATE_STOPPED 0
#define MEDIA_STATE_PLAYING 1
#define MEDIA_STATE_PAUSED 2
#define MEDIA_STATE_OPENING 3
#define RECORD_PLAY_WAIT_TIMEOUT 18

#import "PlaybackViewController.h"
#import <IOTCamera/Monitor.h>

@interface PlaybackViewController (){
    NSInteger mMediaState;
    NSInteger mPlaybackChannel;
    BOOL waitResize;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_loading;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview_video;
@property (weak, nonatomic) IBOutlet Monitor *monitor;
@property (weak, nonatomic) IBOutlet UILabel *labEventType;
@property (weak, nonatomic) IBOutlet UILabel *labEventTime;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *constraint_ratio_videowrapper;
@property (nonatomic,copy) dispatch_block_t timeoutTask;
@end

@implementation PlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

-(void)setup{
    self.title = self.camera.nickName;
    waitResize = YES;
    mPlaybackChannel = -1;
    mMediaState = MEDIA_STATE_STOPPED;
    _labEventType.text = [Event getEventTypeName:self.evt.eventType];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.evt.eventTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    _labEventTime.text = [dateFormatter stringFromDate:date];
    [self resizeMonitor:self.camera.videoRatio];
    [self startPlayback];
}
-(dispatch_block_t)timeoutTask{
    if(_timeoutTask == nil){
        _timeoutTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            if(self.camera.connectState == CONNECTION_STATE_CONNECTED){
                [self startPlayback];
            }
            else{
                [TwsTools presentAlertMsg:self message:LOCALSTR(@"Camera offline")];
            }
        });
    }
    return _timeoutTask;
}
-(dispatch_block_t)newTimeoutTask{
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
    }
    _timeoutTask = nil;
    return self.timeoutTask;
}
-(void)startPlayback{
    mMediaState = MEDIA_STATE_OPENING;
    [self.indicator_loading setHidden:NO];
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
        _timeoutTask = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RECORD_PLAY_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    [self refreshButton];
    [self doStartPlayback];
}
-(void)doStartPlayback{
    SMsgAVIoctrlPlayRecord *req = malloc(sizeof(SMsgAVIoctrlPlayRecord));
    req->channel = 0;
    req->command = AVIOCTRL_RECORD_PLAY_START;
    req->Param = 0;
    req->stTimeDay = [Event getTimeDay:self.evt.eventTime];
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL Data:(char*)req DataSize:sizeof(SMsgAVIoctrlPlayRecord)];
    free(req);
}

#pragma mark - MyCameraDelegate Methods
- (void)camera:(MyCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char *)data DataSize:(NSInteger)size
{
    if (type == IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL_RESP) {
        SMsgAVIoctrlPlayRecordResp *resp = (SMsgAVIoctrlPlayRecordResp *)data;
        switch (resp->command) {
            case AVIOCTRL_RECORD_PLAY_START:{
                if(mMediaState == MEDIA_STATE_OPENING){
                    if(resp->result >= 0 && resp->result <= 31){
                        mMediaState = MEDIA_STATE_PLAYING;
                        mPlaybackChannel = resp->result;
                        [self.camera start:mPlaybackChannel];
                        [self refreshButton];
                    }
                }
                break;
            }
            case AVIOCTRL_RECORD_PLAY_PAUSE:{
                if(mPlaybackChannel > 0){
                    if(mMediaState == MEDIA_STATE_PAUSED){
                        mMediaState = MEDIA_STATE_PLAYING;
                        [self.monitor attachCamera:self.camera];
                    }
                    else if(mMediaState == MEDIA_STATE_PLAYING){
                        mMediaState = MEDIA_STATE_PAUSED;
                        [self.monitor deattachCamera];
                    }
                    [self refreshButton];
                }
                break;
            }
            case AVIOCTRL_RECORD_PLAY_STOP:{
                if(mPlaybackChannel > 0){
                    [self.camera stop:mPlaybackChannel];
                    [self.monitor deattachCamera];
                }
                mPlaybackChannel = -1;
                mMediaState = MEDIA_STATE_STOPPED;
                [self refreshButton];
                break;
            }
            case AVIOCTRL_RECORD_PLAY_END:{
                if(mPlaybackChannel > 0){
                    [self.camera stop:mPlaybackChannel];
                    [self.monitor deattachCamera];
                    [self doEndPlayback];
                }
                [[iToast makeText:LOCALSTR(@"Video play ends")] show];
                mPlaybackChannel = -1;
                mMediaState = MEDIA_STATE_STOPPED;
                [self refreshButton];
                break;
            }
                
            default:
                break;
        }
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self disconnect];
}

-(void)disconnect{
    mMediaState = MEDIA_STATE_STOPPED;
    [self.monitor deattachCamera];
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
        _timeoutTask = nil;
    }
    if(mPlaybackChannel > 0){
        
//        [self.camera stop:mPlaybackChannel];
//        [self doEndPlayback];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.camera stop:mPlaybackChannel];
            [self doEndPlayback];
            mPlaybackChannel = -1;
        });
    }
    [self refreshButton];
}

-(void)doEndPlayback{
    SMsgAVIoctrlPlayRecord *req = malloc(sizeof(SMsgAVIoctrlPlayRecord));
    req->channel = 0;
    req->command = AVIOCTRL_RECORD_PLAY_STOP;
    req->Param = 0;
    req->stTimeDay = [Event getTimeDay:self.evt.eventTime];
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL Data:(char*)req DataSize:sizeof(SMsgAVIoctrlPlayRecord)];
    free(req);
}


-(void)refreshButton{
    if(mMediaState == MEDIA_STATE_STOPPED || mMediaState == MEDIA_STATE_PAUSED){
        [self.indicator_loading setHidden:YES];
        [_btnPlay setImage:[UIImage imageNamed:@"ic_menu_play"] forState:UIControlStateNormal];
    }
    else{
        [_btnPlay setImage:[UIImage imageNamed:@"ic_menu_pause"] forState:UIControlStateNormal];
        [self.indicator_loading setHidden:NO];
    }
}
- (IBAction)clickPlay:(id)sender {
    if(mPlaybackChannel < 0){
        if(mMediaState == MEDIA_STATE_STOPPED){
            [self startPlayback];
        }
        [_btnPlay setImage:[UIImage imageNamed:@"ic_menu_pause"] forState:UIControlStateNormal];
    }
    else{
        [self doPausePlayback];
    }
}

-(void)doPausePlayback{
    SMsgAVIoctrlPlayRecord *req = malloc(sizeof(SMsgAVIoctrlPlayRecord));
    req->channel = 0;
    req->command = AVIOCTRL_RECORD_PLAY_PAUSE;
    req->Param = 0;
    req->stTimeDay = [Event getTimeDay:self.evt.eventTime];
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL Data:(char*)req DataSize:sizeof(SMsgAVIoctrlPlayRecord)];
    free(req);
}

- (void)camera:(NSCamera *)camera _didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(fps > 1){
            [self.indicator_loading setHidden:NO];
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
           
            [self.indicator_loading setHidden:YES];
        }
        else{
             if(mMediaState == MEDIA_STATE_OPENING || mMediaState == MEDIA_STATE_PLAYING){
                 [self.indicator_loading setHidden:NO];
             }
        }
    });
}

- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    if(status == CONNECTION_STATE_TIMEOUT){
        [self disconnect];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self startPlayback];
        });
       
    }
    
}

- (void)camera:(NSCamera *)camera _didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status{
    if(status == CONNECTION_STATE_CONNECTED){
        if(mPlaybackChannel > 0 && mPlaybackChannel == channel){
            [self.camera startShow:mPlaybackChannel];
            [self.camera startAudio:mPlaybackChannel];
            [self.monitor attachCamera:self.camera];
        }
        else if(channel == 0){
            [self startPlayback];
        }
    }
}

- (void)camera:(NSCamera *)camera _didReceiveRawDataFrame:(const char *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height{
    if(_needCreateSnapshot && _monitor.image){
        _needCreateSnapshot = NO;
        [GBase saveRemoteRecordPictureForCamera:self.camera image:_monitor.image eventType:self.evt.eventType eventTime:self.evt.eventTime];
    }
    if(fabs(self.camera.videoRatio-(CGFloat)width/height) > 0.2){
        self.camera.videoRatio = (CGFloat)width/height;
        [self resizeMonitor:self.camera.videoRatio];
        
    }
//    if(waitResize){
//        waitResize = NO;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.scrollview_video.translatesAutoresizingMaskIntoConstraints = YES;
//            if(fabs(self.scrollview_video.frame.size.width/self.scrollview_video.frame.size.height - width/height) > 0.2){
//                __block CGRect currentframe = self.scrollview_video.frame;
//                __weak typeof(self) weakSelf = self;
//                [UIView animateWithDuration:0.3 animations:^{
//                    currentframe.size.height = currentframe.size.width * height/width;
//                    weakSelf.scrollview_video.frame = CGRectMake(currentframe.origin.x, currentframe.origin.y, currentframe.size.width, currentframe.size.height);
//                }];
//            }
//        });
//    }
}

-(void)resizeMonitor:(CGFloat)ratio{
    NSLayoutConstraint *existConstraint = nil;
    for(NSLayoutConstraint *constraint in self.scrollview_video.constraints){
        if([constraint.identifier isEqualToString:@"videowrapper_ratio"]){
            existConstraint = constraint;
            break;
        }
    }
    
    //if(existConstraint == nil){
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                       constraintWithItem:self.scrollview_video //子试图
                                       attribute:NSLayoutAttributeWidth //子试图的约束属性
                                       relatedBy:0 //属性间的关系
                                       toItem:self.scrollview_video//相对于父试图
                                       attribute:NSLayoutAttributeHeight//父试图的约束属性
                                       multiplier:ratio
                                       constant:0.0];// 固定距离
    myConstraint.identifier = @"videowrapper_ratio";
    [self.scrollview_video removeConstraint:existConstraint];//在父试图上将iSinaButton距离屏幕左边的约束删除
    [self.scrollview_video addConstraint: myConstraint];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
