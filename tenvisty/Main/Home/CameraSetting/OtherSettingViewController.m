//
//  CameraSettingViewController.m
//  tenvisty
//
//  Created by lu yi on 12/5/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "OtherSettingViewController.h"

@interface OtherSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSArray *listItems;

@end

@implementation OtherSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)listItems{
    if(!_listItems){
        _listItems = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_timezone" title:LOCALSTR(@"Time Setting") loadingTxt:LOCALSTR(@"loading...") value:nil viewId:TableViewCell_ListImg],
        [ListImgTableViewCellModel initObj:@"ic_reverse" title:LOCALSTR(@"Mirror") loadingTxt:LOCALSTR(@"loading...") value:nil viewId:TableViewCell_Switch],
        [ListImgTableViewCellModel initObj:@"ic_inverse" title:LOCALSTR(@"Flip") loadingTxt:LOCALSTR(@"loading...") value:nil viewId:TableViewCell_Switch],
        [ListImgTableViewCellModel initObj:@"ic_sd" title:LOCALSTR(@"SD Card") loadingTxt:nil value:nil viewId:TableViewCell_ListImg],
        [ListImgTableViewCellModel initObj:@"ic_info" title:LOCALSTR(@"Device Infomation") loadingTxt:nil value:nil viewId:TableViewCell_ListImg], nil];
       
        
    }
    return _listItems;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self listItems].count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    
    ListImgTableViewCellModel *model = [[self listItems]objectAtIndex:indexPath.row];
    NSString *vid = model.viewId;
    if([vid isEqualToString:TableViewCell_ListImg]){
        ListImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
        [cell setLeftImage:model.titleImgName];
        cell.leftLabTitle.text = model.titleText;
        if(model.loadingText == nil){
            [cell.rightLabLoading setHidden:YES];
        }
        else{
            cell.rightLabLoading.text = model.loadingText;
        }
        cell.rightLabValue.text = model.titleValue;
        
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    }
    else if([vid isEqualToString:TableViewCell_Switch]){
        SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
        [cell setLeftImage:model.titleImgName];
        cell.leftLabTitle.text = model.titleText;
        if(model.loadingText == nil){
            [cell.rightLabLoading setHidden:YES];
        }
        else{
            cell.rightLabLoading.text = model.loadingText;
        }
        
        //        [cell setSeparatorInset:UIEdgeInsetsZero];
        //        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
              [self performSegueWithIdentifier:@"OtherSetting2TimeSetting" sender:self];
        }
        else if(indexPath.row == 3){
              [self performSegueWithIdentifier:@"OtherSetting2SDCard" sender:self];
        }
        else if(indexPath.row == 4){
            [self performSegueWithIdentifier:@"OtherSetting2DeviceInfo" sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"CameraSetting2ChangeCameraName"]){
        
    }
    
}

//其他界面返回到此界面调用的方法
- (IBAction)OtherSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
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
