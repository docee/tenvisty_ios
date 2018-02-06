//
//  CameraSettingViewController.m
//  tenvisty
//
//  Created by lu yi on 12/5/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "OtherSetting_HichipViewController.h"
#import "Display.h"
#import "BaseViewController.h"

@interface OtherSetting_HichipViewController (){
}
@property (strong,nonatomic) NSArray *listItems;
@property (strong,nonatomic) Display *display;

@end

@implementation OtherSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}
-(void) setup{
    [self doGetVideoMode];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) doGetVideoMode{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_DISPLAY_PARAM Data:(char*)nil DataSize:0];
}
-(void) doSetVideoMode{
    if(self.display){
        HI_P2P_S_DISPLAY *req = [self.display model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_DISPLAY_PARAM Data:(char*)req DataSize:sizeof(HI_P2P_S_DISPLAY)];
        free(req);
        req = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)listItems{
    if(!_listItems){
       NSArray *sec1 = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_timezone" title:LOCALSTR(@"Time Setting") showValue:NO value:nil viewId:TableViewCell_ListImg],
                        [ListImgTableViewCellModel initObj:@"ic_timezone" title:LOCALSTR(@"Audio Setting") showValue:NO value:nil viewId:TableViewCell_ListImg],
        [ListImgTableViewCellModel initObj:@"ic_reverse" title:LOCALSTR(@"Mirror") showValue:YES value:nil viewId:TableViewCell_Switch],
        [ListImgTableViewCellModel initObj:@"ic_inverse" title:LOCALSTR(@"Flip") showValue:YES value:nil viewId:TableViewCell_Switch],
        [ListImgTableViewCellModel initObj:@"ic_sd" title:LOCALSTR(@"SD Card") showValue:NO value:nil viewId:TableViewCell_ListImg],
        [ListImgTableViewCellModel initObj:@"ic_info" title:LOCALSTR(@"Device Infomation") showValue:NO value:nil viewId:TableViewCell_ListImg], nil];
       
           _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}

-(void)refreshTable{
    if(self.display){
        [self setRowValue:FORMAT(@"%d",self.display.u32Mirror)  row:2 section:0];
        [self setRowValue:FORMAT(@"%d",self.display.u32Flip)  row:3 section:0];
    }
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BaseTableViewController class]]){
        BaseTableViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
    }
    if([segue.destinationViewController isKindOfClass:[BaseViewController class]]){
        BaseViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
    }
}

- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didClickSwitch:(UISwitch*)sw{
    if(self.display){
        NSIndexPath *indexPath = [self getIndexPath:cellModel];
        //mirror
        if(indexPath.row == 2){
            self.display.u32Mirror = sw.isOn?1:0;
        }
        //flip
        else if(indexPath.row == 3){
            self.display.u32Flip = sw.isOn?1:0;
        }
        [self doSetVideoMode];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
              [self performSegueWithIdentifier:@"OtherSetting2TimeSetting" sender:self];
        }
        else if(indexPath.row == 1){
            [self performSegueWithIdentifier:@"OtherSetting2AudioSetting" sender:self];
        }
        else if(indexPath.row == 4){
              [self performSegueWithIdentifier:@"OtherSetting2SDCard" sender:self];
        }
        else if(indexPath.row == 5){
            [self performSegueWithIdentifier:@"OtherSetting2DeviceInfo" sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//其他界面返回到此界面调用的方法
- (IBAction)OtherSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_DISPLAY_PARAM:{
            if(size >= sizeof(HI_P2P_S_DISPLAY)){
                self.display = [[Display alloc] initWithData:(char*)data size:(int)size];
                [self refreshTable];
            }
            break;
        }
        default:
            break;
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
