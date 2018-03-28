//
//  TimeSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TimeSetting_HichipViewController.h"
#import "SyncTimeTableViewCell.h"
#import "TimeZoneModel.h"
#import "BaseViewController.h"
#import "TimeParam.h"
#import "HichipCamera.h"

@interface TimeSetting_HichipViewController (){
    NSString *time;
    NSInteger timezoneIndex;
    NSInteger dst;
}
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labTimezone;
@property (strong,nonatomic) NSArray *listItems;
@property (nonatomic,strong) HichipCamera *originCamera;

@end

@implementation TimeSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setup];
}

-(void)setup{
    self.originCamera = (HichipCamera*)self.camera.orginCamera;
    [self getTime];
    [self getTimezone];
}

-(void)getTime{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_TIME_PARAM Data:(char*)nil DataSize:0];
}

-(void)syncTime{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [self.camera syncWithPhoneTime];
}

-(void)getTimezone{
    dst = -1;
    timezoneIndex = -1;
    if ([self.originCamera getCommandFunction:HI_P2P_GET_TIME_ZONE_EXT]) {//支持新命令
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_TIME_ZONE_EXT Data:(char*)nil DataSize:0];
    }else{//不支持就用旧命令
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_TIME_ZONE Data:(char*)nil DataSize:0];
    }
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
    //new timezone
    if(self.originCamera.zkGmTimeZone){
        HI_P2P_S_TIME_ZONE_EXT *req = [self.originCamera.zkGmTimeZone model];
        req->u32DstMode = enable ? 1 : 0;
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_TIME_ZONE_EXT Data:(char*)req DataSize:sizeof(HI_P2P_S_TIME_ZONE_EXT)];
        free(req);
        req = nil;
    }
    else if(self.originCamera.gmTimeZone){
        HI_P2P_S_TIME_ZONE *req = [self.originCamera.gmTimeZone model];
        req->u32DstMode = enable ? 1 : 0;
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_TIME_ZONE Data:(char*)req DataSize:sizeof(HI_P2P_S_TIME_ZONE)];
        free(req);
        req = nil;
    }
}


//其他界面返回到此界面调用的方法
- (IBAction)TimeSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_TIME_PARAM:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            TimeParam *timePara = [[TimeParam alloc] initWithData:(char*)data size:(int)size];
            
            time = timePara.time;
            [self.tableView reloadData];
            break;
        }
            //新时区
        case HI_P2P_GET_TIME_ZONE_EXT:{
            if(self.originCamera.zkGmTimeZone){
                for(int i=0; i < [TimeZoneModel getAll].count; i++){
                    TimeZoneModel *tz = [[TimeZoneModel getAll] objectAtIndex:i];
                    if([tz.area isEqualToString:self.originCamera.zkGmTimeZone.timeName]){
                        NSString *timezoneId = ((TimeZoneModel*)[[TimeZoneModel getAll] objectAtIndex:i]).area;
                        [self setRowValue:LOCALSTR(timezoneId) row:0 section:1];
                        timezoneIndex = i;
                        if(tz.dst){
                            dst = self.originCamera.zkGmTimeZone.dst;
                            [self setRowValue:FORMAT(@"%ld",(long)dst) row:1 section:1];
                        }
                        else{
                            dst = -1;
                        }
                        break;
                    }
                }
                [self.tableView reloadData];
            }
        }
            break;
        case HI_P2P_GET_TIME_ZONE:{
            if(self.originCamera.gmTimeZone){
                for(int i=0; i < [TimeZoneModel getAllOld].count; i++){
                    TimeZoneModel *tz = [[TimeZoneModel getAllOld] objectAtIndex:i];
                    if(tz.timezone == self.originCamera.gmTimeZone.s32TimeZone){
                        NSString *timezoneId = ((TimeZoneModel*)[[TimeZoneModel getAllOld] objectAtIndex:i]).area;
                        [self setRowValue:LOCALSTR(timezoneId) row:0 section:1];
                        timezoneIndex = i;
                        if(tz.dst){
                            dst = self.originCamera.gmTimeZone.u32DstMode;
                            [self setRowValue:FORMAT(@"%ld",(long)dst) row:1 section:1];
                        }
                        else{
                            dst = -1;
                        }
                        break;
                    }
                }
                [self.tableView reloadData];
            }
        }
            break;
        case HI_P2P_SET_TIME_PARAM:{
            
            if(size >= 0){
                //内部处理， 在设置完时间后自动获取时间
                //[self getTime];
            }
            else{
                [[iToast makeText:LOCALSTR(@"sync failed")] show];
            }
            break;
        }
        case HI_P2P_SET_TIME_ZONE_EXT:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            if(size >= 0){
                [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
            }
            else{
                [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
            }
        }
            break;
        case HI_P2P_SET_TIME_ZONE:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            
            if(size >= 0){
                [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
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

