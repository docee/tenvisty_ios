//
//  ImageViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/11/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ImageCameraListViewController.h"
#import "ImageTableViewCell.h"
#import "BaseViewController.h"

@interface ImageCameraListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ImageCameraListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GBase sharedInstance].cameras.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    MyCamera *camera = [GBase getCamera:indexPath.row];
    NSString *vid = @"tableviewCellImage";
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
    cell.rightLabCameraName.text = camera.nickName;
    cell.rightLabDesc.text = FORMAT(@"%d photos, %d videos",(int)[GBase countSnapshot:camera.uid],(int)[GBase countVideo:camera.uid]);
    NSString *thumbPath = [GBase thumbPath:camera];
    if(thumbPath == nil){
        [cell.leftImg setImage:[UIImage imageNamed:@"default_img"]];
    }
    else{
        [cell.leftImg setImage:[UIImage imageWithContentsOfFile:thumbPath]];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"Image2ImageCollection" sender:self];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//其他界面返回到此界面调用的方法
- (IBAction)ImageViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[BaseViewController class]]){
        BaseViewController *controller= segue.destinationViewController;
        controller.camera =  [GBase getCamera:[self.tableview indexPathForSelectedRow].row];
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
