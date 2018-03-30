//
//  TimezoneSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TimeZoneSetting_AoniViewController.h"
#import "TimeZoneModel.h"
#import "DetailTableViewCell.h"
#import "NtpTimeModel.h"

@interface TimeZoneSetting_AoniViewController (){
    NSInteger timezoneIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NtpTimeModel *timeModel;

@end

@implementation TimeZoneSetting_AoniViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}
-(void)setup{
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_Detail];
    [self getTime];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)getTime{
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_NTP_CONFIG_REQ Data:(char*)nil DataSize:0];
}

-(void)setTimezone:(NSInteger)index{
    if(self.timeModel){
        [MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
        NSCalendar *myCal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [myCal componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:[NSDate date]];
        self.timeModel.u32Year    = (int)[dateComponents year];//[GDate cyear].intValue;
        self.timeModel.u32Month   = (int)[dateComponents month];//[GDate cmonth].intValue;
        self.timeModel.u32Day     = (int)[dateComponents day];//[GDate cday].intValue;
        self.timeModel.u32Hour    = (int)[dateComponents hour];//[GDate chour].intValue;
        self.timeModel.u32Minute  = (int)[dateComponents minute];//[GDate cminute].intValue;
        self.timeModel.u32Second  = (int)[dateComponents second];//[GDate csecond].intValue;
        self.timeModel.u32Mode = 1;
        self.timeModel.u32Timezone = (int)index + 1;
        if(![self.timeModel.strNtpServer isEqualToString:@"128.138.140.44"] && ![self.timeModel.strNtpServer isEqualToString:NTP_SERVER] ){
            self.timeModel.strNtpServer = NTP_SERVER;
        }
        SMsgAVIoctrlSetNtpConfigReq *req = [self.timeModel model];
        [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_NTP_CONFIG_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetNtpConfigReq)];
        free(req);
        req = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [TimeZoneModel getAll].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    TimeZoneModel *model = (TimeZoneModel *)[[TimeZoneModel getAllOld] objectAtIndex:indexPath.row];
    NSString *id = TableViewCell_Detail;
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    cell.labTitle.text = LOCALSTR(model.area);
    cell.labDesc.text = LOCALSTR(model.strGMT);
    
    [cell setSelect:indexPath.row == timezoneIndex];
    
    return cell;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Main.width, 80)];
//    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, Screen_Main.width, 20)];
//    labTitle.text = LOCALSTR(@"Select the timezone");
//    labTitle.font = [UIFont systemFontOfSize:14];
//    [view addSubview:labTitle];
//    return view;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setTimezone:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 80.0;
//}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GET_NTP_CONFIG_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            self.timeModel = [[NtpTimeModel alloc] initWithData:(char*)data size:(int)size];
            timezoneIndex = self.timeModel.u32Timezone - 1;
            [self.tableview reloadData];
            break;
        }
        case IOTYPE_USER_IPCAM_SET_NTP_CONFIG_RESP:{
            SMsgAVIoctrlSetDstResp *resp = (SMsgAVIoctrlSetDstResp*)data;
            if(resp->result == 0){
                [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
            }
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
