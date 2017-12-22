
//
//  CameraListItemTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/11/29.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "CameraListItemTableViewCell.h"
#import "BaseViewController.h"

@interface CameraListItemTableViewCell(){
   __weak MyCamera *_camera;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_labConnectstate;
@property (weak, nonatomic) IBOutlet UIView *viewSnapshotMask;

@end

@implementation CameraListItemTableViewCell

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)awakeFromNib {
    [super awakeFromNib];

    [[self labCameraConnectState] setBackgroundColor:Color_GreenDark];
    [self.labCameraName setTextColor:Color_GrayDark];
    
    [self.btnCameraEvent setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_Primary] forState:UIControlStateHighlighted];
    [self.btnCameraEvent setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_White_alpha] forState:UIControlStateNormal];
    [self.btnCameraEvent setBackgroundImage:[CameraListItemTableViewCell imageWithColor:[UIColor clearColor]] forState:UIControlStateDisabled];

    [self.btnCameraSetting setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_Primary] forState:UIControlStateHighlighted];
    [self.btnCameraSetting setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_White_alpha] forState:UIControlStateNormal];
    [self.btnCameraSetting setBackgroundImage:[CameraListItemTableViewCell imageWithColor:[UIColor clearColor]] forState:UIControlStateDisabled];
    
    [self.btnCameraDelete setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_Primary] forState:UIControlStateHighlighted];
    [self.btnCameraDelete setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_White_alpha] forState:UIControlStateNormal];
    [self.btnCameraDelete setBackgroundImage:[CameraListItemTableViewCell imageWithColor:[UIColor clearColor]] forState:UIControlStateDisabled];
    
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
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"CameraSetting" bundle:nil];
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
    if(self.camera){
        self.labCameraConnectState.text = [self.camera strConnectState];
    }
    if(state == CONNECTION_STATE_CONNECTING || self.camera.processState != CAMERASTATE_NONE){
        [self.viewSnapshotMask setBackgroundColor:Color_Black_alpha_5];
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = Color_Primary;
        MBProgressHUD *p = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [p setColor:[UIColor clearColor]];
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        [self.btnReconnect setHidden:YES];
        [self.btnModifyPassword setHidden:YES];
        [self.btnPlay setHidden:YES];
        //self.labCameraConnectState.text = LOCALSTR(@"Connecting");
        [self.labCameraConnectState setBackgroundColor:Color_Primary];
        self.constraint_width_labConnectstate.constant = 75;
        [_btnCameraEvent setEnabled:NO];
        [_btnCameraSetting setEnabled:NO];
    }
    else{
        [MBProgressHUD hideAllHUDsForView:self animated:NO];
        if(state == CONNECTION_STATE_CONNECTED){
            [self.viewSnapshotMask setBackgroundColor:Color_Black_alpha_2];
            [self.btnReconnect setHidden:YES];
            [self.btnModifyPassword setHidden:YES];
            [self.btnPlay setHidden:NO];
            //self.labCameraConnectState.text = LOCALSTR(@"Online");
            [self.labCameraConnectState setBackgroundColor:Color_GreenDark];
            [TwsViewTools setButtonContentCenter:self.btnPlay];
            self.constraint_width_labConnectstate.constant = 75;
            [_btnCameraEvent setEnabled:YES];
            [_btnCameraSetting setEnabled:YES];
        }
        else if(state == CONNECTION_STATE_WRONG_PASSWORD){
            [self.viewSnapshotMask setBackgroundColor:Color_Black_alpha_5];
            [self.btnReconnect setHidden:YES];
            [self.btnModifyPassword setHidden:NO];
            [self.btnPlay setHidden:YES];
            [TwsViewTools setButtonContentCenter:self.btnModifyPassword];
            //self.labCameraConnectState.text = LOCALSTR(@"Wrong Password");
            [self.labCameraConnectState setBackgroundColor:Color_GrayDark];
            self.constraint_width_labConnectstate.constant = 105;
            [_btnCameraEvent setEnabled:NO];
            [_btnCameraSetting setEnabled:NO];
        }
        else{
            [self.viewSnapshotMask setBackgroundColor:Color_Black_alpha_5];
            [self.btnReconnect setHidden:NO];
            [self.btnModifyPassword setHidden:YES];
            [self.btnPlay setHidden:YES];
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
        [self.imgAlarm setHidden:self.camera.eventNotification<1];
    }
}

-(void)refreshState{
    if(self.camera){
        [self setState:self.camera.connectState];
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
        
    }
}

- (IBAction)go2CameraSetting:(id)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"CameraSetting" bundle:nil];
    BaseViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"storyboard_cameraSetting"];  //test2为viewcontroller的StoryboardId
    test2obj.camera = self.camera;
    [[self currentViewController].navigationController pushViewController:test2obj animated:YES];
}

-(void)setCamera:(MyCamera *)camera{
    _camera = camera;
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

@end
