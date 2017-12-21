//
//  CameraSettingViewController.m
//  tenvisty
//
//  Created by lu yi on 12/5/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "OtherSettingViewController.h"

@interface OtherSettingViewController (){
}
@property (strong,nonatomic) NSArray *listItems;

@end

@implementation OtherSettingViewController

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
    SMsgAVIoctrlGetVideoModeReq *req = malloc(sizeof(SMsgAVIoctrlGetVideoModeReq));
    req->channel = 0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_VIDEOMODE_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetVideoModeReq)];
    free(req);
}
-(void) doSetVideoMode:(NSInteger)mode{
    SMsgAVIoctrlSetVideoModeReq *req = malloc(sizeof(SMsgAVIoctrlSetVideoModeReq));
    req->channel = 0;
    req->mode = (int)mode;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SET_VIDEOMODE_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetVideoModeReq)];
    free(req);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)listItems{
    if(!_listItems){
        _listItems = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_timezone" title:LOCALSTR(@"Time Setting") loadingTxt:nil value:nil viewId:TableViewCell_ListImg],
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BaseTableViewController class]]){
        BaseTableViewController *controller= segue.destinationViewController;
        controller.camera =  self.camera;
    }
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
        cell.rightLabLoading.text = model.loadingText;
        [cell.rightSwitch setEnabled:model.loadingText == nil];
        [cell.rightSwitch setOn:[model.titleValue isEqualToString:@"on"]];
        [cell.rightSwitch addTarget:self action:@selector(clickSwitch:)
                   forControlEvents:UIControlEventTouchUpInside];
        cell.rightSwitch.tag = indexPath.row;
        //        [cell setSeparatorInset:UIEdgeInsetsZero];
        //        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    }
    return nil;
}
-(void)clickSwitch:(UISwitch*)sender{
    ListImgTableViewCellModel *model = [[self listItems]objectAtIndex:sender.tag];
    model.titleValue = [sender isOn]?@"on":@"off";
    ListImgTableViewCellModel *mirrorModel = [[self listItems]objectAtIndex:1];
    ListImgTableViewCellModel *flipModel = [[self listItems]objectAtIndex:2];
    int videoMode = ([mirrorModel.titleValue isEqualToString:@"on"]?2:0) +  ([flipModel.titleValue isEqualToString:@"on"]?1:0);
    [self doSetVideoMode:videoMode];
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


//其他界面返回到此界面调用的方法
- (IBAction)OtherSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GET_VIDEOMODE_RESP:{
            SMsgAVIoctrlGetVideoModeResp *resp = (SMsgAVIoctrlGetVideoModeResp*)data;
            [self setRowValue:(resp->mode&0x2)>0?@"on":@"off" row:1];
            [self setRowValue:(resp->mode&0x1)>0?@"on":@"off" row:2];
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

-(void)setRowValue:(NSString*)value row:(NSInteger)row{
    ListImgTableViewCellModel* model = (ListImgTableViewCellModel*)[self.listItems objectAtIndex:row];
    if(value==nil){
        model.loadingText = LOCALSTR(@"loading...");
    }
    else{
        model.loadingText = nil;
    }
    model.titleValue = value;
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
