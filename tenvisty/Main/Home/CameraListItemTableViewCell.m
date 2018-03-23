
//
//  CameraListItemTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/11/29.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "CameraListItemTableViewCell.h"
#import "BaseViewController.h"
#import "MyCamera.h"

@interface CameraListItemTableViewCell(){
   __weak BaseCamera *_camera;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_labConnectstate;
@property (weak, nonatomic) IBOutlet UIView *viewSnapshotMask;

@end

@implementation CameraListItemTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];

    [[self labCameraConnectState] setBackgroundColor:Color_GreenDark];
    [self.labCameraName setTextColor:Color_GrayDark];
    
    [self.btnCameraEvent setBackgroundImage:[UIImage imageWithColor:Color_Primary wihtSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [self.btnCameraEvent setBackgroundImage:[UIImage imageWithColor:Color_White_alpha wihtSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.btnCameraEvent setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] wihtSize:CGSizeMake(1, 1)] forState:UIControlStateDisabled];

    [self.btnCameraSetting setBackgroundImage:[UIImage imageWithColor:Color_Primary wihtSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [self.btnCameraSetting setBackgroundImage:[UIImage imageWithColor:Color_White_alpha wihtSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.btnCameraSetting setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] wihtSize:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
    
    [self.btnCameraDelete setBackgroundImage:[UIImage imageWithColor:Color_Primary wihtSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [self.btnCameraDelete setBackgroundImage:[UIImage imageWithColor:Color_White_alpha wihtSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.btnCameraDelete setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] wihtSize:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
    
    // Initialization code
}
- (IBAction)modifyCameraName:(UIButton *)sender {
    self.labCameraName.text = [NSString stringWithFormat:@"%@%@",self.labCameraName.text,@"s"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)test:(UIButton *)sender {
//    UIView *p = sender.superview;
//    int i=2;
//    while(p != nil){
//        if ([p isKindOfClass:[UIScrollView class]]) {
//            ((UIScrollView *)p).delaysContentTouches = NO;
//            i--;
//            if(i<=0){
//                break;
//            }
//        }
//        p = p.superview;
//        
//    }
}
- (IBAction)goSetting:(UIButton *)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:[self getSettingStoryboardName] bundle:nil];
    UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"storyboard_cameraSetting"];  //test2为viewcontroller的StoryboardId
    [sender.window.rootViewController.navigationController pushViewController:test2obj animated:YES];
}

-(id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self)
    {
        for (id obj in self.subviews)
        {
            if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *) obj;
                scroll.delaysContentTouches = NO;
                break;
            }
        }
    }
    return self;
}


-(void)setState:(NSInteger)state{
    if(!self.camera){
        return;
    }
     self.labCameraConnectState.text = self.camera.cameraStateDesc;
    if(self.camera.isConnecting || self.camera.processState != CAMERASTATE_NONE || self.camera.isWakingUp){
        [self.viewSnapshotMask setBackgroundColor:Color_Black_alpha_5];
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = Color_Primary;
        MBProgressHUD *p = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [p setColor:[UIColor clearColor]];
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        [self.btnReconnect setHidden:YES];
        [self.btnModifyPassword setHidden:YES];
        [self.btnPlay setHidden:YES];
        [self.btnWakeUp setHidden:YES];
        //self.labCameraConnectState.text = LOCALSTR(@"Connecting");
        [self.labCameraConnectState setBackgroundColor:Color_Primary];
        self.constraint_width_labConnectstate.constant = 75;
        [_btnCameraEvent setEnabled:NO];
        [_btnCameraSetting setEnabled:NO];
    }
    else{
        [MBProgressHUD hideAllHUDsForView:self animated:NO];
        if(self.camera.isAuthConnected){
            [self.viewSnapshotMask setBackgroundColor:Color_Black_alpha_2];
            [self.btnReconnect setHidden:YES];
            [self.btnModifyPassword setHidden:YES];
            [self.btnPlay setHidden:NO];
            [self.btnWakeUp setHidden:YES];
            //self.labCameraConnectState.text = LOCALSTR(@"Online");
            [self.labCameraConnectState setBackgroundColor:Color_GreenDark];
            [TwsViewTools setButtonContentCenter:self.btnPlay];
            self.constraint_width_labConnectstate.constant = 75;
            [_btnCameraEvent setEnabled:YES];
            [_btnCameraSetting setEnabled:YES];
        }
        else if(self.camera.isWrongPassword){
            LOG(@"wrong passwordsssss");
            [self.viewSnapshotMask setBackgroundColor:Color_Black_alpha_5];
            [self.btnReconnect setHidden:YES];
            [self.btnModifyPassword setHidden:NO];
            [self.btnPlay setHidden:YES];
            [self.btnWakeUp setHidden:YES];
            [TwsViewTools setButtonContentCenter:self.btnModifyPassword];
            //self.labCameraConnectState.text = LOCALSTR(@"Wrong Password");
            [self.labCameraConnectState setBackgroundColor:Color_GrayDark];
            self.constraint_width_labConnectstate.constant = 105;
            [_btnCameraEvent setEnabled:NO];
            [_btnCameraSetting setEnabled:NO];
        }
        else if(self.camera.isSleeping){
            LOG(@"sleeping");
            [self.viewSnapshotMask setBackgroundColor:Color_Black_alpha_5];
            [self.btnWakeUp setHidden:NO];
            [self.btnReconnect setHidden:YES];
            [self.btnModifyPassword setHidden:YES];
            [self.btnPlay setHidden:YES];
            [TwsViewTools setButtonContentCenter:self.btnWakeUp];
            //self.labCameraConnectState.text = LOCALSTR(@"Offline");
            [self.labCameraConnectState setBackgroundColor:Color_GrayDark];
            self.constraint_width_labConnectstate.constant = 75;
            [_btnCameraEvent setEnabled:NO];
            [_btnCameraSetting setEnabled:NO];
        }
        else{
            [self.viewSnapshotMask setBackgroundColor:Color_Black_alpha_5];
            [self.btnReconnect setHidden:NO];
            [self.btnModifyPassword setHidden:YES];
            [self.btnPlay setHidden:YES];
            [self.btnWakeUp setHidden:YES];
            [TwsViewTools setButtonContentCenter:self.btnReconnect];
            //self.labCameraConnectState.text = LOCALSTR(@"Offline");
            [self.labCameraConnectState setBackgroundColor:Color_GrayDark];
            self.constraint_width_labConnectstate.constant = 75;
            [_btnCameraEvent setEnabled:NO];
            [_btnCameraSetting setEnabled:NO];
        }
    }
}

-(void)refreshAlarmState{
    if(self.camera){
        [self.imgAlarm setHidden:self.camera.remoteNotifications<=1];
    }
}

-(void)refreshState{
    if(self.camera){
        NSLog(@"%@ %@ %s %d %ld",[self.camera uid],[self class],__func__,__LINE__,(long)self.camera.cameraConnectState);
        [self setState:self.camera.cameraConnectState];
    }
}
-(void)refreshSnapshot{
    if(self.camera){
        [self.imgCameraSnap setImage:self.camera.image];
    }
}
-(void)refreshInfo{
    if(self.camera){
        NSInteger index = [GBase getCameraIndex:self.camera];
        self.btnCameraDelete.tag  = index;
        self.labCameraName.text = self.camera.nickName;
        self.btnModifyCameraName.tag = index;
        self.btnPlay.tag = index;
        self.btnReconnect.tag = index;
        self.btnModifyPassword.tag = index;
        self.btnCameraEvent.tag = index;
        
    }
}

- (IBAction)go2CameraSetting:(id)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:[self getSettingStoryboardName] bundle:nil];
    BaseViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"storyboard_cameraSetting"];  //test2为viewcontroller的StoryboardId
    test2obj.camera = self.camera;
    [[self currentViewController].navigationController pushViewController:test2obj animated:YES];
}

-(void)setCamera:(BaseCamera *)camera{
    _camera = camera;
    NSLog(@"%@ %@ %s %d %ld",[camera uid],[self class],__func__,__LINE__,(long)camera.cameraConnectState);
    if(_camera){
        [self refreshState];
        [self refreshSnapshot];
        [self refreshAlarmState];
        [self refreshInfo];
    }
}
-(UIViewController *)currentViewController{
    UIViewController *vc;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]] ) {
            vc=(UIViewController*)nextResponder;
            
            return vc;
        }
    }
    return vc;
}

-(NSString*)getSettingStoryboardName{
    return _camera.p2pType == P2P_Hichip?@"CameraSetting_Hichip":@"CameraSetting";
}

@end
