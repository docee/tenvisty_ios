//
//  CameraSettingViewController.m
//  tenvisty
//
//  Created by lu yi on 12/5/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "CameraSetting_AoniViewController.h"
#import "ListImgTableViewCell.h"
#import "ListImgTableViewCellModel.h"
#import "BaseTableViewController.h"

@interface CameraSetting_AoniViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSArray *listItems;
@property (weak, nonatomic) IBOutlet UIImageView *imgCameraSnapShot;
@property (weak, nonatomic) IBOutlet UILabel *labUID;

@end

@implementation CameraSetting_AoniViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"ListImgTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_ListImg];

}

-(void)setup{
    [_imgCameraSnapShot setImage:self.camera.image];
    [_labUID setText:self.camera.uid];
    [self doGetRecordSetting];
    [self doGetWiFi];
}

-(void)doGetWiFi{
    [self setRowValue:nil row:0 section:1 ];
    SMsgAVIoctrlGetWifiReq *req = malloc(sizeof(SMsgAVIoctrlGetWifiReq));
    memset(req, 0, sizeof(SMsgAVIoctrlGetWifiReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETWIFI_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetWifiReq)];
    free(req);
    req = nil;
    [self.tableview reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
    //刷新摄像机名称
    [self setRowValue:self.camera.nickName row:0 section:0 ];
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doGetRecordSetting{
    [self setRowValue:nil row:2 section:1 ];
    [self.tableview reloadData];
    SMsgAVIoctrlGetRecordReq *req = malloc(sizeof(SMsgAVIoctrlGetRecordReq));
    req->channel = 0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETRECORD_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetRecordReq)];
    free(req);
    req = nil;
}

-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_modifyname" title:LOCALSTR(@"Camera Name") showValue:YES value:self.camera.nickName viewId:TableViewCell_ListImg],[ListImgTableViewCellModel initObj:@"ic_modifypassword" title:LOCALSTR(@"Change Password") showValue:NO value:nil viewId:TableViewCell_ListImg], nil];
        NSArray *sec2 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_network" title:LOCALSTR(@"Wi-Fi") showValue:YES value:nil viewId:TableViewCell_ListImg],[ListImgTableViewCellModel initObj:@"ic_eventsetting" title:LOCALSTR(@"Event Setting") showValue:NO value:nil viewId:TableViewCell_ListImg],
            [ListImgTableViewCellModel initObj:@"ic_setting_record" title:LOCALSTR(@"Record") showValue:YES value:nil viewId:TableViewCell_ListImg],nil];
        NSArray *sec3 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_othersetting" title:LOCALSTR(@"Other Setting") showValue:NO value:nil viewId:TableViewCell_ListImg],nil];
        NSArray *sec4 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_systemsetting" title:LOCALSTR(@"System Setting") showValue:NO value:nil viewId:TableViewCell_ListImg],nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1,sec2,sec3,sec4, nil];
    }
    return _listItems;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
              [self performSegueWithIdentifier:@"CameraSetting2ChangeCameraName" sender:self];
        }
        else  if(indexPath.row == 1){
            [self performSegueWithIdentifier:@"CameraSetting2ChangeCameraPassword" sender:self];
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            [self performSegueWithIdentifier:@"CameraSetting2WiFiSetting" sender:self];
        }
        else if(indexPath.row == 1){
            [self performSegueWithIdentifier:@"CameraSetting2EventiSetting" sender:self];
        }
        else if(indexPath.row == 2){
            [self performSegueWithIdentifier:@"CameraSetting2RecordSetting" sender:self];
        }
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            [self performSegueWithIdentifier:@"CameraSetting2OtherSetting" sender:self];
        }
    }
    else if(indexPath.section == 3){
        if(indexPath.row == 0){
            [self performSegueWithIdentifier:@"CameraSetting2SystemSetting" sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BaseViewController class]]){
        BaseViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
    }
    else if([segue.destinationViewController isKindOfClass:[BaseTableViewController class]]){
        BaseTableViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
    }
}

//其他界面返回到此界面调用的方法
- (IBAction)CameraSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GETRECORD_RESP:{
            SMsgAVIoctrlGetRecordResq *resp = (SMsgAVIoctrlGetRecordResq*)data;
            NSString* v = resp->recordType == 0?LOCALSTR(@"OFF"):(resp->recordType == 1 ? LOCALSTR(@"Full Time Recording") : LOCALSTR(@"Alarm Recording"));
            [self setRowValue:v  row:2 section:1];
            [self.tableview reloadData];
            break;
        }
        case IOTYPE_USER_IPCAM_GETWIFI_RESP:{
            SMsgAVIoctrlGetWifiResp *resp = (SMsgAVIoctrlGetWifiResp*)data;
            NSString* ssid =  [NSString stringWithUTF8String: (const char*)resp->ssid];
            if(resp->status == 1 || resp->status == 3){
                [self setRowValue:ssid  row:0 section:1];
            }
            else{
                [self setRowValue:LOCALSTR(@"") row:0 section:1 ];
            }
            [self.tableview reloadData];
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
