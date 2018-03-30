//
//  CameraSettingViewController.m
//  tenvisty
//
//  Created by lu yi on 12/5/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "OtherSetting_AoniViewController.h"

@interface OtherSetting_AoniViewController (){
}
@property (strong,nonatomic) NSArray *listItems;

@end

@implementation OtherSetting_AoniViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}
-(void) setup{
    [self doGetLedStatus];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) doGetLedStatus{
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_ALARMLED_CONTRL_REQ Data:(char*)nil DataSize:0];
}
-(void) doSetLedLight:(BOOL)enable{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    SMsgAVIoctrlSetLedStatusReq *req = malloc(sizeof(SMsgAVIoctrlSetLedStatusReq));
    req->led_status = enable?1:0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_ALARMLED_CONTRL_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetLedStatusReq)];
    free(req);
    req = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_timezone" title:LOCALSTR(@"Time Setting") showValue:NO value:nil viewId:TableViewCell_ListImg],
        [ListImgTableViewCellModel initObj:@"ic_reverse" title:LOCALSTR(@"Led Light") showValue:YES value:nil viewId:TableViewCell_Switch],
        [ListImgTableViewCellModel initObj:@"ic_sd" title:LOCALSTR(@"SD Card") showValue:NO value:nil viewId:TableViewCell_ListImg],
        [ListImgTableViewCellModel initObj:@"ic_info" title:LOCALSTR(@"Device Infomation") showValue:NO value:nil viewId:TableViewCell_ListImg], nil];
       
          _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BaseTableViewController class]]){
        BaseTableViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
    }
}

- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didClickSwitch:(UISwitch*)sw{
    [self doSetLedLight:sw.isOn];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
              [self performSegueWithIdentifier:@"OtherSetting2TimeSetting" sender:self];
        }
        else if(indexPath.row == 2){
              [self performSegueWithIdentifier:@"OtherSetting2SDCard" sender:self];
        }
        else if(indexPath.row == 3){
            [self performSegueWithIdentifier:@"OtherSetting2DeviceInfo" sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//其他界面返回到此界面调用的方法
- (IBAction)OtherSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_SET_ALARMLED_CONTRL_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            SMsgAVIoctrlSetLedStatusResp *resp = (SMsgAVIoctrlSetLedStatusResp*)data;
            if(resp->result == 0){
                if(resp->result == 0){
                    [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                }
                else{
                    [self setRowValue:[[self getRowValue:1 section:0] isEqualToString:@"1"]?@"0":@"1" row:1 section:0];
                    [[iToast makeText:LOCALSTR(@"Setting Failed")] show];
                    [self.tableView reloadData];
                }
            }
        }
            break;
        case IOTYPE_USER_IPCAM_GET_ALARMLED_CONTRL_RESP:{
            SMsgAVIoctrlGetLedStatusResp *resp = (SMsgAVIoctrlGetLedStatusResp*)data;
            [self setRowValue:resp->led_status==1?@"1":@"0" row:1 section:0];
            [self.tableView reloadData];
            break;
        }
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
