//
//  EventSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "EventSetting_AoniViewController.h"

@interface EventSetting_AoniViewController (){
    NSString *currentSens;
    NSInteger currentPush;
}
@property (nonatomic,strong) NSArray *sensValueDesc;
@property (nonatomic,strong) NSArray *sensValue;
@property (strong,nonatomic) NSArray *listItems;
@end

@implementation EventSetting_AoniViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sensValue = @[@80,@60,@40,@20,@0];
    _sensValueDesc = @[LOCALSTR(@"Highest"),LOCALSTR(@"High"),LOCALSTR(@"General"),LOCALSTR(@"Low"),LOCALSTR(@"Close")];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
}

-(void)setup{
    currentSens = nil;
    [self.tableView reloadData];
    [self doGetEventSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doGetEventSetting{
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_ARM_STATUS_REQ Data:(char*)nil DataSize:0];
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETRECORD_REQ Data:(char*)nil DataSize:0];
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETRCD_DURATION_REQ Data:(char*)nil DataSize:0];
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_BAT_PUSH_EN_REQ Data:(char*)nil DataSize:0];
}
-(void)doGetPirSens{
     [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_PIR_SENSITIVITY_RESP Data:(char*)nil DataSize:0];
}

-(void)doSetBatteryPush:(BOOL)enable{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    SMsgAVIoctrlSetBatPushReq *req = malloc(sizeof(SMsgAVIoctrlSetBatPushReq));
    req->push_en = enable?1:0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_BAT_PUSH_EN_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetBatPushReq)];
    free(req);
    req = nil;
}

-(void)doSetRecord:(BOOL)enable{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    SMsgAVIoctrlSetRecordReq *req = malloc(sizeof(SMsgAVIoctrlSetRecordReq));
    req->channel = 0;
    req->recordType = enable?2:0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SETRECORD_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetRecordReq)];
    free(req);
    req = nil;
}

-(void)doSetRecordDuration:(int)dur{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    SMsgAVIoctrlSetRcdDurationReq *req = malloc(sizeof(SMsgAVIoctrlSetRcdDurationReq));
    req->channel = 0;
    req->durasecond = dur;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SETRCD_DURATION_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetRcdDurationReq)];
    free(req);
    req = nil;
}

-(NSArray *)listItems{
    if(!_listItems){
       ListImgTableViewCellModel *recordDurModel = [ListImgTableViewCellModel initObj:@"ic_push2" title:LOCALSTR(@"Record Duration") showValue:YES value:nil viewId:TableViewCell_Button_HyperLink];
        recordDurModel.desc = LOCALSTR(@"seconds");
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:@"ic_sens" title:LOCALSTR(@"Sensitivity Setting") showValue:YES value:nil viewId:TableViewCell_ListImg],
                         [ListImgTableViewCellModel initObj:@"ic_push2" title:LOCALSTR(@"Alarm Push") showValue:YES value:self.camera.remoteNotifications >0?@"1":@"0" viewId:TableViewCell_Switch],
                         [ListImgTableViewCellModel initObj:@"ic_record_alarm" title:LOCALSTR(@"Battery Alarm Push") showValue:YES value:nil viewId:TableViewCell_Switch],
                         [ListImgTableViewCellModel initObj:@"ic_record_alarm" title:LOCALSTR(@"Alarm Record") showValue:YES value:nil viewId:TableViewCell_Switch],
                         recordDurModel,
                         
                         nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}


- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didClickSwitch:(UISwitch*)sw{
    NSIndexPath *indexPath = [self getIndexPath:cellModel];
    if(indexPath.row == 1){
        [self clickPush:sw];
    }
    else if(indexPath.row == 2){
        [self doSetBatteryPush:sw.isOn];
    }
    else if(indexPath.row == 3){
        [self doSetRecord:sw.isOn];
    }
}
-(void)clickPush:(UISwitch *)sender{
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    if([sender isOn]){
        [self.camera openPush:^(NSInteger code) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                if(code == 0){
                    [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                }
                else{
                    [sender setOn:NO];
                    [[iToast makeText:LOCALSTR(@"Setting Failed")] show];
                }
            });
        }];
    }
    else{
        [self.camera closePush:^(NSInteger code) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                if(code == 0){
                    [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                }
                else{
                    [sender setOn:NO];
                    [[iToast makeText:LOCALSTR(@"Setting Failed")] show];
                }
            });
        }];
    }
    [GBase editCamera:self.camera];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"EventSetting2SensSetting" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//其他界面返回到此界面调用的方法
