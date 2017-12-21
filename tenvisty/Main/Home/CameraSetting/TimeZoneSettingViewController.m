//
//  TimezoneSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TimeZoneSettingViewController.h"
#import "TimeZoneModel.h"

@interface TimeZoneSettingViewController (){
    NSInteger timezoneIndex;
}

@end

@implementation TimeZoneSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}
-(void)setup{
    [self getTimezone];
}

-(void)getTimezone{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    SMsgAVIoctrlGetTimeReq *req = malloc(sizeof(SMsgAVIoctrlGetTimeReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_ZONE_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetTimeReq)];
    free(req);
}

-(void)setTimezone:(NSInteger)index{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    SMsgAVIoctrlSetDstReq *req = malloc(sizeof(SMsgAVIoctrlSetDstReq));
    memset(req, 0, sizeof(SMsgAVIoctrlSetDstReq));
//    if([[NSTimeZone localTimeZone] isDaylightSavingTime] && [[NSTimeZone localTimeZone] isDaylightSavingTimeForDate:[NSDate date]]){
//        req->Enable = 1;
//    }
    req->Enable = 1;
    NSString *area = ((TimeZoneModel*)[[TimeZoneModel getAll] objectAtIndex:index]).area;
    memcpy(req->DstDistId, [area UTF8String], area.length);
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_ZONE_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetTimeReq)];
    free(req);
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
    TimeZoneModel *model = (TimeZoneModel *)[[TimeZoneModel getAll] objectAtIndex:indexPath.row];
    NSString *id = TableViewCell_Detail;
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    cell.labTitle.text = model.area;
    cell.labDesc.text = model.strGMT;
    
    [cell setSelect:indexPath.row == timezoneIndex];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Main.width, 40)];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, Screen_Main.width, 20)];
    labTitle.text = LOCALSTR(@"Select the timezone");
    labTitle.font = [UIFont systemFontOfSize:14];
    [view addSubview:labTitle];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setTimezone:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}
- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GET_ZONE_INFO_RESP:{
            SMsgAVIoctrlGetDstResp *resp = (SMsgAVIoctrlGetDstResp*)data;
            for(int i=0; i < [TimeZoneModel getAll].count; i++){
                TimeZoneModel *tz = [[TimeZoneModel getAll] objectAtIndex:i];
                if([tz.area isEqualToString:[NSString stringWithUTF8String:resp->DstDistrictInfo.DstDistId]]){
                    timezoneIndex = i;
                    break;
                }
            }
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            [self.tableView reloadData];
            break;
            break;
        }
        case IOTYPE_USER_IPCAM_SET_ZONE_INFO_RESP:{
            SMsgAVIoctrlSetDstResp *resp = (SMsgAVIoctrlSetDstResp*)data;
            if(resp->result == 0){
                [[iToast makeText:LOCALSTR(@"setting successfully")] show];
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
