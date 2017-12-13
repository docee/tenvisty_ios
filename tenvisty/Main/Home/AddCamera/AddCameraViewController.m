//
//  AddCameraViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/11/30.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "AddCameraViewController.h"
#import "SaveCameraTableViewController.h"
#import "AddDeviceWirelessNoteViewController.h"

@interface AddCameraViewController (){
}
@property (nonatomic,assign) NSInteger scanType;
@end

@implementation AddCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//其他界面返回到此界面调用的方法
- (IBAction)AddCameraViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
- (IBAction)openScanQRCode:(id)sender {
    self.scanType = 1;
    [self go2ScanQRCode];
}

-(void)go2ScanQRCode{
    [self performSegueWithIdentifier:@"AddCamera2ScanQRCode" sender:self];

}

- (void)scanResult:(NSString *)result{
    if(result){
        self.uid = result;
        if( self.scanType == 1){
            [self performSegueWithIdentifier:@"AddCamera2SaveCamera" sender:self];
        }
        else if(self.scanType == 2){
            [self performSegueWithIdentifier:@"AddCamera2AddDeviceWirelessNote" sender:self];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AddCamera2SaveCamera"]){
        SaveCameraTableViewController *controller= segue.destinationViewController;
        controller.uid = self.uid;
    }
    else if([segue.identifier isEqualToString:@"AddCamera2ScanQRCode"]){
        OCScanLifeViewController *controller= segue.destinationViewController;
        controller.hasNoQRCodeBtn = YES;
        controller.title = LOCALSTR(@"Scan QR Code");
        controller.delegate = self;
        controller.fromType = self.scanType;
    }
    else if([segue.identifier isEqualToString:@"AddCamera2AddDeviceWirelessNote"]){
        AddDeviceWirelessNoteViewController *controller= segue.destinationViewController;
        controller.uid = self.uid;
    }
    
}
- (IBAction)go2WirelessInstall:(id)sender {
    if([GNetworkStates getDeviceSSID] == nil){
        NSString *msg= LOCALSTR(@"Please connect to Wi-Fi first");
        [TwsTools presentAlertTitle:self title:nil message:msg alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            
            
        } actionCancelTitle:nil actionCancelBlock:^{
            
        }];

    }
    else{
        self.scanType = 2;
        [self go2ScanQRCode];
    }
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
