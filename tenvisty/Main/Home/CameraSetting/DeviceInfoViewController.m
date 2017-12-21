//
//  DeviceInfoViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "DeviceInfoViewController.h"

@interface DeviceInfoViewController (){
    NSString *fmVersion;
}

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSDCardInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getSDCardInfo{
    fmVersion = nil;
    SMsgAVIoctrlDeviceInfoReq *req = malloc(sizeof(SMsgAVIoctrlDeviceInfoReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_DEVINFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlDeviceInfoReq)];
    free(req);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_TextField_Disable;
    TwsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.title = LOCALSTR(@"Version");
        if(fmVersion == nil){
            cell.value = LOCALSTR(@"loading...");
        }else{
            cell.value = fmVersion;
        }
       
    }
    return cell;
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_DEVINFO_RESP:{
            SMsgAVIoctrlDeviceInfoResp *resp = (SMsgAVIoctrlDeviceInfoResp*)data;
            unsigned char v[4] = {0};
            
            v[3] = (char)resp->version;
            v[2] = (char)(resp->version >> 8);
            v[1] = (char)(resp->version >> 16);
            v[0] = (char)(resp->version >> 24);
            fmVersion = [NSString stringWithFormat:@"%d.%d.%d.%d",v[0],v[1],v[2],v[3]];
            [self.tableView reloadData];
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
