//
//  TimezoneSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TimeZoneSetting_HichipViewController.h"
#import "TimeZoneModel.h"
#import "DetailTableViewCell.h"
#import "HichipCamera.h"

@interface TimeZoneSetting_HichipViewController (){
    NSInteger timezoneIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *labReboot;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) HichipCamera *originCamera;
@property (nonatomic,strong) NSArray *timezoneList;

@end

@implementation TimeZoneSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}
-(void)setup{
    self.navigationController.title = LOCALSTR(@"Time Zone");
    self.labDesc.text = LOCALSTR(@"Select time zone");
    self.labReboot.text = LOCALSTR(@"Notice: Change timezone will reboot device");
    self.originCamera = (HichipCamera*)self.camera.orginCamera;
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_Detail];
    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES].userInteractionEnabled = YES;
    [self getTimezone];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)getTimezone{
    if ([self.originCamera getCommandFunction:HI_P2P_GET_TIME_ZONE_EXT]) {//支持新命令
        self.timezoneList = [TimeZoneModel getAll];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_TIME_ZONE_EXT Data:(char*)nil DataSize:0];
    }else{//不支持就用旧命令
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_TIME_ZONE Data:(char*)nil DataSize:0];
        self.timezoneList = [TimeZoneModel getAllOld];
    }
}

-(void)setTimezone:(NSInteger)index{
    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES].userInteractionEnabled = YES;
    //new timezone
    if(self.originCamera.zkGmTimeZone){
        TimeZoneModel *timezoneModel = (TimeZoneModel*)[[TimeZoneModel getAll] objectAtIndex:index];
        HI_P2P_S_TIME_ZONE_EXT *req = [self.originCamera.zkGmTimeZone model];
        memset(req->sTimeZone, 0, 32);
        memcpy(req->sTimeZone, [timezoneModel.area UTF8String], timezoneModel.area.length);
        req->u32DstMode = 1;
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_TIME_ZONE_EXT Data:(char*)req DataSize:sizeof(HI_P2P_S_TIME_ZONE_EXT)];
        free(req);
        req = nil;
    }
    else if(self.originCamera.gmTimeZone){
        TimeZoneModel *timezoneModel = (TimeZoneModel*)[[TimeZoneModel getAllOld] objectAtIndex:index];
        HI_P2P_S_TIME_ZONE *req = [self.originCamera.gmTimeZone model];
        req->u32DstMode = 1;
        req->s32TimeZone = (int)timezoneModel.timezone;
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_TIME_ZONE Data:(char*)req DataSize:sizeof(HI_P2P_S_TIME_ZONE)];
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
    return  self.timezoneList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    TimeZoneModel *model = (TimeZoneModel *)self.timezoneList[indexPath.row];
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
        case HI_P2P_SET_REBOOT:{
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case HI_P2P_SET_TIME_ZONE:
        case HI_P2P_SET_TIME_ZONE_EXT:{
            if(size >= 0){
                //[self getTimezone];
                
                [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_REBOOT Data:(char*)nil DataSize:0];
            }
            else{
                [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
            }
        }
            break;
            
            //新时区
        case HI_P2P_GET_TIME_ZONE_EXT:{
            if(self.originCamera.zkGmTimeZone){
                for(int i=0; i < [TimeZoneModel getAll].count; i++){
                    TimeZoneModel *tz = [[TimeZoneModel getAll] objectAtIndex:i];
                    if([tz.area isEqualToString:self.originCamera.zkGmTimeZone.timeName]){
                        NSString *timezoneId = ((TimeZoneModel*)[[TimeZoneModel getAll] objectAtIndex:timezoneIndex]).area;
                        [self setRowValue:LOCALSTR(timezoneId) row:0 section:0];
                        timezoneIndex = i;
                        break;
                    }
                }
                [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
                [self.tableview reloadData];
            }
        }
            break;
        case HI_P2P_GET_TIME_ZONE:{
            if(self.originCamera.gmTimeZone){
                for(int i=0; i < [TimeZoneModel getAllOld].count; i++){
                    TimeZoneModel *tz = [[TimeZoneModel getAllOld] objectAtIndex:i];
                    if(tz.timezone == self.originCamera.gmTimeZone.s32TimeZone){
                        NSString *timezoneId = ((TimeZoneModel*)[[TimeZoneModel getAllOld] objectAtIndex:timezoneIndex]).area;
                        [self setRowValue:LOCALSTR(timezoneId) row:0 section:0];
                        timezoneIndex = i;
                        break;
                    }
                }
                [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
                [self.tableview reloadData];
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
