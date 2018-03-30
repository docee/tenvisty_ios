//
//  TimeSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TimeSetting_AoniViewController.h"
#import "SyncTimeTableViewCell.h"
#import "TimeZoneModel.h"
#import "BaseViewController.h"
#import "NtpTimeModel.h"

@interface TimeSetting_AoniViewController ()<CellModelDelegate>{
    NSString *time;
    NSInteger timezoneIndex;
    NSInteger dst;
}
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labTimezone;
@property (strong,nonatomic) NSArray *listItems;
@property (nonatomic,strong) NtpTimeModel *timeModel;

@end

@implementation TimeSetting_AoniViewController

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
}

-(void)getTime{
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_NTP_CONFIG_REQ Data:(char*)nil DataSize:0];
}

-(void)syncTime:(int)mode{
    if(self.timeModel){
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        NSCalendar *myCal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [myCal componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:[NSDate date]];
        self.timeModel.u32Year    = (int)[dateComponents year];//[GDate cyear].intValue;
        self.timeModel.u32Month   = (int)[dateComponents month];//[GDate cmonth].intValue;
        self.timeModel.u32Day     = (int)[dateComponents day];//[GDate cday].intValue;
        self.timeModel.u32Hour    = (int)[dateComponents hour];//[GDate chour].intValue;
        self.timeModel.u32Minute  = (int)[dateComponents minute];//[GDate cminute].intValue;
        self.timeModel.u32Second  = (int)[dateComponents second];//[GDate csecond].intValue;
        self.timeModel.u32Mode = mode;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        [self syncTime:1];
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
        return 1;
    }
}

-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:nil value:nil placeHodler:nil maxLength:0 viewId:TableViewCell_ListImg],
                         nil];
        NSArray *sec2 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Select time zone") showValue:YES value:nil viewId:TableViewCell_ListImg],
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

//其他界面返回到此界面调用的方法
- (IBAction)TimeSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GET_NTP_CONFIG_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            self.timeModel = [[NtpTimeModel alloc] initWithData:(char*)data size:(int)size];
            time = FORMAT(@"%d-%d-%d %d:%d:%d",self.timeModel.u32Year, self.timeModel.u32Month, self.timeModel.u32Day, self.timeModel.u32Hour, self.timeModel.u32Minute, self.timeModel.u32Second);
            timezoneIndex = self.timeModel.u32Timezone - 1;
            NSString *timezoneId = ((TimeZoneModel*)[[TimeZoneModel getAllOld] objectAtIndex:timezoneIndex]).area;
            [self setRowValue:LOCALSTR(timezoneId) row:0 section:1];
            dst = -1;
            [self.tableView reloadData];
            break;
        }
        case IOTYPE_USER_IPCAM_SET_NTP_CONFIG_RESP:{
            SMsgAVIoctrlSetNtpConfigResp *resp = (SMsgAVIoctrlSetNtpConfigResp*)data;
            if(resp->result == 0){
                [self getTime];
            }
            else{
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                [[iToast makeText:LOCALSTR(@"Setting Failed")] show];
            }
        }
            break;
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
