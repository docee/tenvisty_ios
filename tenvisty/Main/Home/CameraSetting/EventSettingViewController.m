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

@end

@implementation EventSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    if(indexPath.row == 0){
        NSString *id = TableViewCell_ListImg;
        ListImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
        cell.title = LOCALSTR(@"Sensitivity Setting");
        cell.showValue = YES;
        cell.value= currentSens;//LOCALSTR(@"Close");
        [cell setLeftImage:@"ic_sens"];
        return cell;
    }
    else{
        NSString *id = TableViewCell_Switch;
        SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
        cell.leftLabTitle.text = LOCALSTR(@"Alarm Push");
        [cell setLeftImage:@"ic_push"];
        [cell.rightLabLoading setHidden:YES];
        [cell.rightSwitch setOn:self.camera.eventNotification>0];
        [cell.rightSwitch addTarget:self action:@selector(clickPush:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

-(void)clickPush:(UISwitch *)sender{
    if([sender isOn]){
        self.camera.eventNotification = 1;
    }
    else{
        self.camera.eventNotification = 0;
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
            if(resp->sensitivity == 0){
                currentSens = LOCALSTR(@"Close");
            }
            else if(resp->sensitivity <= 30){
                currentSens = LOCALSTR(@"Low");
            }
            else if(resp->sensitivity <= 60){
                currentSens = LOCALSTR(@"General");
            }
            else if(resp->sensitivity <= 80){
                currentSens = LOCALSTR(@"High");
            }
            else{
                currentSens = LOCALSTR(@"Highest");
            }
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
