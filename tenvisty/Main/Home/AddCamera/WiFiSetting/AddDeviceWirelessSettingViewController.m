//
//  AddDeviceWirelessSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/12.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#define SMART_WIFI_TIME (60)
#import "AddDeviceWirelessSettingViewController.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "WiFiConfigContext.h"

@interface AddDeviceWirelessSettingViewController ()<WiFiConfigDelegate>{
    
}
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *gifView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_left_pop;
@property (weak, nonatomic) IBOutlet UILabel *labProcess;
@property (nonatomic,strong) NSTimer* pTimer;
@end

@implementation AddDeviceWirelessSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"configwifi_setting" withExtension:@"gif"];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    self.gifView.animatedImage = animatedImage1;
    self.progressView.progress = .0;
//    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
//    self.progressView.transform = transform;
    [[WiFiConfigContext sharedInstance] setData:self.wifiSsid password:self.wifiPassword auth:self.wifiAuthMode];
    [[WiFiConfigContext sharedInstance] setReceiveListner:self];
    [self setTimerInterval:SMART_WIFI_TIME/100.0f];
    
    // Do any additional setup after loading the view.
}
-(void)setTimerInterval:(NSTimeInterval)interval{
    if (self.progressView.progress < 1) {
        if( self.pTimer != nil){
            [self.pTimer invalidate];
        }
        self.pTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(progressMethod:) userInfo:nil repeats:YES];
    }
    else{
        [[WiFiConfigContext sharedInstance] stopConfig];
    }
}

- (void)progressMethod : (id)sender {
     self.progressView.progress += 0.01f;
    self.labProcess.text = [NSString stringWithFormat:@"%d%%",(int)(self.progressView.progress*100)];
    self.constraint_left_pop.constant -= self.progressView.frame.size.width / 100.0f;
    if(self.progressView.progress >= 1){
        [self.pTimer invalidate];
    }
}

-(void)onReceived:(NSString *)status ip:(NSString*) ip uid:(NSString*)uid{
    if([self.uid isEqualToString:NO_USE_UID] || [self.uid isEqualToString:uid]){
        [self go2List];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[WiFiConfigContext sharedInstance] startConfig];
    
}

-(void)go2List{
    [self stopConfig];
    [self performSegueWithIdentifier:@"AddDeviceWirelessSetting2CameraList" sender:self];
}

-(void)go2Search{
    [self stopConfig];
    [self performSegueWithIdentifier:@"AddDeviceWirelessSetting2SearchCamera" sender:self];
}

-(void)stopConfig{
    if([[WiFiConfigContext sharedInstance] isRunning]){
        [[WiFiConfigContext sharedInstance] stopConfig];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
