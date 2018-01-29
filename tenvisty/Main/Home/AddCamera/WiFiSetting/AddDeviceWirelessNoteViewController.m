//
//  AddDeviceWirelessNoteViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/11.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "AddDeviceWirelessNoteViewController.h"
#import "AddDeviceWirelessSettingViewController.h"
#import "SaveCameraTableViewController.h"

@interface AddDeviceWirelessNoteViewController ()
//@property (weak, nonatomic) IBOutlet FLAnimatedImageView *gifView;

@end

@implementation AddDeviceWirelessNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
//    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"configwifi_note2" withExtension:@"gif"];
//    NSData *data1 = [NSData dataWithContentsOfURL:url1];
//    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
//    self.gifView.animatedImage = animatedImage1;
    if([TwsDataValue getTryConnectCamera].isSessionConnected){
        [TwsTools presentAlertMsg:self message:LOCALSTR(@"Camera is online, please enter its password to add.") actionDefaultBlock:^{
            [self performSegueWithIdentifier:@"AddDeviceWirelessNote2SaveCamera" sender:self];
        }];
    }
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AddDeviceWirelessNote2AddDeviceWirelessSetting"]){
        AddDeviceWirelessSettingViewController *controller= segue.destinationViewController;
        controller.uid = self.uid;
        controller.wifiSsid = self.wifiSsid;
        controller.wifiPassword = self.wifiPassword;
        controller.wifiAuthMode = self.wifiAuthMode;
    }
    else if([segue.identifier isEqualToString:@"AddDeviceWirelessNote2SaveCamera"]){
        SaveCameraTableViewController *controller = segue.destinationViewController;
        controller.uid = self.uid;
    }
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"AddDeviceWirelessNote2AddDeviceWirelessSetting"]){
        if([TwsDataValue getTryConnectCamera].isSessionConnected){
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"Camera is online, please enter its password to add.") actionDefaultBlock:^{
                [self performSegueWithIdentifier:@"AddDeviceWirelessNote2SaveCamera" sender:self];
            }];
            return NO;
        }
    }
    return YES;
}

//其他界面返回到此界面调用的方法
- (IBAction)AddDeviceWirelessNoteViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
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
