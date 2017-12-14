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
#import "AddDeviceWirelessSettingViewController.h"

@interface AddDeviceWirelessViewController ()
@property (weak, nonatomic) IBOutlet BaseTableView *tableview;

@end

@implementation AddDeviceWirelessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        NSString *vid = TableViewCell_TextField_Disable;
        TwsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
        cell.title = @"";
        cell.leftImage = @"ic_wifi";
        cell.value = [GNetworkStates getDeviceSSID];
        cell.valueAligment = NSTextAlignmentLeft;
        cell.valueMarginLeft = 60;
        return cell;
    }
    else{
        NSString *vid = TableViewCell_TextField_Password;
        TwsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
        [cell setTitle:@""];
        [cell setLeftImage:@"ic_password"];
        [cell setValueAligment:NSTextAlignmentLeft];
        [cell setValueMarginLeft:60];
        return cell;
    }
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     if([segue.identifier isEqualToString:@"AddDeviceWireless2AddDeviceWirelessSetting"]){
        AddDeviceWirelessSettingViewController *controller= segue.destinationViewController;
        controller.uid = self.uid;
        controller.wifiSsid = ((TwsTableViewCell*)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).value;
        controller.wifiPassword = ((TwsTableViewCell*)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).value;
        controller.wifiAuthMode = 1;
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
