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

@interface CameraListViewController ()<MyCameraDelegate>
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
    UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"storyboard_cameraSetting"];  //test2为viewcontroller的StoryboardId
    [self.navigationController pushViewController:test2obj animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for(MyCamera *camera in [GBase sharedInstance].cameras){
        camera.delegate2 = self;
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

- (IBAction)go2EventList:(id)sender {
    [self performSegueWithIdentifier:@"CameraList2EventList" sender:self];
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALSTR(@"Wrong password") message:LOCALSTR(@"Re-enter password") preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = LOCALSTR(@"Camera Password");
        textField.secureTextEntry = YES;
        
    }];
    
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:LOCALSTR(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:actionNO];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:LOCALSTR(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MyCamera *camera = [GBase getCamera:sender.tag];
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


//其他界面返回到此界面调用的方法
- (IBAction)CameraListViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    NSInteger row = [GBase getCameraIndex:(MyCamera*)camera];
    if([camera.pwd isEqualToString:DEFAULT_PASSWORD]){
        [TwsTools presentAlertMsg:self message:@"for security, please change the camera" actionDefaultBlock:^{
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"CameraSetting" bundle:nil];
            BaseTableViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"storyboard_changcamerapassword"];  //test2为viewcontroller的StoryboardId
            test2obj.camera = (MyCamera*)camera;
            [self.navigationController pushViewController:test2obj animated:YES];
        }];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
