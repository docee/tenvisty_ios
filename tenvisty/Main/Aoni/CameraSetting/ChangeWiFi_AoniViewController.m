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
#import "ChangeWiFi_AoniViewController.h"

@interface ChangeWiFi_AoniViewController (){
    BOOL isTimeout;
    BOOL isSetting;
    BOOL isRequestWiFiListForResult;
    NSString *wifiPassword;
}
@property (nonatomic,copy) dispatch_block_t delayTask;
@property (nonatomic,copy) dispatch_block_t timeoutTask;
@property (nonatomic,assign) BOOL hasChangedWiFi;
@property (strong,nonatomic) NSArray *listItems;
@end

@implementation ChangeWiFi_AoniViewController

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
                [self doGetWifi];
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
    req = nil;
}
-(void)doGetWifi{
    SMsgAVIoctrlGetWifiReq *req = malloc(sizeof(SMsgAVIoctrlGetWifiReq));
    memset(req, 0, sizeof(SMsgAVIoctrlGetWifiReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETWIFI_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetWifiReq)];
    free(req);
    req = nil;
}


-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:@"ic_wifi" title:LOCALSTR(@"SSID") showValue:YES value:self.wifiSsid viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:@"ic_password" title:LOCALSTR(@"Password") showValue:YES value:@"" viewId:TableViewCell_TextField_Password],
                         nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}




- (IBAction)save:(id)sender {
    if(!isSetting){
        [self.view endEditing:YES];
        isSetting = YES;
        wifiPassword = [self getRowValue:1 section:0];
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
        case IOTYPE_USER_IPCAM_GETWIFI_RESP:{
            if(isSetting){
                isSetting = NO;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                SMsgAVIoctrlGetWifiResp *resp = (SMsgAVIoctrlGetWifiResp*)data;
                NSString* ssid =  [NSString stringWithUTF8String: (const char*)resp->ssid];
                NSString* password =  [NSString stringWithUTF8String: (const char*)resp->password];
                if([ssid isEqualToString:self.wifiSsid] && [password isEqualToString:wifiPassword]){
                    [[[iToast makeText:LOCALSTR(@"Setting Successfully")] setDuration:1] show];
                    self.hasChangedWiFi = YES;
                    [self performSegueWithIdentifier:@"ChangeWiFi2WiFiSetting" sender:self];
                }
                else{
                    [TwsTools presentAlertMsg:self message:LOCALSTR(@"WiFi config failed, pealse check your password and try again")];
                }
                
            }
            break;
        }
            
    }
}
- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    if(status == CONNECTION_STATE_UNKNOWN_DEVICE || status == CONNECTION_STATE_TIMEOUT || status == CONNECTION_STATE_UNSUPPORTED || status == CONNECTION_STATE_CONNECT_FAILED || status == CONNECTION_STATE_NETWORK_FAILED){
        [camera stop];
        [camera start];
    }
    else if(self.camera.isSleeping){
        [self.camera wakeUp];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [camera start];
        });
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
