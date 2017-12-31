//
//  SensSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SensSettingViewController.h"

@interface SensSettingViewController (){
    NSInteger sensLevel;
}
@property (nonatomic,strong) NSArray *sensValue;
@property (strong,nonatomic) NSArray *items;
@end

@implementation SensSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

-(void)setup{
    _sensValue = @[@90,@70,@50,@30,@0];
    [self doGetEventSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doGetEventSetting{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SMsgAVIoctrlGetMotionDetectReq *req = malloc(sizeof(SMsgAVIoctrlGetMotionDetectReq));
    req->channel = 0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETMOTIONDETECT_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetMotionDetectReq)];
    free(req);
}

-(void)doSetEventSetting:(NSInteger)sens{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SMsgAVIoctrlSetMotionDetectReq *req = malloc(sizeof(SMsgAVIoctrlSetMotionDetectReq));
    req->channel = 0;
    req->sensitivity = (int)sens;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SETMOTIONDETECT_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetMotionDetectReq)];
    free(req);
}

-(NSArray *)items{
    if(_items == nil){
        _items = [[NSArray alloc] initWithObjects:LOCALSTR(@"Highest"),LOCALSTR(@"High"),LOCALSTR(@"General"),LOCALSTR(@"Low"),LOCALSTR(@"Close"), nil];
    }
    return _items;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self items].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_SelectItem;
    SelectItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    cell.leftLabel.text = [[self items] objectAtIndex:indexPath.row];
    
    [cell setSelect:indexPath.row == sensLevel];
    
    return cell;
}

-(NSInteger)getLevel:(NSInteger)sens{
    for(int i=0;i<_sensValue.count;i++){
        if(sens >= (int)_sensValue[i]){
            return i;
        }
    }
    return 0;
}
-(NSInteger)getSens:(NSInteger)level{
    return (NSInteger)_sensValue[level];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self doSetEventSetting:[self getSens:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GETMOTIONDETECT_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            SMsgAVIoctrlGetMotionDetectResp *resp = (SMsgAVIoctrlGetMotionDetectResp*)data;
            sensLevel = [self getLevel:resp->sensitivity];
            [self.tableView reloadData];
            break;
        }
        case IOTYPE_USER_IPCAM_SETMOTIONDETECT_RESP:{
            SMsgAVIoctrlSetMotionDetectResp *resp = (SMsgAVIoctrlSetMotionDetectResp*)data;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(resp->result == 0){
                [[iToast makeText:LOCALSTR(@"setting successfully")] show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
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
