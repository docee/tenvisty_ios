//
//  CameraListViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/11/29.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "CameraListViewController.h"
#import "CameraListItemTableViewCell.h"
#import "BaseTableViewController.h"
#import "BaseViewController.h"

@interface CameraListViewController ()<MyCameraDelegate>{
    BOOL isShowingModifyPassword;
}
@property (weak, nonatomic) IBOutlet UIView *view_first_add;

@end

@implementation CameraListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
-(void)setup{
    for(MyCamera *camera in [GBase sharedInstance].cameras){
        camera.delegate2 = self;
        [camera start];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go2CameraSetting:(UIButton *)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"CameraSetting" bundle:nil];
    BaseViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"storyboard_cameraSetting"];  //test2为viewcontroller的StoryboardId
    [self.navigationController pushViewController:test2obj animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for(MyCamera *camera in [GBase sharedInstance].cameras){
        camera.delegate2 = self;
        //强制改密码；
        if(camera.connectState == CONNECTION_STATE_CONNECTED && [camera.pwd isEqualToString:DEFAULT_PASSWORD]){
             [self showChangePasswordStrict:(MyCamera*)camera];
        }
    }
    [self checkShowFirstAddView];

    [self.tableview reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for(MyCamera *camera in [GBase sharedInstance].cameras){
        camera.delegate2 = nil;
    }
}

-(void)checkShowFirstAddView{
    if([GBase sharedInstance].cameras.count == 0){
        [self.view_first_add setHidden:NO];
        //[self.tableview setHidden:YES];
    }
    else{
        [self.view_first_add setHidden:YES];
        //[self.tableview setHidden:NO];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GBase sharedInstance].cameras.count;
}

- (IBAction)go2EventList:(UIButton*)sender {
    [self performSegueWithIdentifier:@"CameraList2EventList" sender:sender];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *vid = @"cameraListItemCell";
    MyCamera *camera = [GBase getCamera:indexPath.row];
    CameraListItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
    cell.camera = camera;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = Screen_Main.width>Screen_Main.height?Screen_Main.height:Screen_Main.width;
    return width*9/16 + 40;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender{
   
    if([segue.identifier isEqualToString:@"CameraList2AddCamera"] || [segue.identifier isEqualToString:@"CameraList2AddCameraFirst"]){
        
    }
    else{
        if([segue.destinationViewController isKindOfClass:[BaseViewController class]]){
            BaseViewController *controller= segue.destinationViewController;
            controller.camera =  [GBase getCamera:sender.tag];
        }
        else if([segue.destinationViewController isKindOfClass:[BaseTableViewController class]]){
            BaseTableViewController *controller= segue.destinationViewController;
            controller.camera =  [GBase getCamera:sender.tag];
        }
    }
//    if([segue.identifier isEqualToString:@"CameraList2ModifyCameraName"]){
//        
//    }
//    else if([segue.identifier isEqualToString:@"CameraList2LiveView"]){
//
//        
//    }
    
}

- (IBAction)deleteCamera:(UIButton *)sender {
    NSInteger row = sender.tag;
    [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Are you sure to remove this camera?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
        MyCamera *camera = [GBase getCamera:row];
        if(camera){
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 处理耗时操作的代码块...
                [camera stop];
                [camera closePush];
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                });
            });
            
            [GBase deleteCamera:camera];
            [self.tableview beginUpdates];
            [self.tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableview endUpdates];
            [self checkShowFirstAddView];
            [self refreshTableTag];
        }
    } defaultActionStyle:UIAlertActionStyleDestructive actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
}

-(void)refreshTableTag{
    NSInteger rowCount = [GBase sharedInstance].cameras.count;
    for (int i=0; i<rowCount; i++) {
       CameraListItemTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(cell){
            [cell refreshInfo];
        }
    }
}

- (IBAction)showModifyPassword:(UIButton *)sender {
    [self doShowModifyPassword:[GBase getCamera:sender.tag]];
}


