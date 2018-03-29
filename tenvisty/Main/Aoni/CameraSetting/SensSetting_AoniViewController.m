//
//  SensSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SensSetting_AoniViewController.h"

@interface SensSetting_AoniViewController (){
    NSInteger sensLevel;
}
@property (nonatomic,strong) NSArray *sensValue;
@property (strong,nonatomic) NSArray *items;
@end

@implementation SensSetting_AoniViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

-(void)setup{
    _sensValue = @[@80,@60,@40,@20,@0];
    [self doGetEventSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doGetEventSetting{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_ARM_STATUS_REQ Data:(char*)nil DataSize:0];
}

-(void)doSetEventSetting:(NSInteger)sens{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    sensLevel = [self getLevel:sens];
    SMsgSetArmEnableReq *req = malloc(sizeof(SMsgSetArmEnableReq));
    req->arm_enable = sens == 0?0:1;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_ARM_STATUS_REQ Data:(char *)req DataSize:sizeof(SMsgSetArmEnableReq)];
    free(req);
    req = nil;
}

-(void)doSetSensSetting:(NSInteger)level{
    SMsgSetPirSensitivityReq *req = malloc(sizeof(SMsgSetPirSensitivityReq));
    req->sensitivity = (int)[self getSens:level];
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_PIR_SENSITIVITY_REQ Data:(char *)req DataSize:sizeof(SMsgSetPirSensitivityReq)];
    free(req);
    req = nil;
}

-(NSArray *)items{
    if(_items == nil){
        _items = [[NSArray alloc] initWithObjects:LOCALSTR(@"Highest"),LOCALSTR(@"High"),LOCALSTR(@"General"),LOCALSTR(@"Low"),LOCALSTR(@"Close"), nil];
    }
    return _items;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self items].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_SelectItem;
    SelectItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    cell.leftLabel.text = [[self items] objectAtIndex:indexPath.row];
    
    [cell setSelect:indexPath.row == sensLevel];
    
    return cell;
}

-(NSInteger)getLevel:(NSInteger)sens{
    for(int i=0;i<_sensValue.count;i++){
        if(sens >= [(NSNumber*)_sensValue[i] intValue]){
            return i;
        }
    }
    return 0;
}
-(NSInteger)getSens:(NSInteger)level{
    return [(NSNumber*)_sensValue[level] integerValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self doSetEventSetting:[self getSens:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_SET_ARM_STATUS_RESP:{
            SMsgSetArmEnableResp *resp = (SMsgSetArmEnableResp*)data;
            if(resp->result == 0){
                if(sensLevel == self.items.count - 1){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [self doSetSensSetting:sensLevel];
                }
            }
            else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
            }
        }
            break;
        case IOTYPE_USER_IPCAM_GET_ARM_STATUS_RESP:{
            SMsgGetArmEnableResp *resp = (SMsgGetArmEnableResp*)data;
            if(resp->arm_enable == 0){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                sensLevel = self.items.count - 1;
                [self.tableView reloadData];
            }
            else{
                [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_PIR_SENSITIVITY_REQ Data:(char *)nil DataSize:0];
            }
        }
            break;
        case IOTYPE_USER_IPCAM_GET_PIR_SENSITIVITY_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            SMsgGetPirSensitivityResp *resp = (SMsgGetPirSensitivityResp*)data;
            sensLevel = [self getLevel:resp->sensitivity];
            [self.tableView reloadData];
        }
            break;
        case IOTYPE_USER_IPCAM_SET_PIR_SENSITIVITY_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            SMsgSetArmEnableResp *resp = (SMsgSetArmEnableResp*)data;
            if(resp->result == 0){
                [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
            }
        }
            break;
        default:
            break;
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
