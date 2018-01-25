//
//  AddCameraNavigationTypeViewController.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/24.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#define ADDCAMERA_WIRELESS 0
#define ADDCAMERA_WIRED 1

#import "AddCameraNavigationTypeViewController.h"

@interface AddCameraNavigationTypeViewController (){
}
@property (nonatomic,strong) NSString* uid;
@property (nonatomic,assign) NSInteger addCameraType;

@end

@implementation AddCameraNavigationTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:Color_GrayLightest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)go2ScanQRCode{
    OCScanLifeViewController* test2obj = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboard_scanQRCode"];  //test2为viewcontroller的StoryboardId
    [self.navigationController pushViewController:test2obj animated:YES];
}
//其他界面返回到此界面调用的方法
- (IBAction)AddCameraNavigationTypeViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{
    return YES;
}

- (void)scanResult:(NSString *)result{
    if(result){
        self.uid = result;
//        if( self.addCameraType == ADDCAMERA_WIRELESS){
//            [self performSegueWithIdentifier:@"AddCamera2SaveCamera" sender:self];
//        }
//        else if(self.addCameraType == ADDCAMERA_WIRED){
//            [self performSegueWithIdentifier:@"AddCamera2AddDeviceWirelessNote" sender:self];
//        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AddCameraNavigationType2ScanQRCode"]){
        OCScanLifeViewController *controller= segue.destinationViewController;
        controller.title = LOCALSTR(@"Scan QR Code");
        controller.delegate = self;
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
