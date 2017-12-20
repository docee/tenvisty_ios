//
//  CameraSettingViewController.m
//  tenvisty
//
//  Created by lu yi on 12/5/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "CameraSettingViewController.h"
#import "ListImgTableViewCell.h"
#import "ListImgTableViewCellModel.h"
#import "BaseTableViewController.h"

@interface CameraSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSArray *listItems;
@property (weak, nonatomic) IBOutlet UIImageView *imgCameraSnapShot;
@property (weak, nonatomic) IBOutlet UILabel *labUID;

@end

@implementation CameraSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        [self.tableview registerNib:[UINib nibWithNibName:@"ListImgTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_ListImg];
     [self setup];
}

-(void)setup{
    [_imgCameraSnapShot setImage:self.camera.image];
    [_labUID setText:self.camera.uid];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _listItems = nil;
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_modifyname" title:LOCALSTR(@"Camera Name") loadingTxt:nil value:self.camera.nickName],[ListImgTableViewCellModel initObj:@"ic_modifypassword" title:LOCALSTR(@"Change Password") loadingTxt:nil value:nil], nil];
        NSArray *sec2 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_network" title:LOCALSTR(@"Network") loadingTxt:LOCALSTR(@"loading...") value:nil],[ListImgTableViewCellModel initObj:@"ic_eventsetting" title:LOCALSTR(@"Event Setting") loadingTxt:LOCALSTR(@"loading...") value:nil],
            [ListImgTableViewCellModel initObj:@"ic_setting_record" title:LOCALSTR(@"Record") loadingTxt:LOCALSTR(@"loading...") value:nil],nil];
        NSArray *sec3 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_othersetting" title:LOCALSTR(@"Other Setting") loadingTxt:nil value:nil],nil];
        NSArray *sec4 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_systemsetting" title:LOCALSTR(@"System Setting") loadingTxt:nil value:nil],nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1,sec2,sec3,sec4, nil];
    }
    return _listItems;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self listItems].count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[[self listItems] objectAtIndex:section]).count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *vid = TableViewCell_ListImg;
    ListImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[ListImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vid];
    }
    ListImgTableViewCellModel *model = [[[self listItems]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setLeftImage:model.titleImgName];
    cell.leftLabTitle.text = model.titleText;
    if(model.loadingText == nil){
        [cell.rightLabLoading setHidden:YES];
    }
    else{
        cell.rightLabLoading.text = model.loadingText;
    }
    cell.rightLabValue.text = model.titleValue;
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
              [self performSegueWithIdentifier:@"CameraSetting2ChangeCameraName" sender:self];
        }
        else  if(indexPath.row == 1){
            [self performSegueWithIdentifier:@"CameraSetting2ChangeCameraPassword" sender:self];
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            [self performSegueWithIdentifier:@"CameraSetting2WiFiSetting" sender:self];
        }
        else if(indexPath.row == 1){
            [self performSegueWithIdentifier:@"CameraSetting2EventiSetting" sender:self];
        }
        else if(indexPath.row == 2){
            [self performSegueWithIdentifier:@"CameraSetting2RecordSetting" sender:self];
        }
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            [self performSegueWithIdentifier:@"CameraSetting2OtherSetting" sender:self];
        }
    }
    else if(indexPath.section == 3){
        if(indexPath.row == 0){
            [self performSegueWithIdentifier:@"CameraSetting2SystemSetting" sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BaseViewController class]]){
        BaseViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
    }
    else if([segue.destinationViewController isKindOfClass:[BaseTableViewController class]]){
        BaseTableViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
    }
}

//其他界面返回到此界面调用的方法
- (IBAction)CameraSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
