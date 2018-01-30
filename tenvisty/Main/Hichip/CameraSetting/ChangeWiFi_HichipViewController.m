//
//  ChangeWiFiViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//
#define SET_WIFI_TIMEOUT 70
#define GET_WIFI_DELAY_WIRED 45
#define GET_WIFI_DELAY_WIRELESS 10
#import "ChangeWiFi_HichipViewController.h"

@interface ChangeWiFi_HichipViewController (){
    BOOL isTimeout;
    BOOL isSetting;
    BOOL isRequestWiFiListForResult;
    NSString *wifiPassword;
}
@property (nonatomic,copy) dispatch_block_t delayTask;
@property (nonatomic,copy) dispatch_block_t timeoutTask;
@property (nonatomic,assign) BOOL hasChangedWiFi;
@end

@implementation ChangeWiFi_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

-(void)setup{
    
}
-(dispatch_block_t)timeoutTask{
    if(_timeoutTask == nil){
        _timeoutTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            isTimeout = YES;
            isSetting = NO;
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"Connection timeout, please try again.")];
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

-(dispatch_block_t)delayTask{
    if(_delayTask == nil){
        _delayTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            if(self.camera.cameraConnectState == CONNECTION_STATE_CONNECTED){
                isRequestWiFiListForResult = YES;
                [self doGetWifiList];
            }
            
        });
    }
    return _delayTask;
}
-(dispatch_block_t)newDelayTask{
    if(_delayTask != nil){
        dispatch_block_cancel(_delayTask);
    }
    _delayTask = nil;
    return self.delayTask;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
        _timeoutTask = nil;
    }
    if(_delayTask != nil){
        dispatch_block_cancel(_delayTask);
        _delayTask = nil;
    }
}

-(void)doGetWifiList{
    SMsgAVIoctrlListWifiApReq *req = malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_LISTWIFIAP_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlListWifiApReq)];
    free(req);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doSetWifi:(NSString*)password{
    [MBProgressHUD showMessag:LOCALSTR(@"setting...") toView:self.tableView].userInteractionEnabled = YES;
    SMsgAVIoctrlSetWifiReq *req = malloc(sizeof(SMsgAVIoctrlSetWifiReq));
    memset(req, 0, sizeof(SMsgAVIoctrlSetWifiReq));
    req->enctype = self.wifiEnctype;
    req->mode = self.wifiMode;
    memcpy(req->ssid, [self.wifiSsid UTF8String], self.wifiSsid.length);
    memcpy(req->password, [password UTF8String], password.length);
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SETWIFI_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetWifiReq)];
    free(req);
}
-(void)doGetWifi{
    SMsgAVIoctrlGetWifiReq *req = malloc(sizeof(SMsgAVIoctrlGetWifiReq));
    memset(req, 0, sizeof(SMsgAVIoctrlGetWifiReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETWIFI_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetWifiReq)];
    free(req);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    if(indexPath.row == 0){
        NSString *id = TableViewCell_TextField_Disable;
        TextFieldDisableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
        cell.title = LOCALSTR(@"SSID");
        cell.value = self.wifiSsid;
        cell.leftImage = @"ic_wifi";
        NSLog(@"end1 :%f",[NSDate timeIntervalSinceReferenceDate]);
        return cell;
    }
    else{
        NSString *id = TableViewCell_TextField_Password;
        PasswordFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
        cell.title = LOCALSTR(@"Password");
        cell.leftImage = @"ic_password";
        //[cell.midPasswordField becomeFirstResponder];
        NSLog(@"end2 :%f",[NSDate timeIntervalSinceReferenceDate]);
        return cell;
    }
    return nil;
}


