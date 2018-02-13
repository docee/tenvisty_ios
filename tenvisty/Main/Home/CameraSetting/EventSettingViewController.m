//
//  EventSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "EventSettingViewController.h"

@interface EventSettingViewController (){
    NSString *currentSens;
    NSInteger currentPush;
}
@property (nonatomic,strong) NSArray *sensValueDesc;
@property (nonatomic,strong) NSArray *sensValue;
@property (strong,nonatomic) NSArray *listItems;
@end

@implementation EventSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sensValue = @[@90,@70,@50,@30,@0];
    _sensValueDesc = @[LOCALSTR(@"Highest"),LOCALSTR(@"High"),LOCALSTR(@"General"),LOCALSTR(@"Low"),LOCALSTR(@"Close")];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
}

-(void)setup{
    currentSens = nil;
    [self.tableView reloadData];
    [self doGetEventSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doGetEventSetting{
    SMsgAVIoctrlGetMotionDetectReq *req = malloc(sizeof(SMsgAVIoctrlGetMotionDetectReq));
    req->channel = 0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETMOTIONDETECT_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetMotionDetectReq)];
    free(req);
}
-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:@"ic_sens" title:LOCALSTR(@"Sensitivity Setting") showValue:YES value:nil viewId:TableViewCell_ListImg],
                         [ListImgTableViewCellModel initObj:@"ic_push" title:LOCALSTR(@"Alarm Push") showValue:YES value:self.camera.remoteNotifications >0?@"1":@"0" viewId:TableViewCell_Switch],
                         
                         nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}


- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didClickSwitch:(UISwitch*)sw{
    [self clickPush:sw];
}
-(void)clickPush:(UISwitch *)sender{
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    if([sender isOn]){
        [self.camera openPush:^(NSInteger code) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                if(code == 0){
                    [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                }
                else{
                    [sender setOn:NO];
                    [[iToast makeText:LOCALSTR(@"Setting Failed")] show];
                }
            });
        }];
    }
    else{
        [self.camera closePush:^(NSInteger code) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                if(code == 0){
                    [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                }
                else{
                    [sender setOn:NO];
                    [[iToast makeText:LOCALSTR(@"Setting Failed")] show];
                }
            });
        }];
    }
    [GBase editCamera:self.camera];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"EventSetting2SensSetting" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//其他界面返回到此界面调用的方法
- (IBAction)EventSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GETMOTIONDETECT_RESP:{
            SMsgAVIoctrlGetMotionDetectResp *resp = (SMsgAVIoctrlGetMotionDetectResp*)data;
            for(int i=0;i<_sensValue.count;i++){
                if(resp->sensitivity >= [(NSNumber*)_sensValue[i] intValue]){
                    currentSens = _sensValueDesc[i];
                    break;
                }
            }
            [self setRowValue:currentSens row:0 section:0];
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender{
    
    if([segue.identifier isEqualToString:@"EventSetting2SensSetting"]){
        BaseTableViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
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
