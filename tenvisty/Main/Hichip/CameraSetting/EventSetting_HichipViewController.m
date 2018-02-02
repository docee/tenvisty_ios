//
//  EventSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "EventSetting_HichipViewController.h"
#import "AlarmLink.h"
#import "BaseViewController.h"
#import "EmailSetting_HichipViewController.h"

@interface EventSetting_HichipViewController (){
    NSInteger currentPush;
}
@property (nonatomic,strong) NSArray *sensValueDesc;
@property (nonatomic,strong) NSArray *sensValue;
@property (strong,nonatomic) NSArray *listItems;
@property (nonatomic,strong) AlarmLink *alarmParas;
@end

@implementation EventSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sensValue = @[@80,@60,@40,@20,@0];
    _sensValueDesc = @[LOCALSTR(@"Highest"),LOCALSTR(@"High"),LOCALSTR(@"General"),LOCALSTR(@"Low"),LOCALSTR(@"Close")];
    [self.tableView setBackgroundColor:Color_GrayLightest];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
}

-(void)setup{
    [self.tableView reloadData];
    [self doGetEventSetting];
}
-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_sens" title:LOCALSTR(@"Sensitivity Setting") showValue:YES value:nil viewId:TableViewCell_ListImg],nil];
        NSArray *sec2 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_push" title:LOCALSTR(@"Alarm Push") showValue:YES value:self.camera.remoteNotifications>0?@"1":@"0" viewId:TableViewCell_Switch],nil];
        NSArray *sec3 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_othersetting" title:LOCALSTR(@"SD-Card Recording") showValue:YES value:nil viewId:TableViewCell_Switch],nil];
        NSArray *sec4 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_systemsetting" title:LOCALSTR(@"Email Alert") showValue:YES value:nil viewId:TableViewCell_ListImg],nil];
        NSArray *sec5 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_systemsetting" title:LOCALSTR(@"Save Picture to FTP Server") showValue:YES value:nil viewId:TableViewCell_Switch],
            [ListImgTableViewCellModel initObj:@"ic_systemsetting" title:LOCALSTR(@"Save Video to FTP Server") showValue:YES value:nil viewId:TableViewCell_Switch],
            [ListImgTableViewCellModel initObj:@"ic_systemsetting" title:LOCALSTR(@"FTP Setting") showValue:NO value:nil viewId:TableViewCell_ListImg],nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1,sec2,sec3,sec4,sec5, nil];
    }
    return _listItems;
}
#pragma mark - 移动侦测报警
- (void)doGetEventSetting {
    [self doGetMotionDetectSetting];
    [self doGetAlarmLinkSetting];
}

-(void)doGetMotionDetectSetting{
    // 获取全部区域的参数
    for (NSInteger i = HI_P2P_MOTION_AREA_1; i <= HI_P2P_MOTION_AREA_MAX; i++) {
        HI_P2P_S_MD_PARAM *md_param = (HI_P2P_S_MD_PARAM*)malloc(sizeof(HI_P2P_S_MD_PARAM));
        memset(md_param, 0, sizeof(HI_P2P_S_MD_PARAM));
        md_param->struArea.u32Area = (HI_U32)i;
        md_param->u32Channel = 0;
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_MD_PARAM Data:(char *)md_param DataSize:sizeof(HI_P2P_S_MD_PARAM)];
        free(md_param);
        md_param = nil;
    }
}

