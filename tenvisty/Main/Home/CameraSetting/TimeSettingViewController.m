//
//  TimeSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TimeSettingViewController.h"
#import "SyncTimeTableViewCell.h"
#import "TimeZoneModel.h"
#import "BaseViewController.h"

@interface TimeSettingViewController ()<CellModelDelegate>{
    NSString *time;
    NSInteger timezoneIndex;
    NSInteger dst;
}
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labTimezone;
@property (strong,nonatomic) NSArray *listItems;

@end

@implementation TimeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setup];
}

-(void)setup{
    [self getTime];
    [self getTimezone];
}

-(void)getTime{
    SMsgAVIoctrlGetTimeReq *req = malloc(sizeof(SMsgAVIoctrlGetTimeReq));
    req->ReqTimeType = 1;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_TIME_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetTimeReq)];
    free(req);
}

-(void)syncTime{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    SMsgAVIoctrlSetTimeReq *req = malloc(sizeof(SMsgAVIoctrlSetTimeReq));
    memset(req, 0, sizeof(SMsgAVIoctrlSetTimeReq));
    memcpy(req->NtpServ, NTP_SERVER, NTP_SERVER.length);
    req->NtpEnable = 1;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_TIME_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetTimeReq)];
    free(req);
}

-(void)getTimezone{
    dst = -1;
    timezoneIndex = -1;
    SMsgAVIoctrlGetTimeReq *req = malloc(sizeof(SMsgAVIoctrlGetTimeReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_ZONE_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetTimeReq)];
    free(req);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        [self syncTime];
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            [self performSegueWithIdentifier:@"TimeSetting2TimeZoneSetting" sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    else{
        if(dst != -1){
            return 2;
        }
        else{
            return 1;
        }
    }
}

-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:nil value:nil placeHodler:nil maxLength:0 viewId:TableViewCell_ListImg],
                         nil];
        NSArray *sec2 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Select time zone") showValue:YES value:nil viewId:TableViewCell_ListImg],
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Daylight") showValue:YES value:nil viewId:TableViewCell_Switch],
                         
                         nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1,sec2, nil];
    }
    return _listItems;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    if(indexPath.section == 0){
        SyncTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell_synctime" forIndexPath:indexPath];
        cell.time = time;
        return cell;
    }
    else{
       return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    
    return nil;
}

- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didClickSwitch:(UISwitch*)sw{
      [self setTimezoneDst:[sw isOn]];
}

-(void)setTimezoneDst:(BOOL)enable{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    SMsgAVIoctrlSetDstReq *req = malloc(sizeof(SMsgAVIoctrlSetDstReq));
    memset(req, 0, sizeof(SMsgAVIoctrlSetDstReq));
    //    if([[NSTimeZone localTimeZone] isDaylightSavingTime] && [[NSTimeZone localTimeZone] isDaylightSavingTimeForDate:[NSDate date]]){
    //        req->Enable = 1;
    //    }
    req->Enable = enable?1:0;
    NSString *area = ((TimeZoneModel*)[[TimeZoneModel getAll] objectAtIndex:timezoneIndex]).area;
    memcpy(req->DstDistId, [area UTF8String], area.length);
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_ZONE_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetTimeReq)];
    free(req);
}


//其他界面返回到此界面调用的方法
- (IBAction)TimeSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GET_TIME_INFO_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            SMsgAVIoctrlGetTimeResp *resp = (SMsgAVIoctrlGetTimeResp*)data;
            time = FORMAT(@"%d-%d-%d %d:%d:%d",resp->TimeInfo.year,resp->TimeInfo.month,resp->TimeInfo.day,resp->TimeInfo.hour,resp->TimeInfo.minute,resp->TimeInfo.second);
            [self.tableView reloadData];
            break;
        }
        case IOTYPE_USER_IPCAM_GET_ZONE_INFO_RESP:{
            SMsgAVIoctrlGetDstResp *resp = (SMsgAVIoctrlGetDstResp*)data;
            for(int i=0; i < [TimeZoneModel getAll].count; i++){
                TimeZoneModel *tz = [[TimeZoneModel getAll] objectAtIndex:i];
                if([tz.area isEqualToString:[NSString stringWithUTF8String:resp->DstDistrictInfo.DstDistId]]){
                    NSString *timezoneId = ((TimeZoneModel*)[[TimeZoneModel getAll] objectAtIndex:timezoneIndex]).area;
                    [self setRowValue:LOCALSTR(timezoneId) row:0 section:0];
                    timezoneIndex = i;
                    if(tz.dst){
                        dst = resp->enable;
                        [self setRowValue:FORMAT(@"%ld",(long)dst) row:1 section:0];
                    }
                    else{
                        dst = -1;
                    }
                    break;
                }
            }
            [self.tableView reloadData];
            break;
            break;
        }
        case IOTYPE_USER_IPCAM_SET_TIME_INFO_RESP:{
        
            SMsgAVIoctrlSetTimeResp *resp = (SMsgAVIoctrlSetTimeResp*)data;
            if(resp ->result == 0){
                [self getTime];
            }
            else{
                [[iToast makeText:LOCALSTR(@"sync failed")] show];
            }
            break;
        }
        case IOTYPE_USER_IPCAM_SET_ZONE_INFO_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            SMsgAVIoctrlSetDstResp *resp = (SMsgAVIoctrlSetDstResp*)data;
            if(resp->result == 0){
                
            }
            else{
                [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
            }
        }
        default:
            break;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Main.width, 40)];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, Screen_Main.width, 20)];
    if(section == 0){
        labTitle.text = LOCALSTR(@"Device Time");
    }else{
         labTitle.text = LOCALSTR(@"Device Time Zone");
    }
    [labTitle setTextColor:Color_GrayDark];
    labTitle.font = [UIFont systemFontOfSize:14];
    [view addSubview:labTitle];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BaseTableViewController class]]){
        BaseTableViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
    }
    else if([segue.destinationViewController isKindOfClass:[BaseViewController class]]){
        BaseViewController *controller= segue.destinationViewController;
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