- (IBAction)EventSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didClickButton:(UIButton*)btn{
     NSIndexPath *indexPath = [self getIndexPath:cellModel];
    if(indexPath.row == 4){
        [self doShowModifyRecordDuration];
    }
}


-(void)doShowModifyRecordDuration{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALSTR(@"Modify Record Duration") message: @"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = LOCALSTR(@"Record Duration");
        textField.text = [[self getRowValue:4 section:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:LOCALSTR(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:actionNO];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:LOCALSTR(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *dur = alertController.textFields.firstObject.text;
        int iDur = [dur intValue];
        if(iDur < 10 || iDur > 300){
            [[iToast makeText:FORMAT(LOCALSTR(@"%d-%d seconds time range"),10,300)] show];
            return;
        }
        else{
            [self doSetRecordDuration:iDur];
        }
    
    }];
    
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:NULL];
}


- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GET_PIR_SENSITIVITY_RESP:{
            SMsgGetPirSensitivityResp *resp = (SMsgGetPirSensitivityResp*)data;
            for(int i=0;i<_sensValue.count;i++){
                if(resp->sensitivity >= [(NSNumber*)_sensValue[i] intValue]){
                    currentSens = _sensValueDesc[i];
                    break;
                }
            }
            [self setRowValue:currentSens row:0 section:0];
            [self.tableView reloadData];
            break;
        }
        case IOTYPE_USER_IPCAM_GET_ARM_STATUS_RESP:{
            SMsgGetArmEnableResp *resp = (SMsgGetArmEnableResp*)data;
            if(resp->arm_enable == 0){
                [self setRowValue:_sensValueDesc[_sensValueDesc.count - 1] row:0 section:0];
                [self.tableView reloadData];
            }
            else{
                [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_PIR_SENSITIVITY_REQ Data:(char *)nil DataSize:0];
            }
        }
            break;
        case IOTYPE_USER_IPCAM_GETRECORD_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
            SMsgAVIoctrlGetRecordResq *resp = (SMsgAVIoctrlGetRecordResq*)data;
            [self setRowValue:resp->recordType==2?@"1":@"0" row:3 section:0];
            [self.tableView reloadData];
        }
            break;
        case IOTYPE_USER_IPCAM_GETRCD_DURATION_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
            SMsgAVIoctrlGetRcdDurationResp *resp = (SMsgAVIoctrlGetRcdDurationResp*)data;
            [self setRowValue:FORMAT(@"  %d  ",resp->durasecond) row:4 section:0];
            [self.tableView reloadData];
        }
            break;
        case IOTYPE_USER_IPCAM_GET_BAT_PUSH_EN_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
            SMsgAVIoctrlGetBatPushResp *resp = (SMsgAVIoctrlGetBatPushResp*)data;
            
            [self setRowValue:resp->push_en==1?@"1":@"0" row:2 section:0];
            [self.tableView reloadData];
        }
            break;
        case IOTYPE_USER_IPCAM_SET_BAT_PUSH_EN_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
            SMsgAVIoctrlSetBatPushResp *resp = (SMsgAVIoctrlSetBatPushResp*)data;
            if(resp->result == 0){
                [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
            }
            else{
                [self setRowValue:[[self getRowValue:2 section:0] isEqualToString:@"1"]?@"0":@"1" row:2 section:0];
                [[iToast makeText:LOCALSTR(@"Setting Failed")] show];
                [self.tableView reloadData];
            }
        }
            break;
        case IOTYPE_USER_IPCAM_SETRCD_DURATION_RESP:{
            SMsgAVIoctrlSetRcdDurationResp *resp = (SMsgAVIoctrlSetRcdDurationResp*)data;
            [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETRCD_DURATION_REQ Data:(char*)nil DataSize:0];
            if(resp->result == 0){
                [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
            }
            else{
            }
        }
            break;
        case IOTYPE_USER_IPCAM_SETRECORD_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
            SMsgAVIoctrlSetBatPushResp *resp = (SMsgAVIoctrlSetBatPushResp*)data;
            if(resp->result == 0){
                [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
            }
            else{
                [self setRowValue:[[self getRowValue:3 section:0] isEqualToString:@"1"]?@"0":@"1" row:3 section:0];
                [[iToast makeText:LOCALSTR(@"Setting Failed")] show];
                [self.tableView reloadData];
            }
        }
            break;
        default:
            break;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender{
    
    if([segue.identifier isEqualToString:@"EventSetting2SensSetting"]){
        BaseTableViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
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
