//
//  PlaybackViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//
#define RECORD_PLAY_WAIT_TIMEOUT 18

#import "Playback_HichipViewController.h"
#import <IOTCamera/Monitor.h>
#import "HichipCamera.h"
#import "PlayView.h"
#import "ZKGangTimeBar.h"
#import "CameraIOSessionProtocol.h"
#import "VideoProgressBarView.h"

@interface Playback_HichipViewController ()<VideoProgressBarDelegate>{
    BOOL waitResize;
    long totalSeconds;
}

@property (weak, nonatomic) IBOutlet VideoProgressBarView *videoProgressbar;
@property (nonatomic, strong) PlayView *playView;
@property (nonatomic, assign) long playTime;
@property (nonatomic, assign) long firstPlayTime;
@property (nonatomic, assign) BOOL isFirstPlayTime;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isEndingFlag;
@property (nonatomic, assign) BOOL isDraging;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_loading;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview_video;
@property (weak, nonatomic) IBOutlet UIImageView *monitor;
@property (weak, nonatomic) IBOutlet UILabel *labEventType;
@property (weak, nonatomic) IBOutlet UILabel *labEventTime;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *constraint_ratio_videowrapper;
@property (nonatomic,copy) dispatch_block_t timeoutTask;
@property (nonatomic,strong) HichipCamera *originCamera;
@property (nonatomic,strong) ZKGangTimeBar* ZKGangBar;
@end

IB_DESIGNABLE
@implementation Playback_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    totalSeconds = self.evt.eventEndTime - self.evt.eventTime;
    self.title = self.camera.nickName;
    self.originCamera = (HichipCamera*)self.camera.orginCamera;
    int days=((int)totalSeconds)/(3600*24);
    int hours = ((int)totalSeconds)%(3600*24)/3600;
    int minutes = ((int)totalSeconds)%(3600*24)%3600/60;
    int seconds = ((int)totalSeconds)%(3600*24)%3600%60;
    if (days > 0) {
        self.totalTime=[[NSString alloc] initWithFormat:@"%02d:%02d:%02d:%02d",days,hours,minutes,seconds];
    }else{
        self.totalTime=[[NSString alloc] initWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }
    //[self.view addSubview:[[NSBundle mainBundle] loadNibNamed:@"SliderTableViewCell" owner:self options:Nil][0]];
//    [self.view addSubview:self.playView];
    [self.view addSubview:self.ZKGangBar];
    self.videoProgressbar.delegate = self;
    [self.videoProgressbar setFrame:self.videoProgressbar.frame];
    [self.videoProgressbar setTime:self.evt.eventTime start:self.evt.eventTime end:self.evt.eventEndTime];
    [self setup];
}

- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didClickPlayButton:(UIButton*)btn{
    
}
- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didClickExitButton:(UIButton*)btn{
    
}
- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didEndSliderChanging:(UISlider*)sender time:(long)time{
    
}
- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didSliderChanging:(UISlider*)sender time:(long)time{
    
}

