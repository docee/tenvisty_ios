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
    BOOL isGettingNetType;
    BOOL isRequestWiFiListForResult;
    NSString *wifiPassword;
    NSInteger netType;
}
@property (nonatomic,copy) dispatch_block_t delayTask;
@property (nonatomic,copy) dispatch_block_t timeoutTask;
@property (nonatomic,copy) dispatch_block_t successtTask;
@property (nonatomic,assign) BOOL hasChangedWiFi;
@property (strong,nonatomic) NSArray *listItems;
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

-(dispatch_block_t)successtTask{
    if(_successtTask == nil){
        _successtTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[iToast makeText:LOCALSTR(@"Setting Successfully")] setDuration:1] show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
    return _successtTask;
}
-(dispatch_block_t)delayTask{
    if(_delayTask == nil){
        _delayTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            if(self.camera.isAuthConnected){
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

-(void)doGetNetType{
    isGettingNetType = YES;
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_DEV_INFO_EXT Data:(char *)nil DataSize:0];
}

-(void)doGetWifiList{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_WIFI_LIST Data:(char*)nil DataSize:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doSetWifi:(NSString*)password{
    HI_P2P_S_WIFI_PARAM *req = malloc(sizeof(HI_P2P_S_WIFI_PARAM));
    memset(req, 0, sizeof(HI_P2P_S_WIFI_PARAM));
    req->EncType = self.wifiEnctype;
    req->Mode = self.wifiMode;
    memcpy(req->strSSID, [self.wifiSsid UTF8String], self.wifiSsid.length);
    memcpy(req->strKey, [password UTF8String], password.length);
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_WIFI_PARAM Data:(char*)req DataSize:sizeof(HI_P2P_S_WIFI_PARAM)];
    free(req);
}
-(void)doGetWifi{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_WIFI_PARAM Data:(char*)nil DataSize:0];
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
        [MBProgressHUD showMessag:LOCALSTR(@"setting...") toView:self.tableView].userInteractionEnabled = YES;
        [self doSetWifi:wifiPassword];
    }
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
//        case HI_P2P_GET_DEV_INFO_EXT:{
//            HI_P2P_S_DEV_INFO_EXT *resp = (HI_P2P_S_DEV_INFO_EXT*)data;
//            netType = resp->u32NetType;
//            if(isGettingNetType){
//                isGettingNetType = NO;
//                [self doSetWifi:wifiPassword];
//            }
//        }
//            break;
        case HI_P2P_SET_WIFI_PARAM:{
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), [self successtTask]);
//            //wifi连接
//            if(YES || netType == 1){
//                if(size >0 ){
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [[[iToast makeText:LOCALSTR(@"Setting Successfully")] setDuration:1] show];
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    });
//                }
//                else{
//                    isSetting = NO;
//                     [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
//                }
//            }
//            else{
//                //wired连接
//                if(size >= 0){
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(GET_WIFI_DELAY_WIRED * NSEC_PER_SEC)), dispatch_get_main_queue(),self.delayTask);
//                }
//                else{
//                    [self doGetWifi];
//                }
//            }
            break;
        }
//        case HI_P2P_GET_WIFI_PARAM:{
//            if(isSetting){
//                isSetting = NO;
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                SMsgAVIoctrlGetWifiResp *resp = (SMsgAVIoctrlGetWifiResp*)data;
//                NSString* ssid =  [NSString stringWithUTF8String: (const char*)resp->ssid];
//                NSString* password =  [NSString stringWithUTF8String: (const char*)resp->password];
//                if([ssid isEqualToString:self.wifiSsid] && [password isEqualToString:wifiPassword]){
//                    [[[iToast makeText:LOCALSTR(@"Setting Successfully")] setDuration:1] show];
//                    self.hasChangedWiFi = YES;
//                    [self performSegueWithIdentifier:@"ChangeWiFi2WiFiSetting" sender:self];
//                }
//                else{
//                    [TwsTools presentAlertMsg:self message:LOCALSTR(@"WiFi config failed, pealse check your password and try again")];
//                }
//            }
//            break;
//        }
//        case HI_P2P_GET_WIFI_LIST:{
//            if(isRequestWiFiListForResult && isSetting){
//                isRequestWiFiListForResult = NO;
//                isSetting = NO;
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                HI_P2P_S_WIFI_LIST *p = (HI_P2P_S_WIFI_LIST *)data;
//                for(int i=0;i<p->u32Num;i++){
//                    HI_SWifiAp ap = p->sWifiInfo[i];
//                    if([[NSString stringWithUTF8String:ap.strSSID] isEqualToString:self.wifiSsid]){
//                        if(ap.Status == 1 || ap.Status == 4){
//                            [[[iToast makeText:LOCALSTR(@"Setting Successfully")] setDuration:1] show];
//                            self.hasChangedWiFi = YES;
//                            [self performSegueWithIdentifier:@"ChangeWiFi2WiFiSetting" sender:self];
//                        }
//                        else if(ap.Status == 2){
//                            [TwsTools presentAlertMsg:self message:LOCALSTR(@"WiFi config failed, pealse check your password and try again")];
//                        }
//                        else {
//                            [TwsTools presentAlertMsg:self message:LOCALSTR(@"WiFi config failed, pealse check your password and try again")];
//                        }
//                    }
//                }
//            }
//        }
            
    }
}
- (void)camera:(BaseCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    if(camera.isDisconnect){
        //[camera stop];
        [camera start];
    }
}
- (void)camera:(BaseCamera *)camera _didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status{
    if(camera.isAuthConnected){
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
