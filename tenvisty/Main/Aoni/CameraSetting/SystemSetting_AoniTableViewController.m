//
//  SystemSettingTableViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#define REBOOT_WAIT_TIMEOUT 60

#import "SystemSetting_AoniTableViewController.h"
#import "MyCamera.h"
#include "UpgradeModel_Aoni.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/time.h>

@interface SystemSetting_AoniTableViewController (){
    NSInteger updateState;
    NSInteger resetState;
    NSInteger rebootState;
}

@property (nonatomic,copy) dispatch_block_t timeoutTask;
@property (nonatomic,strong) MyCamera *originCamera;
@property (nonatomic, copy) NSString *onlineVersion;
@property (nonatomic, copy) NSString *urlAddress;
@property (nonatomic, strong) UpgradeModel_Aoni *download;
@end

@implementation SystemSetting_AoniTableViewController

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
    self.originCamera = (MyCamera*)self.camera.orginCamera;
    updateState = -1;
    resetState = -1;
    rebootState = -1;
    _download = [[UpgradeModel_Aoni alloc] init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(void)doReboot{
    rebootState = 0;
    [MBProgressHUD showMessag:LOCALSTR(@"Rebooting...") toView:self.tableView].userInteractionEnabled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REBOOT_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_REBOOT_SYSTEM_REQ Data:(char*)nil DataSize:0];
}
-(void)doGetAccFmInfo{
    updateState = 0;
    [MBProgressHUD showMessag:LOCALSTR(@"Checking...") toView:self.tableView].userInteractionEnabled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REBOOT_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_DEVINFO_REQ Data:(char*)nil DataSize:0];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Are you sure to reboot camera?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            [self doReboot];
        } defaultActionStyle:UIAlertActionStyleDestructive actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:^{
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
        }];
    }
    else if(indexPath.section == 1){
        [self doGetAccFmInfo];\
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_REBOOT_SYSTEM_RESP:{
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            SMsgAVIoctrlResultResp *resp = (SMsgAVIoctrlResultResp*)data;
            //重启成功
            if(resp->result == 0){
                rebootState = 1;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [TwsTools presentAlertMsg:self message:LOCALSTR(@"Reboot failed, please try again.")];
            }
            break;
        }
            
        case IOTYPE_USER_IPCAM_DEVINFO_RESP:{
            if(updateState != 0){
                return;
            }
            updateState = 1;
            if(self.originCamera.deviceInfo){
                [self requestOnlineVersion];
            }
            else{
                [TwsTools presentAlertMsg:self message:LOCALSTR(@"Get firmware info failed, please try again later.") ];
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            }
            break;
        }
        case IOTYPE_USER_IPCAM_REMOTE_UPGRADE_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            SMsgAVIoctrlRemoteUpgradeResp *resp = (SMsgAVIoctrlRemoteUpgradeResp*)data;
            //upgrading...
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            if(resp->result == 0){
                updateState =1;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else if(resp->result == 1){
                [TwsTools presentAlertMsg:self message:LOCALSTR(@"It is the latest version already")];
                updateState = -1;
            }
            else if(resp->result == -1){
                [TwsTools presentAlertMsg:self message:LOCALSTR(@"The camera is upgrading...") actionDefaultBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }
        }
            break;
        default:
            break;
    }
}


-(void) requestOnlineVersion {
    
    //20160706  更换新的服务器地址以及新格式json数据
    //  服务器后缀名：goke_update.html
    //  新的json数据格式：{"list": [ {"url":"http://58.64.153.34/","ver":"V9.1.4.1.17"},
    //                           {"url":"http://58.64.153.34/","ver":"V9.1.4.2.18"}]}
    //20160706  end
    
    
    
    // [HXProgress showProgress];
    //    1.设置请求路径
    //    NSString *urlStr=[NSString stringWithFormat:@"http://58.64.153.34/goke_hx_motor_update.html"];
    //NSString *urlStr=[NSString stringWithFormat:@"http://58.64.153.34/goke_update.html"];
    NSDictionary *informationDic = [NSBundle mainBundle].infoDictionary;
    
    NSString *host = @"update.wificam.org";
    if([[informationDic objectForKey:@"CFBundleDisplayName"] isEqualToString:@"TestApp"]){
        host = @"115.29.190.131";
    }
    // App Name
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/%@/%@/an_update.html",host,[informationDic objectForKey:@"CFBundleDisplayName"],self.originCamera.deviceInfo.model];
    NSURL *urls = [NSURL URLWithString:urlStr];
    
    //    2.创建请求对象
    NSURLRequest *request=[NSURLRequest requestWithURL:urls];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //    3.发送请求
        //3.1发送同步请求，在主线程执行
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //（一直在等待服务器返回数据，这行代码会卡住，如果服务器没有返回数据，那么在主线程UI会卡住不能继续执行操作）
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self recvUrlData:data];
        });
    });
    
    NSLog(@"Dersialized JSON Dictionary end");
    
}

