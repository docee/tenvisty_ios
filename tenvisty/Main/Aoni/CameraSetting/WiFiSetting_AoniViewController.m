//
//  WiFiSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#define GET_WIFILIST_TIMEOUT 30

#import "WiFiSetting_AoniViewController.h"
#import "ChangeWiFi_AoniViewController.h"
#import "WifiList.h"

@interface WiFiSetting_AoniViewController ()<MyCameraDelegate>{
    WifiList *wifiSSIDList;
    BOOL isRefreshing;
    WifiAp *selectedAP;
    BOOL needRefresh;
}
@property (nonatomic,copy) dispatch_block_t timeoutTask;
@property (nonatomic,strong) NSString *ssid;
@end

@implementation WiFiSetting_AoniViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}
-(void)setup{
    [self getWifiSetting];
}
-(dispatch_block_t)timeoutTask{
    if(_timeoutTask == nil){
        _timeoutTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            isRefreshing = NO;
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            [[[iToast makeText:LOCALSTR(@"Connection timeout, please try again.")] setDuration:1] show];
        });
    }
    return _timeoutTask;
}
-(dispatch_block_t)newTimeoutTask{
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
    }
    _timeoutTask = nil;
    return self.timeoutTask;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)refreshWifiList:(id)sender {
    needRefresh = NO;
    [self getWifiSetting];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(needRefresh){
        [self refreshWifiList:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
        _timeoutTask = nil;
    }
}

-(void)getWiFiList{
    isRefreshing = YES;
    wifiSSIDList = nil;
    [self.tableView reloadData];
    SMsgAVIoctrlListWifiApReq *req = malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_LISTWIFIAP_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlListWifiApReq)];
    free(req);
    req = nil;
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
}

-(void)getWifiSetting{
    if(isRefreshing){
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(GET_WIFILIST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    isRefreshing = YES;
    wifiSSIDList = nil;
    [self.tableView reloadData];
    SMsgAVIoctrlGetWifiReq *req = malloc(sizeof(SMsgAVIoctrlGetWifiReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETWIFI_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetWifiReq)];
    free(req);
    req = nil;
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      return wifiSSIDList != nil ? wifiSSIDList.u32Num : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_Detail;
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    WifiAp *ap = [wifiSSIDList.wifis objectAtIndex:indexPath.row];
    cell.labTitle.text = ap.strSSID;//[NSString stringWithUTF8String: ap.ssid];
    if([ap.Status intValue] == 1 || [ap.Status intValue] == 3 || [ap.strSSID isEqualToString:self.ssid]){
        cell.labDesc.text = LOCALSTR(@"Connected");
        [cell.labDesc setTextColor:Color_Primary];
    }
    else if([ap.Status intValue] == 2){
        cell.labDesc.text = LOCALSTR(@"Wrong Password");
        [cell.labDesc setTextColor:Color_GrayDark];
    }
    else if([ap.Status intValue] == 4){
        cell.labDesc.text = LOCALSTR(@"Saved");
        [cell.labDesc setTextColor:Color_Primary];
    }
    else{
        cell.labDesc.text = [ap.EncType intValue] == 1?LOCALSTR(@"Open"):LOCALSTR(@"Encrypted");
        [cell.labDesc setTextColor:Color_Gray];
    }
    NSString *strImg = nil;
    if([ap.Signal intValue] > 90){
        strImg = [ap.EncType intValue] == 1?@"wifi_signal4_nolock":@"wifi_signal4_lock";
    }
    else if([ap.Signal intValue] > 60){
        strImg = [ap.EncType intValue] == 1?@"wifi_signal3_nolock":@"wifi_signal3_lock";
    }
    else if([ap.Signal intValue] > 30){
        strImg = [ap.EncType intValue] == 1?@"wifi_signal2_nolock":@"wifi_signal2_lock";
    }
    else{
        strImg = [ap.EncType intValue] == 1?@"wifi_signal1_nolock":@"wifi_signal1_lock";
    }
    [cell.rightImg setImage:[UIImage imageNamed:strImg]];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Main.width, 40)];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, Screen_Main.width, 20)];
    labTitle.text = LOCALSTR(@"AVAILABLE NETWORKS");
    labTitle.font = [UIFont systemFontOfSize:14];
    [view addSubview:labTitle];
    return view;
}
//其他界面返回到此界面调用的方法
- (IBAction)WiFiSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
        UIViewController *controller = unwindSegue.sourceViewController;
    if([controller isKindOfClass:[ChangeWiFi_AoniViewController class]]){
        ChangeWiFi_AoniViewController *cwvc = (ChangeWiFi_AoniViewController *)controller;
        needRefresh = cwvc.hasChangedWiFi;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedAP = [wifiSSIDList.wifis objectAtIndex:indexPath.row];
    NSLog(@"begin :%f",[NSDate timeIntervalSinceReferenceDate]);
   [self performSegueWithIdentifier:@"WiFiSetting2ChangeWiFi" sender:self];
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_LISTWIFIAP_RESP:
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            isRefreshing = NO;
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            wifiSSIDList = [[WifiList alloc] initWithData:(char*)data size:(int)size];
            if(wifiSSIDList.u32Num > 0){
                [wifiSSIDList.wifis sortUsingComparator:^NSComparisonResult(WifiAp *obj1, WifiAp *obj2) {
                    return obj1.Signal > obj2.Signal ? NSOrderedAscending : (obj1.Signal == obj2.Signal ? NSOrderedSame :NSOrderedDescending);
                }];
                WifiAp *firstAp = [wifiSSIDList.wifis objectAtIndex:0];
                if([firstAp.strSSID isEqualToString:self.ssid]){
                    for(int i=0;i<wifiSSIDList.u32Num;i++){
                        WifiAp *tempAp = [wifiSSIDList.wifis objectAtIndex:i];
                        if([tempAp.strSSID isEqualToString:self.ssid]){
                            [wifiSSIDList.wifis exchangeObjectAtIndex:i withObjectAtIndex:0];
                            break;
                        }
                    }
                }
            }
            [self.tableView reloadData];
            break;
        case IOTYPE_USER_IPCAM_GETWIFI_RESP:{
            SMsgAVIoctrlGetWifiResp *resp = (SMsgAVIoctrlGetWifiResp*)data;
            self.ssid = [NSString stringWithUTF8String:(char*)resp->ssid];
            [self getWiFiList];
        }
            break;
            
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"WiFiSetting2ChangeWiFi"]){
        ChangeWiFi_AoniViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
        controller.wifiSsid = selectedAP.strSSID;// [NSString stringWithUTF8String: selectedAP.ssid];
        controller.wifiMode = [selectedAP.Mode intValue];
        controller.wifiEnctype = [selectedAP.EncType intValue];
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