- (void)VideoProgressBarView:(VideoProgressBarView *)progressBar didClickSlider:(UISlider*)sender time:(long)time{
    
}
-(void)setup{
    [self.playView.sliderProgress addTarget:self action:@selector(youMoveDrag:) forControlEvents:UIControlEventValueChanged];
    _isFirstPlayTime = YES;
    _isPlaying = NO;
    _isEndingFlag = NO;
    _isDraging = NO;
    [self.originCamera SetImgview:self.monitor];
    if (self.originCamera.gmTimeZone && self.originCamera.gmTimeZone.u32DstMode == 1) {
        if (![self.camera getCommandFunction:HI_P2P_PB_QUERY_START_NODST]) {
            self.evt.eventTime -= 60*60;
        }
        NSLog(@"turn_on_summer_time.");
    } else {
        NSLog(@"turn_off_summer_time.");
    }
    waitResize = YES;
     _playTime = self.evt.eventEndTime - self.evt.eventTime;
    _labEventType.text = [Event getEventTypeName:self.evt.eventType];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.evt.eventTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    _labEventTime.text = [dateFormatter stringFromDate:date];
    __weak typeof(self) wself = self;
    self.playView.playBlock = ^(NSInteger type, CGFloat value) {
        if (type == 0) {
            if (wself.isEndingFlag) {
                
                STimeDay stime = [Event getHiTimeDay:wself.evt.eventTime];
                [wself.originCamera SetImgview:wself.monitor];
                //                [wself.camera startPlayback:&stime Monitor:wself.monitor];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [wself.originCamera startPlayback2:stime Monitor:nil];
                });
                
            }
            else {
                if (wself.isPlaying) {
                    
                    //暂停时，发送暂停继续播放，做完任何操作都需要发送stop
                    HI_P2P_S_PB_PLAY_REQ* req = (HI_P2P_S_PB_PLAY_REQ*)malloc(sizeof(HI_P2P_S_PB_PLAY_REQ));
                    if(req){
                        memset(req, 0, sizeof(HI_P2P_S_PB_PLAY_REQ));
                        req->command = HI_P2P_PB_PAUSE;
                        req->u32Chn = 0;
                        STimeDay st = [Event getHiTimeDay:wself.evt.eventTime];
                        memcpy(&req->sStartTime, &st, sizeof(STimeDay));
                        [wself.originCamera sendIOCtrl:HI_P2P_PB_PLAY_CONTROL Data:(char *)req Size:sizeof(HI_P2P_S_PB_PLAY_REQ)];
                        
                        free(req);
                        req = nil;
                    }
                    
                }
                else {
                    HI_P2P_S_PB_PLAY_REQ* req = (HI_P2P_S_PB_PLAY_REQ*)malloc(sizeof(HI_P2P_S_PB_PLAY_REQ));
                    if(req){
                        memset(req, 0, sizeof(HI_P2P_S_PB_PLAY_REQ));
                        req->command = HI_P2P_PB_PAUSE;
                        req->u32Chn = 0;
                        STimeDay st = [Event getHiTimeDay:wself.evt.eventTime];
                        memcpy(&req->sStartTime, &st, sizeof(STimeDay));
                        
                        [wself.originCamera sendIOCtrl:HI_P2P_PB_PLAY_CONTROL Data:(char *)req Size:sizeof(HI_P2P_S_PB_PLAY_REQ)];
                        
                        free(req);
                        req = nil;
                    }
                }
                
                wself.isPlaying = !wself.isPlaying;
                
            }
            
            
        }
        
        
        if (type == 1) {
            [wself.originCamera stopPlayback];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [wself.originCamera RemImgview];
                [wself.navigationController popViewControllerAnimated:YES];
            });
            
            //            HI_P2P_S_PB_PLAY_REQ* req = (HI_P2P_S_PB_PLAY_REQ*)malloc(sizeof(HI_P2P_S_PB_PLAY_REQ));
            //            memset(req, 0, sizeof(HI_P2P_S_PB_PLAY_REQ));
            //            req->command = HI_P2P_PB_STOP;
            //            req->u32Chn = 0;
            //            STimeDay st = [VideoInfo getTimeDay:wself.video.startTime];
            //            memcpy(&req->sStartTime, &st, sizeof(STimeDay));
            //
            //            [wself.camera sendIOCtrl:HI_P2P_PB_PLAY_CONTROL Data:(char *)req Size:sizeof(HI_P2P_S_PB_PLAY_REQ)];
            //
            //            free(req);
            
            
            
        }
        
        
        if (type == 2) {//远程回放拖动结束
            NSLog(@"拖动结束");
            [UIView animateWithDuration:.35 animations:^{
                wself.ZKGangBar.alpha = 0;
            }];
            //[wself pause];
            //wself.isDraging = YES;
            
            if (!wself.isPlaying) {
                STimeDay stime = [Event getHiTimeDay:wself.evt.eventTime];
                [wself.originCamera SetImgview:wself.monitor];
                //                 [wself.camera startPlayback:&stime Monitor:wself.monitor];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [wself.originCamera startPlayback2:stime Monitor:nil];
                });
                
            }
            
            HI_P2P_PB_SETPOS_REQ* req = (HI_P2P_PB_SETPOS_REQ*)malloc(sizeof(HI_P2P_PB_SETPOS_REQ));
            if(req){
                STimeDay st = [Event getHiTimeDay:wself.evt.eventTime];
                memcpy(&req->sStartTime, &st, sizeof(STimeDay));
                req->s32Pos = (HI_S32)value;
                req->u32Chn = 0;
                [wself.originCamera sendIOCtrl:HI_P2P_PB_POS_SET Data:(char *)req Size:sizeof(HI_P2P_PB_SETPOS_REQ)];
                
                free(req);
                req = nil;
                //[wself pause];
            }
        }
        
        
        if (type == 3) {
            wself.isDraging = YES;
        }
        
    };
    [self resizeMonitor:self.camera.videoRatio];
    [self startPlayback];
}
-(void)youMoveDrag:(UISlider* )slider{
    [UIView animateWithDuration:.35 animations:^{
        self.ZKGangBar.alpha = 1;
    }];
    int current = totalSeconds*(slider.value/100);
    NSString* currentStr = [NSString stringWithFormat:@"%02d:%02d:%02d",current/3600,current%3600/60,current%60];
    self.ZKGangBar.time.text = [NSString stringWithFormat:@"%@ / %@",currentStr,self.totalTime];
}
- (PlayView *)playView {
    if (!_playView) {
        
        CGFloat WIDTH = [UIScreen mainScreen].bounds.size.height;
        CGFloat HEIGHT = [UIScreen mainScreen].bounds.size.width;//WIDTH/1.5;
        CGFloat h = 50.0f;//WIDTH/1.5;
        
        _playView = [[PlayView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, h)];
        _playView.center = CGPointMake(WIDTH/2, HEIGHT-h/2);
    }
    return _playView;
}

