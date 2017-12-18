//
//  LiveViewController.m
//  tenvisty
//
//  Created by lu yi on 12/3/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#define ISFULLSCREEN self.view.bounds.size.width > self.view.bounds.size.height

#import "LiveViewController.h"
#import <IOTCamera/Monitor.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "UIDevice+TFDevice.h"

@interface LiveViewController ()<MyCameraDelegate>{
    BOOL isTalking;
    BOOL isListening;
    BOOL isRecording;
    NSTimer *recordTimer;
    BOOL isShowingToolBtnsLand;
}
@property (weak, nonatomic) IBOutlet UIView *toolbtns_land;
@property (weak, nonatomic) IBOutlet UIView *connectStatus_port;
@property (weak, nonatomic) IBOutlet UIView *toolbtns_portrait;
@property (weak, nonatomic) IBOutlet UIView *video_wrapper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_status_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_videowrapper_height;
@property (nonatomic,assign) Boolean isFullscreen;
@property (weak, nonatomic) IBOutlet UILabel *labConnectState;
@property (weak, nonatomic) IBOutlet Monitor *videoMonitor;
@property (weak, nonatomic) IBOutlet UIButton *btnListen_port;
@property (weak, nonatomic) IBOutlet UIButton *btnListen_land;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord_port;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord_land;
@property (weak, nonatomic) IBOutlet UIView *viewRecordTime;
@property (weak, nonatomic) IBOutlet UILabel *labRecordTime;
@property (weak, nonatomic) IBOutlet UIView *viewLoading;
@property (weak, nonatomic) IBOutlet UIButton *btnTalk_land;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_toolbar_portrait_height;
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFullscreen = self.view.bounds.size.width > self.view.bounds.size.height;// self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight;
    [self rotateOrientation:_isFullscreen?UIInterfaceOrientationLandscapeLeft:UIInterfaceOrientationPortrait];
    [self setup];
    // Do any additional setup after loading the view.
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    
}

-(void)setup{
    self.title = self.camera.nickName;
}
- (IBAction)toggleBtnsLand:(UITapGestureRecognizer *)sender {
    if(ISFULLSCREEN){
        [self toggleTools:isShowingToolBtnsLand];
    }
}

-(void)toggleTools:(BOOL)hide{
    isShowingToolBtnsLand = !hide;
    [_toolbtns_land setHidden:!isShowingToolBtnsLand];
}

-(void)viewWillAppear:(BOOL)animated{
    self.camera.delegate2 = self;
    _labConnectState.text = [(self.camera) strConnectState];
    [_videoMonitor attachCamera:self.camera];
    [_viewLoading setHidden:NO];
    [self.camera startVideo];
    if(isListening){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.camera startAudio];
        });
    }
    
    [_btnRecord_land setEnabled:NO];
    [_btnRecord_port setEnabled:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    self.camera.delegate2 = nil;
    [_videoMonitor deattachCamera];
    [self stopRecord];
    [self.camera stopVideo];
    [self.camera stopSpeak];
    [self.camera stopAudio];
    if(_videoMonitor.image){
        [self.camera saveImage:_videoMonitor.image];
    }
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||

            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}



-(void) rotateOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    CGFloat width = Screen_Main.width>Screen_Main.height?Screen_Main.height:Screen_Main.width;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       
       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ){
        //[self.toolbtns_land setHidden:NO];
        //[self toggleTools:YES];
        [self.constraint_status_height setConstant:0];
        
        [self.constraint_toolbar_portrait_height setConstant:0];
        [self.toolbtns_portrait setHidden:YES];
        self.navigationController.navigationBar.hidden=YES;
        [self.constraint_videowrapper_height setConstant:width+300];
        _isFullscreen = YES;
        [_btnTalk_land setHidden:!isListening];
    }
    else{
        
        [self toggleTools:YES];
        [self.constraint_status_height setConstant:40];
        [self.constraint_toolbar_portrait_height setConstant:40];
        [self.toolbtns_portrait setHidden:NO];
        self.navigationController.navigationBar.hidden=NO;
        [self.constraint_videowrapper_height setConstant:width*9/16];
        _isFullscreen = NO;
      //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
}