- (void) recvUrlData:(NSData*)data {
    
    // [HXProgress dismiss];
    BOOL isUpdate = NO;
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSDictionary *jsonDic = (NSDictionary *)jsonObject;
    
    NSArray *jsonLists = jsonDic[@"list"];
    
    for (NSDictionary *dic in jsonLists) {
        
        NSString *url = dic[@"url"];
        NSString *ver = dic[@"ver"];
        
        isUpdate = [self isUpdateNewVersion:ver oldVersion:self.originCamera.deviceInfo.fmVersion];
        
        if (isUpdate) {
            
            _urlAddress = url;
            _onlineVersion = ver;
            _download.version = ver;
            _download.url = url;
            break;
        }
        
        //        _urlAddress = url;
        //        _onlineVersion = ver;
        
    }
    
    
    //    isUpdate = YES;
    
    if (isUpdate) {
        [self doCheckRedirect:_urlAddress Version:_onlineVersion];
    }
    else {
        [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
        [TwsTools presentAlertMsg:self message:LOCALSTR(@"It is the latest version already")];
    }
}

//判断是否有新版本
- (BOOL)isUpdateNewVersion:(NSString *)new oldVersion:(NSString *)old {
    
    NSLog(@"new:%@  old:%@", new, old);
    
    BOOL update = NO;
    
    NSArray *b_new = [new componentsSeparatedByString:@"."];
    NSArray *b_old = [old componentsSeparatedByString:@"."];
    
    if( (b_new.count == b_old.count)) {
        for(int i=0;i<b_new.count;i++) {
            
            if(i==b_new.count-1) {
                for(id obj in b_old)
                {
                    NSLog(@"str:%@",obj);
                }
                
                NSArray * last_new_array = [[b_new objectAtIndex:i]componentsSeparatedByString:@"-"];
                NSArray * last_old_array = [[b_old objectAtIndex:i]componentsSeparatedByString:@"-"];
                NSInteger newi = 0;
                if(last_new_array.count>=1) {
                    newi = [[last_new_array objectAtIndex:0]integerValue];
                    NSLog(@"newi:%ld",(long)newi);
                }
                
                NSInteger oldi =0;
                if(last_old_array.count>=1) {
                    oldi = [[last_old_array objectAtIndex:0]integerValue];
                    NSLog(@"oldi:%ld",(long)oldi);
                    
                }
                if(newi>oldi) {
                    update = 1;
                }
                
            }
            else  {
                
                NSString* n = [b_new objectAtIndex:i];
                NSString* o = [b_old objectAtIndex:i];
                
                if(![n isEqualToString:o]) {
                    NSLog(@"  -----str:%@  %@",n,o);
                    update = false;
                    break;
                }
            }
            
        }//@for
    }
    
    return update;
}


-(void) doCheckRedirect:(NSString*)host_ Version:(NSString*)ver_ {
    
    dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        
        char* redirect_url = NULL;
        //        char ipaddr[128] = "58.64.153.34";
        char ipaddr[128] = {0};
        int ipport = 80;
        
        HI_Get_Host_Port2((char*)[host_ UTF8String],ipaddr,&ipport);
        
        //        const char* verc = [ver_ UTF8String];
        
        char version[64] = {0};
        sprintf(version, "/%s.exe",[ver_ UTF8String]);
        //        char version[64] = "/V7.1.4.1.11.exe";
        //    char version[] = "/V9.1.4.1.14.exe";
        int s32Timeout = 10000;
        char* head = malloc(256);
        
        int u32BufLen = 1024;
        char* pBuf = malloc(u32BufLen);
        
        int s32Sock,s32Ret;
        
        
        printf("ip:%s   port:%d   version:%s\n",ipaddr,ipport,version);
        
        
        struct sockaddr_in addr;
        
        if ((s32Sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
        {
            return;
        }
        addr.sin_family = AF_INET;
        addr.sin_port=htons(ipport);
        addr.sin_addr.s_addr = inet_addr(ipaddr);
        
        
        
        
        
        s32Ret = connect(s32Sock, (struct sockaddr *)&addr, sizeof(addr));
        if (s32Sock < 0)
        {
            printf("connect error \n");
            //        close(s32Sock);
            goto RET;
            return;
        }
        
        
        char *pTemp = head;
        memset(pTemp, 0, 256);
        
        
        pTemp += sprintf(pTemp,"GET %s HTTP/1.1\r\n",version);
        pTemp += sprintf(pTemp,"Accept: */*\r\n");
        pTemp += sprintf(pTemp,"Accept-Language: zh-cn\r\n");
        pTemp += sprintf(pTemp,"User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)\r\n");
        pTemp += sprintf(pTemp,"Host: %s\r\n", ipaddr);
        pTemp += sprintf(pTemp,"Connection: Keep-Alive\r\n");
        pTemp += sprintf(pTemp,"\r\n");
        
        //    printf("-------------pTemp--------------:%s \n",pTemp);
        
        //    memset(head, 0, 256);
        
        s32Ret = (int)send(s32Sock, head, strlen(head), 0);
        if(s32Ret < 0) {
            printf("send error \n");
            //        close(s32Sock);
            goto RET;
        }
        //    printf("-------------send--------------:%d \n",s32Ret);
        
        
        
        int ret=0;
        ssize_t recvBytes = 0;
        int u32LineLen  =0;
        fd_set rfds;
        struct timeval tv;
        
        FD_ZERO(&rfds);
        FD_SET((HI_U32)s32Sock, &rfds);
        tv.tv_sec = s32Timeout / 1000;
        tv.tv_usec = (s32Timeout % 1000) * 1000;
        
        
        
        
        
        ret = select(s32Sock+1,&rfds,NULL,NULL,&tv);
        
        if(ret > 0) {
            if(FD_ISSET(s32Sock, &rfds))
            {
                while (u32LineLen<u32BufLen)
                {
                    recvBytes = recv(s32Sock, pBuf+u32LineLen, 1,0);//一次读取一个字节
                    
                    if(recvBytes <= 0){
                        return;
                    }
                    
                    u32LineLen ++;
                    if(u32LineLen >= 4
                       && pBuf[u32LineLen-1] =='\n' && pBuf[u32LineLen-2] == '\r'
                       && pBuf[u32LineLen-3] == '\n' && pBuf[u32LineLen-4] == '\r'){
                        break;
                    }
                }//end while
            }
            
            printf("0-------------recv--------------:%s \n",pBuf);
            
            if(strstr(pBuf,"302 Found") || strstr(pBuf,"301 Moved Permanently")) {
                
                char* local = strstr(pBuf,"Location:");
                
                char* ptr = strchr(local, '\n');
                long end = ptr-local;
                
                
                redirect_url = malloc(end + 1);
                memset(redirect_url, 0, end +1);
                
                memcpy(redirect_url, local + 10, end-11);
                
                
                
                printf("0-------------url--------------:%s \n",redirect_url);
                
            }
            
        }
        
        
        
        
    RET:
        
        free(head);
        free(pBuf);
        head = nil;
        pBuf = nil;
        close(s32Sock);
        
        printf("1-------------url--------------:%s \n",redirect_url);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            printf("2-------------url--------------:%s \n",redirect_url);
            if(redirect_url)
                [self startDownload:[NSString stringWithUTF8String:redirect_url]];
            else {
                [self startDownload:nil];
            }
            
        });
        if(redirect_url) {
            free(redirect_url);
            redirect_url = nil;
        }
    });
    
    
}

