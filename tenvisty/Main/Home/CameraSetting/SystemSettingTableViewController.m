//
//  SystemSettingTableViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#define REBOOT_WAIT_TIMEOUT 60

#import "SystemSettingTableViewController.h"
#import "MyCamera.h"


@interface SystemSettingTableViewController (){
    NSInteger updateState;
    NSInteger resetState;
    NSInteger rebootState;
    NSString *accCustomTypeVersion;
    NSString *accVendorTypeVersion;
    NSString *accSystemTypeVersion;
}

@property (nonatomic,copy) dispatch_block_t timeoutTask;
@property (nonatomic,strong) MyCamera *myCamera;
@end

@implementation SystemSettingTableViewController

-(dispatch_block_t)timeoutTask{
    if(_timeoutTask == nil){
        _timeoutTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.btnReset setBackgroundImage:[SystemSettingTableViewController imageWithColor:Color_Gray] forState:UIControlStateHighlighted];
//    [self.btnReboot setBackgroundImage:[SystemSettingTableViewController imageWithColor:Color_Gray] forState:UIControlStateHighlighted];
//    [self.btnCheckFm setBackgroundImage:[SystemSettingTableViewController imageWithColor:Color_Gray] forState:UIControlStateHighlighted];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setup];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
        _timeoutTask = nil;
    }
}

-(void)setup{
    self.myCamera = self.camera.cameraDelegate;
    updateState = -1;
    resetState = -1;
    rebootState = -1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(void)doReset{
    resetState = 0;
    [MBProgressHUD showMessag:LOCALSTR(@"Resetting...") toView:self.tableView].userInteractionEnabled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REBOOT_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    SMsgAVIoctrlExGetAlarmRingReq *req = malloc(sizeof(SMsgAVIoctrlExGetAlarmRingReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_RESET_DEFAULT_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlExGetAlarmRingReq)];
    free(req);
}
-(void)doReboot{
    rebootState = 0;
    [MBProgressHUD showMessag:LOCALSTR(@"Rebooting...") toView:self.tableView].userInteractionEnabled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REBOOT_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    SMsgAVIoctrlExGetAlarmRingReq *req = malloc(sizeof(SMsgAVIoctrlExGetAlarmRingReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_REBOOT_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlExGetAlarmRingReq)];
    free(req);
    
}
-(void)doGetAccFmInfo{
    updateState = 0;
    [MBProgressHUD showMessag:LOCALSTR(@"Checking...") toView:self.tableView].userInteractionEnabled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REBOOT_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    SMsgAVIoctrlExGetAlarmRingReq *req = malloc(sizeof(SMsgAVIoctrlExGetAlarmRingReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_FIRMWARE_INFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlExGetAlarmRingReq)];
    free(req);
}

//根据url获取固件信息
-(void)getFMInfo:(NSString*)localUrl upgradeUrl:(NSString*)remoteUrl systemType:(NSString*)sysType customType:(NSString*)cusType vendorType:(NSString*)vendType{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *systemTypeResp = [self getHttpResp:FORMAT(@"%@%@%@",remoteUrl,sysType,@"msg.json")];
        NSString *customTypeResp = [self getHttpResp:FORMAT(@"%@%@%@",remoteUrl,cusType,@"msg.json")];
        NSString *vendTypeResp = [self getHttpResp:FORMAT(@"%@%@%@",remoteUrl,vendType,@"msg.json")];
        [self checkFM:systemTypeResp customType:customTypeResp vendorType:vendTypeResp];
    });
}

-(NSString*)getHttpResp:(NSString*)url{
    NSString* webStringURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url1 = [NSURL URLWithString:webStringURL];
    NSLog(@"webStringURL = %@", webStringURL);
    //創建一個請求
    NSURLRequest * pRequest = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //建立連接
    NSURLResponse * pResponse = nil;
    NSError * pError = nil;
    //向伺服器發起請求（發出後線程就會一直等待伺服器響應，知道超出最大響應事件），獲取數據後，轉換為NSData類型數據
    NSData * pData = [NSURLConnection sendSynchronousRequest:pRequest returningResponse:&pResponse error:&pError];
    //輸出數據，查看，??後期還可以解析數據
    NSString *responseStr = [[NSString alloc] initWithData:pData encoding:NSUTF8StringEncoding];
    NSLog(@"htmlString = %@", responseStr);
    return responseStr;
}