- (BOOL)prefersStatusBarHidden {
    return _isFullscreen;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self rotateOrientation:toInterfaceOrientation];
    [self setNeedsStatusBarAppearanceUpdate];
    
}
- (IBAction)doSnapshot:(id)sender {
    BOOL success = [GBase savePictureForCamera:self.camera image:_videoMonitor.image];
    if(success){
        [TwsTools presentMessage:LOCALSTR(@"Snapshot Saved") atDeviceOrientation:DeviceOrientationPortrait];
    }
    else{
        [TwsTools presentMessage:LOCALSTR(@"Snapshot Failed") atDeviceOrientation:DeviceOrientationPortrait];
    }
}
- (IBAction)endTalk:(id)sender {
    [self.camera stopSpeak];
    if(isListening){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.camera startAudio];
        });
        [_btnListen_port setImage:[UIImage imageNamed:@"btnSound_opened_portrait"] forState:UIControlStateNormal];
        [_btnListen_land setImage:[UIImage imageNamed:@"btnSound_opened_portrait"] forState:UIControlStateNormal];
    }
    isTalking = NO;
}
- (IBAction)startTalk:(id)sender {
    //[self.camera stopAudio];
    if([self checkMicroPermission]){
        if(isListening){
            [self.camera stopAudio];
            [_btnListen_port setImage:[UIImage imageNamed:@"btnSound_pause_portrait"] forState:UIControlStateNormal];
            [_btnListen_land setImage:[UIImage imageNamed:@"btnSound_pause_portrait"] forState:UIControlStateNormal];
        }
        [self.camera startSpeak];
        isTalking = YES;
    }
}
- (IBAction)doRecord:(UIButton*)sender {
    _btnRecord_land.selected = !sender.selected;
    _btnRecord_port.selected = _btnRecord_land.selected;
    if (sender.selected) {
       NSString *recordNameString =  [GBase saveRecordingForCamera:self.camera];
        [self.camera startRecordVideo:recordNameString];
        [_viewRecordTime setHidden:NO];
        [_labRecordTime setText:@"00:00"];
        _labRecordTime.tag = 0;
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshRecordTime) userInfo:NULL repeats:YES];
    }else{
        [self.camera stopRecordVideo];
        [_viewRecordTime setHidden:YES];
        if(recordTimer){
            [recordTimer invalidate];
            recordTimer = nil;
        }
    }
    
}

-(void)refreshRecordTime{
    _labRecordTime.tag++;
    int second = _labRecordTime.tag % 60;
    
    int minute = (int)_labRecordTime.tag/60;
    
    [_labRecordTime setText:[NSString stringWithFormat:@"%@:%@",[NSString stringWithFormat:minute>9?@"%d":@"0%d",minute],[NSString stringWithFormat:second>9?@"%d":@"0%d",second]]];
}

- (IBAction)doFullScreen:(id)sender {
    [self rotateOrientation:UIInterfaceOrientationLandscapeLeft];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //调用横屏代码
    appDelegate.allowRotation = YES;//关闭横屏仅允许竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
}
- (IBAction)doListen:(UIButton*)sender {
    if(!isTalking){
        isListening = !isListening;
        if(isListening){
            [_btnListen_port setImage:[UIImage imageNamed:@"btnSound_opened_portrait"] forState:UIControlStateNormal];
            [_btnListen_land setImage:[UIImage imageNamed:@"btnSound_opened_portrait"] forState:UIControlStateNormal];
            [self.camera startAudio];
        }
        else{
            [_btnListen_port setImage:[UIImage imageNamed:@"btnSound_closed_portrait"] forState:UIControlStateNormal];
            [_btnListen_land setImage:[UIImage imageNamed:@"btnSound_closed_portrait"] forState:UIControlStateNormal];
            [self.camera stopAudio];
        }
    }
    [_btnTalk_land setHidden:!isListening];
}

- (IBAction)showSwitchQuality:(id)sender {
}
- (IBAction)goFolder:(id)sender {
}
- (IBAction)goEventList:(id)sender {
}
- (IBAction)showPreset:(id)sender {
}
- (IBAction)doPortraitView:(id)sender {
     [self rotateOrientation:UIInterfaceOrientationPortrait];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //调用横屏代码
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
}

- (BOOL)checkMicroPermission{
    BOOL result = NO;
    if(SystemVersion >= 8.0){
        AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
        switch (permissionStatus) {
            case AVAudioSessionRecordPermissionUndetermined:{
                NSLog(@"first use microphone, show distribute permission dialog");
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted){
                    if(granted){
                        
                    }else{
                        
                    }
                    
                }];
            }
                break;
            case AVAudioSessionRecordPermissionDenied:{
                NSLog(@"decline microphone permission");
                NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"%@ needs microphone permission.Please go to Settings->Privacy->Microphone->%@->re-enable Microphone (in your iphone or ipad).", @""),[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
                [TwsTools presentAlertTitle:self title:nil message:messageString alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
                    [TwsTools goPhoneSettingPage:@"microphone permission"];
                } actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
                
            }
                break;
            case AVAudioSessionRecordPermissionGranted:{
                NSLog(@"has microphone permission");
                result = YES;
            }
                break;
            default:
                
                break;
        }
    }
    else{
        result = YES;
    }
    return result;
}



//在试图将要已将出现的方法中
//- (void)viewDidAppear:(BOOL)animated{
//    
//    [super viewDidAppear:animated];
//    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        
//        //调用隐藏方法
//        [self prefersStatusBarHidden];
//        
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//        
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        _labConnectState.text = [((MyCamera*)camera) strConnectState];
    });
    if(self.camera.connectState == CONNECTION_STATE_CONNECTED){
        [self.camera startVideo];
    }
}

- (void)camera:(NSCamera *)camera _didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(fps > 1 ){
            [_viewLoading setHidden:YES];
            [_btnRecord_land setEnabled:YES];
            [_btnRecord_port setEnabled:YES];
        }
        else{
            [_viewLoading setHidden:NO];
            [_btnRecord_land setEnabled:NO];
            [_btnRecord_port setEnabled:NO];
            
        }
    });
}

-(void) stopRecord{
    if(recordTimer){
        [recordTimer invalidate];
    }
    [self.camera stopRecordVideo];
    [_viewRecordTime setHidden:YES];
}


@end
