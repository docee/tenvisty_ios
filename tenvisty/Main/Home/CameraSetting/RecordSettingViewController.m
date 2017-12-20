//
//  SensSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "RecordSettingViewController.h"

@interface RecordSettingViewController (){
    NSInteger recordType;
}
@property (strong,nonatomic) NSArray *items;
@end

@implementation RecordSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

-(void)setup{
    recordType = -1;
    [self doGetRecordSetting];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doGetRecordSetting{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SMsgAVIoctrlGetRecordReq *req = malloc(sizeof(SMsgAVIoctrlGetRecordReq));
    req->channel = 0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETRECORD_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlGetRecordReq)];
    free(req);
}

-(void)doSetRecordSetting:(NSInteger)type{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SMsgAVIoctrlSetRecordReq *req = malloc(sizeof(SMsgAVIoctrlSetRecordReq));
    req->channel = 0;
    req->recordType = (int)type;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SETRECORD_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetRecordReq)];
    free(req);
}


-(NSArray *)items{
    if(_items == nil){
        _items = [[NSArray alloc] initWithObjects:LOCALSTR(@"OFF"),LOCALSTR(@"Full Time Recording"),LOCALSTR(@"Alarm Recording"), nil];
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
    
    [cell setSelect:indexPath.row == recordType];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self doSetRecordSetting:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_GETRECORD_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            SMsgAVIoctrlGetRecordResq *resp = (SMsgAVIoctrlGetRecordResq*)data;
            recordType = resp->recordType;
            [self.tableView reloadData];
            break;
        }
        case IOTYPE_USER_IPCAM_SETRECORD_RESP:{
            SMsgAVIoctrlSetRecordResp *resp = (SMsgAVIoctrlSetRecordResp*)data;
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
