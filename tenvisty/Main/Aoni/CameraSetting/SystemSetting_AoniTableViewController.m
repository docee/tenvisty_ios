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


@interface SystemSetting_AoniTableViewController (){
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
    self.myCamera = (MyCamera*)self.camera.orginCamera;
    updateState = -1;
    resetState = -1;
    rebootState = -1;
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
        } defaultActionStyle:UIAlertActionStyleDestructive actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
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
