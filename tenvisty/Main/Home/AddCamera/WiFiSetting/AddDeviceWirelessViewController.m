//
//  AddDeviceWirelessViewController.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/12.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "AddDeviceWirelessViewController.h"
#import "BaseTableView.h"
#import "TextFieldDisableTableViewCell.h"
#import "PasswordFieldTableViewCell.h"
#import "SaveCameraTableViewController.h"
#import "AddDeviceWirelessNoteViewController.h"

@interface AddDeviceWirelessViewController ()
@property (weak, nonatomic) IBOutlet BaseTableView *tableview;

@property (strong,nonatomic) NSArray *listItems;
@end

@implementation AddDeviceWirelessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)listItems{
    if(!_listItems){
        ListImgTableViewCellModel *ssidModel = [ListImgTableViewCellModel initObj:@"ic_wifi" title:@"" showValue:YES value:[GNetworkStates getDeviceSSID] viewId:TableViewCell_TextField_Disable];
        ssidModel.textAlignment = NSTextAlignmentLeft;
        ssidModel.valueMarginLeft = 60;
        ListImgTableViewCellModel *pwdModel = [ListImgTableViewCellModel initObj:@"ic_password" title:@"" showValue:YES value:@"" viewId:TableViewCell_TextField_Password];
        pwdModel.textAlignment = NSTextAlignmentLeft;
        pwdModel.valueMarginLeft = 60;
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         ssidModel,pwdModel,nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     if([segue.identifier isEqualToString:@"AddCameraWireless2AddCameraWirelessNote"]){
        AddDeviceWirelessNoteViewController *controller= segue.destinationViewController;
        controller.uid = [TwsDataValue getTryConnectCamera].uid;
        controller.wifiSsid = [self getRowValue:0 section:0];
        controller.wifiPassword = [self getRowValue:1 section:0];
        controller.wifiAuthMode = 1;
     }
     else if([segue.identifier isEqualToString:@"AddDeviceWireless2SaveCamera"]){
         SaveCameraTableViewController *controller =  segue.destinationViewController;
         controller.uid = [TwsDataValue getTryConnectCamera].uid;
     }
}

//其他界面返回到此界面调用的方法
- (IBAction)AddDeviceWirelessViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
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
