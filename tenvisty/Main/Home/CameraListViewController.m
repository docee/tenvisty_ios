//
//  CameraListViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/11/29.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "CameraListViewController.h"
#import "CameraListItemTableViewCell.h"
#import "ModifyCameraNameTableViewController.h"

@interface CameraListViewController ()

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (IBAction)go2EventList:(id)sender {
    [self performSegueWithIdentifier:@"CameraList2EventList" sender:self];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *vid = @"cameraListItemCell";
    CameraListItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[CameraListItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vid];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = Screen_Main.width>Screen_Main.height?Screen_Main.height:Screen_Main.width;
    return width*9/16 + 40;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"CameraList2ModifyCameraName"]){
        ModifyCameraNameTableViewController *controller= segue.destinationViewController;
        controller.uid = @"aaaaaaaaaa0000000000";
    }
    
}

//其他界面返回到此界面调用的方法
- (IBAction)CameraListViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
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
