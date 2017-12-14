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
    
    if([GBase sharedInstance].cameras.count == 0){
        [self.view_first_add setHidden:NO];
        //[self.tableview setHidden:YES];
    }
    else{
        [self.view_first_add setHidden:YES];
        //[self.tableview setHidden:NO];
    }
    for(MyCamera *camera in [GBase sharedInstance].cameras){
        camera.delegate2 = self;
        if([camera isDisconnected]){
            [camera start];
        }
    }
    
    
    [self.tableview reloadData];
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
    cell.btnCameraDelete.tag  = indexPath.row;
    cell.labCameraName.text = camera.nickName;
    cell.btnModifyCameraName.tag = indexPath.row;
    [cell setAlarm:camera.eventNotification];
    [cell.imgCameraSnap setImage:camera.image];
    [cell setState:camera.sessionState];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = Screen_Main.width>Screen_Main.height?Screen_Main.height:Screen_Main.width;
    return width*9/16 + 40;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender{
    if([segue.destinationViewController isKindOfClass:[BaseViewController class]]){
        BaseViewController *controller= segue.destinationViewController;
        controller.camera =  [GBase getCamera:sender.tag];
    }
    else if([segue.destinationViewController isKindOfClass:[BaseTableViewController class]]){
        BaseTableViewController *controller= segue.destinationViewController;
        controller.camera =  [GBase getCamera:sender.tag];
    }
    if([segue.identifier isEqualToString:@"CameraList2ModifyCameraName"]){
        
    }
    else if([segue.identifier isEqualToString:@"CameraList2LiveView"]){

        
    }
    
}
- (IBAction)deleteCamera:(UIButton *)sender {
    NSInteger row = sender.tag;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Are you sure to remove this camera?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            MyCamera *camera = [[GBase sharedInstance].cameras objectAtIndex:row];
            [camera stop];
            [camera closePush];
            [GBase deleteCamera:camera];
            [self.tableview beginUpdates];
            [self.tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableview endUpdates];
        } actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
    });
}


//其他界面返回到此界面调用的方法
- (IBAction)CameraListViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    [self.tableview reloadData];
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