- (IBAction)reconnectCamera:(UIButton *)sender {
    [sender setEnabled:NO];
    NSInteger row = sender.tag;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [[GBase getCamera:row] stop];
        [[GBase getCamera:row] start];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [sender setEnabled:YES];
        });
    });
}

-(void)doShowModifyPassword:(MyCamera *)camera{
    if(isShowingModifyPassword){
        return;
    }
    isShowingModifyPassword = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALSTR(@"Wrong password") message: FORMAT(LOCALSTR(@"Re-enter [%@] password"),camera.nickName) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = LOCALSTR(@"Camera Password");
        textField.secureTextEntry = YES;
        
    }];
    
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:LOCALSTR(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        isShowingModifyPassword = NO;
    }];
    [alertController addAction:actionNO];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:LOCALSTR(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *pwd = alertController.textFields.firstObject.text;
        if(pwd.length == 0){
            return;
        }
        isShowingModifyPassword = NO;
        camera.pwd = alertController.textFields.firstObject.text;
        [GBase editCamera:camera];
        [camera start:0];
        //        [camera stop];
        //        [camera start];
        //        dispatch_async(dispatch_get_global_queue(0,0), ^{
        //            [camera stop];
        //            [camera start];
        //        });
    }];
    
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:NULL];
}


//其他界面返回到此界面调用的方法
- (IBAction)CameraListViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
-(void)showChangePasswordStrict:(MyCamera*)camera{
    if(!isShowingModifyPassword){
        isShowingModifyPassword = YES;
        [TwsTools presentAlertMsg:self message: FORMAT(LOCALSTR(@"Your camera [%@] uses default password, please change the password for security."),((MyCamera*)camera).nickName) actionDefaultBlock:^{
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"CameraSetting" bundle:nil];
            BaseTableViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"storyboard_changcamerapassword"];  //test2为viewcontroller的StoryboardId
            test2obj.camera = camera;
            [self.navigationController pushViewController:test2obj animated:YES];
        }];
    }
}
- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    NSInteger row = [GBase getCameraIndex:(MyCamera*)camera];
    
    if(row >= 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            CameraListItemTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            if(cell){
                LOG(@"reresh row:%d cell isnull:%d",(int)row,cell== nil?1:0);
                [cell refreshState];
            }
        });
    }
}

- (void)camera:(NSCamera *)camera _didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status{
    NSInteger row = [GBase getCameraIndex:(MyCamera*)camera];
    if(status == CONNECTION_STATE_CONNECTED && [camera.pwd isEqualToString:DEFAULT_PASSWORD]){
        [self showChangePasswordStrict:(MyCamera*)camera];
    }
    else if(((MyCamera*)camera).processState == CAMERASTATE_NONE && status == CONNECTION_STATE_WRONG_PASSWORD){
        [self doShowModifyPassword:(MyCamera*)camera];
    }
    if(row >= 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            CameraListItemTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            if(cell){
                LOG(@"reresh row:%d cell isnull:%d",(int)row,cell== nil?1:0);
                [cell refreshState];
            }
        });
    }
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    if(type == IOTYPE_USER_IPCAM_UPGRADE_STATUS){
        NSInteger row = [GBase getCameraIndex:(MyCamera*)camera];
        SMsgAVIoctrlUpgradeStatus *resp = (SMsgAVIoctrlUpgradeStatus*)data;
        ((MyCamera*)camera).upgradePercent = resp->p;
        if(resp->p >= 100 ){
            ((MyCamera*)camera).processState = CAMERASTATE_WILLREBOOTING;
            dispatch_async(dispatch_get_main_queue(), ^{
                [iToast makeText:LOCALSTR(@"Firmware update success, camera will reboot later, please wait a moment.")];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            CameraListItemTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            if(cell){
                LOG(@"reresh row:%d cell isnull:%d",(int)row,cell== nil?1:0);
                [cell refreshState];
            }
        });
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