-(ZKGangTimeBar* )ZKGangBar{
    if (!_ZKGangBar) {
        _ZKGangBar = [[ZKGangTimeBar alloc]initWithFrame:CGRectMake(0, 0, 180, 65)];
        _ZKGangBar.barStyle = 1;
        _ZKGangBar.center = self.monitor.center;
        _ZKGangBar.alpha = 0;
    }
    return _ZKGangBar;
}

-(dispatch_block_t)timeoutTask{
    if(_timeoutTask == nil){
        _timeoutTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            if(self.camera.isAuthConnected){
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.originCamera startPlayback2: [Event getHiTimeDay:self.evt.eventTime] Monitor:nil];
    });
//    HI_P2P_PB_SETPOS_REQ* req = (HI_P2P_PB_SETPOS_REQ*)malloc(sizeof(HI_P2P_PB_SETPOS_REQ));
//    if(req){
//        STimeDay st = [Event getHiTimeDay:self.evt.eventTime];
//        memcpy(&req->sStartTime, &st, sizeof(STimeDay));
//        req->s32Pos = (HI_S32)0;
//        req->u32Chn = 0;
//        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_PB_POS_SET Data:(char *)req DataSize:sizeof(HI_P2P_PB_SETPOS_REQ)];
//        
//        free(req);
//        req = nil;
//        //[wself pause];
//    }
}

- (void)camera:(BaseCamera *)camera _didReceivePlayState:(NSInteger)state witdh:(NSInteger)w height:(NSInteger)h{
    if (state == PLAY_STATE_EDN) {
        NSLog(@"PLAY_STATE_EDN");
        _isEndingFlag = YES;
        [self.originCamera stopPlayback];
        self.isPlaying = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.playView.btnPlay.selected = YES;
            self.playView.sliderProgress.value = self.playView.sliderProgress.maximumValue;
            [[iToast makeText:LOCALSTR(@"Video play ends")] show];
             [self refreshButton];
        });
    }
    else if(state == PLAY_STATE_START){
        self.isPlaying = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(_needCreateSnapshot && _monitor.image){
                _needCreateSnapshot = NO;
                [GBase saveRemoteRecordPictureForCamera:self.camera image:_monitor.image eventType:self.evt.eventType eventTime:self.evt.eventTime];
            }
            if(fabs(self.camera.videoRatio-(CGFloat)w/h) > 0.2){
                self.camera.videoRatio = (CGFloat)w/h;
                [self resizeMonitor:self.camera.videoRatio];
                
            }
            [self refreshButton];
        });
    }
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self disconnect];
}

-(void)disconnect{
   // [self.monitor deattachCamera];
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
        _timeoutTask = nil;
    }
    [self doEndPlayback];
    [self refreshButton];
}

-(void)doEndPlayback{
    [self.originCamera stopPlayback];
}


-(void)refreshButton{
    if(self.isPlaying){
        [self.indicator_loading setHidden:YES];
        [_btnPlay setImage:[UIImage imageNamed:@"ic_menu_pause"] forState:UIControlStateNormal];
    }
    else{
        [_btnPlay setImage:[UIImage imageNamed:@"ic_menu_play"] forState:UIControlStateNormal];
        [self.indicator_loading setHidden:NO];
    }
}
- (IBAction)clickPlay:(id)sender {
    if(!self.isPlaying){
        [self startPlayback];
        [_btnPlay setImage:[UIImage imageNamed:@"ic_menu_pause"] forState:UIControlStateNormal];
    }
    else{
        [self doPausePlayback];
    }
}

-(void)doPausePlayback{
    //暂停时，发送暂停继续播放，做完任何操作都需要发送stop
    HI_P2P_S_PB_PLAY_REQ* req = (HI_P2P_S_PB_PLAY_REQ*)malloc(sizeof(HI_P2P_S_PB_PLAY_REQ));
    if(req){
        memset(req, 0, sizeof(HI_P2P_S_PB_PLAY_REQ));
        req->command = HI_P2P_PB_PAUSE;
        req->u32Chn = 0;
        STimeDay st = [Event getHiTimeDay:self.evt.eventTime];
        memcpy(&req->sStartTime, &st, sizeof(STimeDay));
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_PB_PLAY_CONTROL Data:(char *)req DataSize:sizeof(HI_P2P_S_PB_PLAY_REQ)];
        free(req);
        req = nil;
    }
}

- (void)camera:(BaseCamera *)camera _didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount{
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
             if(self.isPlaying){
                 [self.indicator_loading setHidden:NO];
             }
        }
    });
}

- (void)camera:(BaseCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    if(status == CONNECTION_STATE_TIMEOUT){
        [self disconnect];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self startPlayback];
        });
       
    }
    
}

- (void)camera:(BaseCamera *)camera _didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status{
    if(camera.isAuthConnected){
        [self startPlayback];
    }
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
