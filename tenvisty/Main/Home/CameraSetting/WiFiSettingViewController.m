//
//  WiFiSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#define GET_WIFILIST_TIMEOUT 30

#import "WiFiSettingViewController.h"
#import "ChangeWiFiViewController.h"

@interface WiFiSettingViewController ()<MyCameraDelegate>{
    SWifiAp wifiSSIDList[28];
    int wifiSSIDListCount;
    BOOL isRefreshing;
    dispatch_block_t timeoutTask;
    SWifiAp selectedAP;
}

@end

@implementation WiFiSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}
-(void)setup{
    timeoutTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        isRefreshing = NO;
        [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
        [[iToast makeText:LOCALSTR(@"Connection timeout, please try again.")] show];
    });
    [self getWiFiList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)refreshWifiList:(id)sender {
    
      [self getWiFiList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)getWiFiList{
    if(isRefreshing){
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(GET_WIFILIST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), timeoutTask);
    isRefreshing = YES;
    wifiSSIDListCount = 0;
    [self.tableView reloadData];
    SMsgAVIoctrlListWifiApReq *req = malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_LISTWIFIAP_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlListWifiApReq)];
    free(req);
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      return wifiSSIDList != nil && wifiSSIDListCount >= 0 ? wifiSSIDListCount : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_Detail;
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    SWifiAp ap = wifiSSIDList[indexPath.row];
    cell.labTitle.text = [NSString stringWithUTF8String: ap.ssid];
    if(ap.status == 1 || ap.status == 3){
        cell.labDesc.text = LOCALSTR(@"Connected");
        [cell.labDesc setTextColor:Color_Primary];
    }
    else if(ap.status == 2){
        cell.labDesc.text = LOCALSTR(@"Wrong Password");
        [cell.labDesc setTextColor:Color_GrayDark];
    }
    else if(ap.status == 4){
        cell.labDesc.text = LOCALSTR(@"Saved");
        [cell.labDesc setTextColor:Color_Primary];
    }
    else{
        cell.labDesc.text = ap.enctype == 1?LOCALSTR(@"Open"):LOCALSTR(@"Encrypted");
        [cell.labDesc setTextColor:Color_Gray];
    }
    NSString *strImg = nil;
    if(ap.signal > 90){
        strImg = ap.enctype == 1?@"wifi_signal4_nolock":@"wifi_signal4_lock";
    }
    else if(ap.signal > 60){
        strImg = ap.enctype == 1?@"wifi_signal3_nolock":@"wifi_signal3_lock";
    }
    else if(ap.signal > 30){
        strImg = ap.enctype == 1?@"wifi_signal2_nolock":@"wifi_signal2_lock";
    }
    else{
        strImg = ap.enctype == 1?@"wifi_signal1_nolock":@"wifi_signal1_lock";
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
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedAP = wifiSSIDList[indexPath.row];
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
            dispatch_block_cancel(timeoutTask);
            isRefreshing = NO;
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            memset(wifiSSIDList, 0, sizeof(wifiSSIDList));
            
            SMsgAVIoctrlListWifiApResp *p = (SMsgAVIoctrlListWifiApResp *)data;
            
            wifiSSIDListCount = p->number;
            memcpy(wifiSSIDList, p->stWifiAp, size - sizeof(p->number));
            SWifiAp tmpAp = wifiSSIDList[0];
            for(int i=0;i<wifiSSIDListCount;i++){
                if(wifiSSIDList[i].status != 0){
                    wifiSSIDList[0] = wifiSSIDList[i];
                    wifiSSIDList[i] = tmpAp;
                    break;
                }
            }
            [self.tableView reloadData];
            break;
            
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"WiFiSetting2ChangeWiFi"]){
        ChangeWiFiViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
        controller.wifiSsid =  [NSString stringWithUTF8String: selectedAP.ssid];
        controller.wifiMode = selectedAP.mode;
        controller.wifiEnctype = selectedAP.enctype;
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
