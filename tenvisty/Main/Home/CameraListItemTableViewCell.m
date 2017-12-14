
//
//  CameraListItemTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/11/29.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "CameraListItemTableViewCell.h"

@interface CameraListItemTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_labConnectstate;

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
    [self.btnCameraEvent setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_Gray_alpha] forState:UIControlStateNormal];

    [self.btnCameraSetting setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_Primary] forState:UIControlStateHighlighted];
    [self.btnCameraSetting setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_Gray_alpha] forState:UIControlStateNormal];
    
    [self.btnCameraDelete setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_Primary] forState:UIControlStateHighlighted];
    [self.btnCameraDelete setBackgroundImage:[CameraListItemTableViewCell imageWithColor:Color_Gray_alpha] forState:UIControlStateNormal];
    
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
    if(state == CONNECTION_STATE_CONNECTING){
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = Color_Primary;
       MBProgressHUD *p = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [p setColor:[UIColor clearColor]];
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        [self.btnReconnect setHidden:YES];
        [self.btnModifyPassword setHidden:YES];
        [self.btnPlay setHidden:YES];
        self.labCameraConnectState.text = LOCALSTR(@"Connecting");
        [self.labCameraConnectState setBackgroundColor:Color_Primary];
    }
    else if(state == CONNECTION_STATE_CONNECTED){
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self.btnReconnect setHidden:YES];
        [self.btnModifyPassword setHidden:YES];
        [self.btnPlay setHidden:NO];
        self.labCameraConnectState.text = LOCALSTR(@"Online");
        [self.labCameraConnectState setBackgroundColor:Color_GreenDark];
    }
    else if(state == CONNECTION_STATE_WRONG_PASSWORD){
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self.btnReconnect setHidden:YES];
        [self.btnModifyPassword setHidden:NO];
        [self.btnPlay setHidden:YES];
        [TwsViewTools setButtonContentCenter:self.btnModifyPassword];
        self.labCameraConnectState.text = LOCALSTR(@"Wrong Password");
        [self.labCameraConnectState setBackgroundColor:Color_GrayDark];
        self.constraint_width_labConnectstate.constant = 105;
    }
    else{
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self.btnReconnect setHidden:NO];
        [self.btnModifyPassword setHidden:YES];
        [self.btnPlay setHidden:YES];
        [TwsViewTools setButtonContentCenter:self.btnReconnect];
        self.labCameraConnectState.text = LOCALSTR(@"Offline");
        [self.labCameraConnectState setBackgroundColor:Color_GrayDark];
    }
}

-(void)setAlarm:(NSInteger)num{
    [self.imgAlarm setHidden:num<1];
}

@end
