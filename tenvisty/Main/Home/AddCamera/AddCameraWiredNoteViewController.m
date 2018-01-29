//
//  AddCameraWiredViewController.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/29.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "AddCameraWiredNoteViewController.h"
#import "SaveCameraTableViewController.h"

@interface AddCameraWiredNoteViewController ()

@end

@implementation AddCameraWiredNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doReady:(id)sender {
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"AddCameraWiredNote2SaveCamera"]){
        SaveCameraTableViewController *controller =  segue.destinationViewController;
        controller.uid = [TwsDataValue getTryConnectCamera].uid;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

@end