- (IBAction)save:(id)sender {
    if(!isSetting){
        isSetting = YES;
        TwsTableViewCell* cell = (TwsTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell resignFirstResponder];
        wifiPassword = cell.value;
        if(self.wifiEnctype != 1&& wifiPassword.length == 0){
            [[[iToast makeText:LOCALSTR(@"wifi password is not entered.")] setDuration:1] show];
             isSetting = YES;
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SET_WIFI_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
        [self doSetWifi:wifiPassword];
    }
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_SETWIFI_RESP:{
            SMsgAVIoctrlSetWifiResp *resp = (SMsgAVIoctrlSetWifiResp*)data;
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            if(resp->result == 0){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(GET_WIFI_DELAY_WIRED * NSEC_PER_SEC)), dispatch_get_main_queue(),self.delayTask);
            }
            else{
                [self doGetWifi];
            }
            break;
        }
        case IOTYPE_USER_IPCAM_UPDATE_WIFI_STATUS:{
            SMsgAVIoctrlUpdateWifiStatus *resp = (SMsgAVIoctrlUpdateWifiStatus*)data;
            if([[NSString stringWithUTF8String: resp->ssid] isEqualToString:self.wifiSsid]){
                if(_delayTask != nil){
                    dispatch_block_cancel(_delayTask);
                    _delayTask = nil;
                }
                [self doGetWifiList];
                if(isSetting){
                    isSetting = NO;
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if(resp->status == 2){
                        [TwsTools presentAlertMsg:self message:LOCALSTR(@"Wi-Fi password wrong")];
                    }
                    else if(resp->status == 1){
                        [TwsTools presentAlertMsg:self message:LOCALSTR(@"Fail to connect Wi-Fi, please try again later.")];
                    }
                    else if(resp ->status == 0){
                        [[[iToast makeText:LOCALSTR(@"setting successfully")] setDuration:1] show];
                        self.hasChangedWiFi = YES;
                        [self performSegueWithIdentifier:@"ChangeWiFi2WiFiSetting" sender:self];
                    }
                }
            }
            break;
        }
        case IOTYPE_USER_IPCAM_GETWIFI_RESP:{
            if(isSetting){
                isSetting = NO;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                SMsgAVIoctrlGetWifiResp *resp = (SMsgAVIoctrlGetWifiResp*)data;
                NSString* ssid =  [NSString stringWithUTF8String: (const char*)resp->ssid];
                NSString* password =  [NSString stringWithUTF8String: (const char*)resp->password];
                if([ssid isEqualToString:self.wifiSsid] && [password isEqualToString:wifiPassword]){
                    [[[iToast makeText:LOCALSTR(@"setting successfully")] setDuration:1] show];
                    self.hasChangedWiFi = YES;
                    [self performSegueWithIdentifier:@"ChangeWiFi2WiFiSetting" sender:self];
                }
                else{
                    [TwsTools presentAlertMsg:self message:LOCALSTR(@"WiFi config failed, pealse check your password and try again")];
                }
                
            }
            break;
        }
        case IOTYPE_USER_IPCAM_LISTWIFIAP_RESP:{
            if(isRequestWiFiListForResult && isSetting){
                isRequestWiFiListForResult = NO;
                isSetting = NO;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                SMsgAVIoctrlListWifiApResp *p = (SMsgAVIoctrlListWifiApResp *)data;
                for(int i=0;i<p->number;i++){
                    SWifiAp ap = p->stWifiAp[i];
                    if([[NSString stringWithUTF8String:ap.ssid] isEqualToString:self.wifiSsid]){
                        if(ap.status == 1 || ap.status == 4){
                            [[[iToast makeText:LOCALSTR(@"setting successfully")] setDuration:1] show];
                            self.hasChangedWiFi = YES;
                            [self performSegueWithIdentifier:@"ChangeWiFi2WiFiSetting" sender:self];
                        }
                        else if(ap.status == 2){
                            [TwsTools presentAlertMsg:self message:LOCALSTR(@"WiFi config failed, pealse check your password and try again")];
                        }
                        else {
                            [TwsTools presentAlertMsg:self message:LOCALSTR(@"WiFi config failed, pealse check your password and try again")];
                        }
                    }
                }
            }
        }
            
    }
}
- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    if(status == CONNECTION_STATE_UNKNOWN_DEVICE || status == CONNECTION_STATE_TIMEOUT || status == CONNECTION_STATE_UNSUPPORTED || status == CONNECTION_STATE_CONNECT_FAILED || status == CONNECTION_STATE_NETWORK_FAILED){
        [camera stop];
        [camera start];
    }
}
- (void)camera:(NSCamera *)camera _didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status{
    if(status == CONNECTION_STATE_CONNECTED){
        if(isSetting){
            if(_delayTask != nil){
                dispatch_block_cancel(_delayTask);
                _delayTask = nil;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(GET_WIFI_DELAY_WIRELESS* NSEC_PER_SEC)), dispatch_get_main_queue(),[self newDelayTask] );
        }
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