//比较固件版本是否可以升级
-(void)checkFM:(NSString*)systemType customType:(NSString*)cusType vendorType:(NSString*)vendType{
    NSError *error = nil;
    NSString *systemTypeVersion = nil;
    NSString *systemCheck = nil;
    NSString *webCheck = nil;
    NSString *usrCheck = nil;
    NSString *customTypeVersion = nil;
    NSString *customTypeCheck = nil;
    NSString *vendorTypeVersion = nil;
    NSString *vendorTypeCheck = nil;
    
    id sysTypeJsonObj = [NSJSONSerialization JSONObjectWithData:[[systemType substringToIndex:systemType.length] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    
    if(sysTypeJsonObj != nil && [sysTypeJsonObj isKindOfClass:[NSDictionary class]]){
        NSDictionary *jsonDic = (NSDictionary *)sysTypeJsonObj;
        NSArray *sysTypeDirect =  jsonDic[@"Direct"];
        if(sysTypeDirect != nil){
            if([[sysTypeDirect objectAtIndex:0] isKindOfClass:[NSDictionary class]]){
                systemTypeVersion = [sysTypeDirect objectAtIndex:0][@"Version"];
                systemCheck = [sysTypeDirect objectAtIndex:0][@"SystemCheck"];
                webCheck = [sysTypeDirect objectAtIndex:0][@"WebCheck"];
                usrCheck = [sysTypeDirect objectAtIndex:0][@"UsrCheck"];
            }
        }
    }
    
    id cusTypeJsonObj = [NSJSONSerialization JSONObjectWithData:[[cusType substringToIndex:cusType.length] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    
    if(cusTypeJsonObj != nil && [cusTypeJsonObj isKindOfClass:[NSDictionary class]]){
        NSDictionary *jsonDic = (NSDictionary *)cusTypeJsonObj;
        NSArray *cusTypeDirect =  jsonDic[@"Direct"];
        if(cusTypeDirect != nil){
            if([[cusTypeDirect objectAtIndex:0] isKindOfClass:[NSDictionary class]]){
                customTypeVersion = [cusTypeDirect objectAtIndex:0][@"Version"];
                customTypeCheck = [cusTypeDirect objectAtIndex:0][@"SystemCheck"];
            }
        }
    }
    
    id vendTypeJsonObj = [NSJSONSerialization JSONObjectWithData:[[vendType substringToIndex:vendType.length] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    
    if(vendTypeJsonObj != nil && [vendTypeJsonObj isKindOfClass:[NSDictionary class]]){
        NSDictionary *jsonDic = (NSDictionary *)vendTypeJsonObj;
        NSArray *vendTypeDirect =  jsonDic[@"Direct"];
        if(vendTypeDirect != nil){
             if([[vendTypeDirect objectAtIndex:0] isKindOfClass:[NSDictionary class]]){
                vendorTypeVersion = [vendTypeDirect objectAtIndex:0][@"Version"];
                vendorTypeCheck = [vendTypeDirect objectAtIndex:0][@"VendorCheck"];
             }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    });
    dispatch_block_cancel(_timeoutTask);
    if(systemTypeVersion == nil || systemCheck == nil|| webCheck == nil|| usrCheck == nil|| customTypeVersion == nil|| customTypeCheck == nil|| vendorTypeVersion == nil|| vendorTypeCheck == nil){
        [TwsTools presentAlertMsg:self message:LOCALSTR(@"It is the latest version already")];
        return;
    }
    else
    {
        if([systemTypeVersion compare:accSystemTypeVersion] >0 || [customTypeVersion compare:accCustomTypeVersion] >0 || [vendorTypeVersion compare:accVendorTypeVersion]>0 ){
            [TwsTools presentAlertTitle:self title:LOCALSTR(@"Prompt") message:LOCALSTR(@"new firmware is available, update?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
                [self upgradeFM:systemTypeVersion systemCheck:systemCheck webCheck:webCheck userCheck:usrCheck customTypeVersion:customTypeVersion customTypeCheck:customTypeCheck vendorTypeVersion:vendorTypeVersion vendorTypeCheck:vendorTypeCheck];
            } actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
        }
        else{
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"It is the latest version already")];
        }
        
    }
}

//获取服务器固件URL
-(void)getFMUrl{
    SMsgAVIoctrlExGetAlarmRingReq *req = malloc(sizeof(SMsgAVIoctrlExGetAlarmRingReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_UPRADE_URL_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlExGetAlarmRingReq)];
    free(req);
}
-(void)upgradeFM:(NSString*)sysTypeVersion systemCheck:(NSString*)sysCheck webCheck:(NSString*)wbcheck userCheck:(NSString*)usrCheck customTypeVersion:(NSString*)cusTypeVersion customTypeCheck:(NSString*)cusTypeCheck vendorTypeVersion:(NSString*)vendTypeVersion vendorTypeCheck:(NSString*)vendTypeCheck{
    
    [MBProgressHUD showMessag:LOCALSTR(@"Updating...") toView:self.tableView].userInteractionEnabled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REBOOT_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    SMsgAVIoctrlSetUpgradeReq *req = malloc(sizeof(SMsgAVIoctrlSetUpgradeReq));
    memset(req, 0, sizeof(SMsgAVIoctrlSetUpgradeReq));
    memcpy(req->CustomInfo.customcheck, [cusTypeCheck UTF8String], cusTypeCheck.length);
    memcpy(req->CustomInfo.version, [cusTypeVersion UTF8String], cusTypeVersion.length);
    memcpy(req->SystemInfo.systemcheck, [sysCheck UTF8String], sysCheck.length);
    memcpy(req->SystemInfo.usrcheck, [usrCheck UTF8String], usrCheck.length);
    memcpy(req->SystemInfo.version, [sysTypeVersion UTF8String], sysTypeVersion.length);
    memcpy(req->SystemInfo.webcheck, [wbcheck UTF8String], wbcheck.length);
    memcpy(req->VendorInfo.vendorcheck, [vendTypeCheck UTF8String], vendTypeCheck.length);
    memcpy(req->VendorInfo.version, [vendTypeVersion UTF8String], vendTypeVersion.length);
    req->SerType = 0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_UPRADE_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetUpgradeReq)];
    free(req);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //reset
    if(indexPath.section == 0){
        [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Setup data will be initialized. Are you sure to reset?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            [self doReset];
        } defaultActionStyle:UIAlertActionStyleDestructive actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
    }
    //reboot
    else if(indexPath.section == 1){
        [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Are you sure to reboot camera?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            [self doReboot];
        } defaultActionStyle:UIAlertActionStyleDestructive actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
    }
    //check new firmware
    else if(indexPath.section == 2){
        self.myCamera.upgradePercent = 0;
        [self doGetAccFmInfo];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_REBOOT_RESP:{
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            SMsgAVIoctrlResultResp *resp = (SMsgAVIoctrlResultResp*)data;
            //重启成功
            if(resp->result ==0){
                rebootState = 1;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [TwsTools presentAlertMsg:self message:LOCALSTR(@"Reboot failed, please try again.")];
            }
        
            break;
        }
        case IOTYPE_USER_IPCAM_RESET_DEFAULT_RESP:{
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            SMsgAVIoctrlResultResp *resp = (SMsgAVIoctrlResultResp*)data;
            //复位成功
            if(resp->result ==0){
                resetState = 1;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [TwsTools presentAlertMsg:self message:LOCALSTR(@"Reboot failed, please try again.")];
            }
            break;
        }
        case IOTYPE_USER_IPCAM_GET_UPRADE_URL_RESP:{
            SMsgAVIoctrlGetUpgradeResp *resp = (SMsgAVIoctrlGetUpgradeResp *)data;
            [self getFMInfo:[NSString stringWithUTF8String:resp->LocalUrl] upgradeUrl:[NSString stringWithUTF8String:resp->UpgradeUrl] systemType:[NSString stringWithUTF8String:resp->SystemType] customType:[NSString stringWithUTF8String:resp->CustomType] vendorType:[NSString stringWithUTF8String:resp->VendorType]];
            break;
        }
            //no use
        case IOTYPE_USER_IPCAM_UPGRADE_STATUS:{
            SMsgAVIoctrlUpgradeStatus *resp = (SMsgAVIoctrlUpgradeStatus*)data;
            updateState = 2;
            if(resp->p >=100){
                updateState =3;
                [[[iToast makeText:LOCALSTR(@"Firmwre update success, camera will reboot later, please wait a moment.")] setDuration:1] show];
            }
            else{
                [MBProgressHUD showMessag:FORMAT(LOCALSTR(@"Updating %d%%"),resp->p) toView:self.tableView];
            }
            break;
        }
        case IOTYPE_USER_IPCAM_GET_FIRMWARE_INFO_RESP:{
            SMsgAVIoctrlFirmwareInfoResp *resp = (SMsgAVIoctrlFirmwareInfoResp*)data;
            NSString *fmVer =[NSString stringWithUTF8String:resp->FirmwareVer];
            NSArray *arrFm = [fmVer componentsSeparatedByString:@"."];
            if(arrFm.count >= 5){
                accCustomTypeVersion = [arrFm objectAtIndex:0];
                accVendorTypeVersion = [arrFm objectAtIndex:1];
                accSystemTypeVersion = FORMAT(@"%@.%@.%@",[arrFm objectAtIndex:2],[arrFm objectAtIndex:3], [arrFm objectAtIndex:4]);
            }
            if(updateState != 0){
                return;
            }
            updateState = 1;
            if(accSystemTypeVersion != nil){
                [self getFMUrl];
            }
            else{
                [TwsTools presentAlertMsg:self message:LOCALSTR(@"Get firmware info failed, please try again later.") ];
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                if(_timeoutTask != nil){
                    dispatch_block_cancel(_timeoutTask);
                    _timeoutTask = nil;
                }
            }
            break;
        }
        case IOTYPE_USER_IPCAM_SET_UPRADE_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            SMsgAVIoctrlResultResp *resp = (SMsgAVIoctrlResultResp *)data;
            if(resp->result == 0){
                updateState =1;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [TwsTools presentAlertMsg:self message:LOCALSTR(@"update firmware failed")];
            }
            break;
        }
        default:
            break;
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