-(void)doStartUpgrade{
    if(self.download){
        SMsgAVIoctrlRemoteUpgradeReq *req=  [self.download model];
        [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_REMOTE_UPGRADE_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlRemoteUpgradeReq)];
        free(req);
        req = nil;
    }
}

-(void)startDownload:(NSString*)url_ {
    
    if (url_ != nil) {
        _download.url = url_;
    }
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
        _timeoutTask = nil;
    }
    LOG(@">>> _download.sFileName:%@", _download.url);
    [TwsTools presentAlertTitle:self title:LOCALSTR(@"Prompt") message:LOCALSTR(@"new firmware is available, update?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REBOOT_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        [self doStartUpgrade];
    } actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:^{
    }];
    
}


HI_S32 HI_Get_Host_Port2(HI_CHAR * szSrc, HI_CHAR * szPath, HI_S32 * s32Port)
{
    HI_S32 s32Len = 0, i;
    HI_CHAR *pPtr = NULL, *pCol = NULL, *pSrc = szSrc, szPort[32] = {0};
    HI_CHAR *pHttp = NULL;
    
    pHttp = strstr(pSrc, "http://");
    if(pHttp)
        pSrc = pHttp + 7;
    
    pHttp = strstr(pSrc, "https://");
    if(pHttp)
        pSrc = pHttp + 8;
    
    pPtr = strstr(pSrc, "/");
    if(NULL == pPtr)
    {
        printf("filepath hao no '/', error");
        return HI_FAILURE;
    }
    s32Len = (HI_S32)(pPtr-pSrc);
    if(s32Len > 64)
    {
        printf("filepath's len is too long\n");
        return HI_FAILURE;
    }
    
    pCol = strstr(pSrc, ":");
    if(pCol != NULL && pCol < pPtr)
    {
        s32Len = (HI_S32)(pCol-pSrc);
        memcpy(szPath, pSrc, s32Len);
        szPath[s32Len] = '\0';
        pCol++;
        s32Len = (HI_S32)(pPtr-pCol);
        memcpy(szPort, pCol, s32Len);
        szPort[s32Len] = '\0';
        for(i=0;i<s32Len;i++)
            if(szPort[i] < 0 || szPort[i] > 9)
            {
                printf("port error(%s)\n", szPort);
                return HI_FALSE;
            }
        *s32Port = atoi(szPort);
    }
    else
    {
        memcpy(szPath, pSrc, s32Len);
        szPath[s32Len] = '\0';
        *s32Port = 80;
    }
    
    return HI_SUCCESS;
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