-(void)doGetAlarmLinkSetting{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_ALARM_PARAM Data:(char*)nil DataSize:0];
   // [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_SNAP_ALARM_PARAM Data:(char*)nil DataSize:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didClickSwitch:(UISwitch*)sw{
    NSIndexPath *indexPath = [self getIndexPath:cellModel];
    if(indexPath.section == 1 && indexPath.row == 0){
        [self clickPush:sw];
    }
    else{
        if(indexPath.section == 2 && indexPath.row == 0){
            self.alarmParas.u32SDRec = sw.isOn?1:0;
            if(self.alarmParas.u32SDRec == 0 && self.alarmParas.u32FtpRec == 1){
                self.alarmParas.u32FtpRec = 0;
                [self refreshViewModel];
            }
            else if(indexPath.section == 4 && indexPath.row == 0){
                self.alarmParas.u32FtpSnap = sw.isOn?1:0;
            }
            else if(indexPath.section == 4 && indexPath.row == 1){
                self.alarmParas.u32FtpRec = sw.isOn?1:0;
                if(self.alarmParas.u32FtpRec == 1 && self.alarmParas.u32SDRec == 0){
                    self.alarmParas.u32SDRec = 1;
                    [self refreshViewModel];
                }
            }
            [self setAlarmLinkParas];
        }
    }
}

-(void)refreshViewModel{
    ListImgTableViewCellModel *sdRecordModel = [[self.listItems objectAtIndex:2] objectAtIndex:0];
    sdRecordModel.titleValue = self.alarmParas.u32SDRec == 0 ? @"0" : @"1";
    ListImgTableViewCellModel *emailSnapModel = [[self.listItems objectAtIndex:3] objectAtIndex:0];
    emailSnapModel.titleValue = self.alarmParas.u32EmailSnap == 0 ? LOCALSTR(@"OFF") :LOCALSTR(@"ON");
    
    ListImgTableViewCellModel *ftpSnapModel = [[self.listItems objectAtIndex:4] objectAtIndex:0];
    ftpSnapModel.titleValue = self.alarmParas.u32FtpSnap == 0 ? @"0" : @"1";
    ListImgTableViewCellModel *ftpRecordModel = [[self.listItems objectAtIndex:4] objectAtIndex:1];
    ftpRecordModel.titleValue = self.alarmParas.u32FtpRec == 0 ? @"0" : @"1";
    [self.tableView reloadData];
}

-(void)setAlarmLinkParas{
    if(self.alarmParas){
        HI_P2P_S_ALARM_PARAM *model = [self.alarmParas model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_ALARM_PARAM Data:(char*)model DataSize:sizeof(HI_P2P_S_ALARM_PARAM)];
        free(model);
        model = nil;
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
    if(indexPath.section == 0 && indexPath.row == 0){
        [self performSegueWithIdentifier:@"EventSetting2SensSetting" sender:nil];
    }
    else if(indexPath.section == 3 && indexPath.row == 0){
        [self performSegueWithIdentifier:@"EventSetting2EmailSetting" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//其他界面返回到此界面调用的方法
- (IBAction)EventSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_MD_PARAM:{
            ListImgTableViewCellModel *model = [[self.listItems objectAtIndex:0] objectAtIndex:0];
            HI_P2P_S_MD_PARAM *resp = (HI_P2P_S_MD_PARAM*)data;
            if(resp->struArea.u32Area == HI_P2P_MOTION_AREA_1){
                if(resp->struArea.u32Enable == 0){
                    model.titleValue = _sensValueDesc[_sensValueDesc.count - 1];
                }
                else{
                    for(int i=0;i<_sensValue.count;i++){
                        if(resp->struArea.u32Sensi >= [(NSNumber*)_sensValue[i] intValue]){
                            model.titleValue = _sensValueDesc[i];
                            break;
                        }
                    }
                }
            }
            [self.tableView reloadData];
            break;
        }
        case HI_P2P_GET_ALARM_PARAM:{
            if(size >= sizeof(HI_P2P_S_ALARM_PARAM)){
                self.alarmParas =[[AlarmLink alloc] initWithData:(char*)data size:(int)size];
                [self refreshViewModel];
            }
        }
            break;
        case HI_P2P_SET_ALARM_PARAM:{
            if(size >=0){
                [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
            }
            [self doGetAlarmLinkSetting];
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
    else if([segue.identifier isEqualToString:@"EventSetting2EmailSetting"]){
        EmailSetting_HichipViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
        controller.enableEmail = self.alarmParas.u32EmailSnap == 1;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 15.0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
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
