//
//  DeviceInfoViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "DeviceInfoViewController.h"

@interface DeviceInfoViewController (){
}
@property (strong,nonatomic) NSArray *listItems;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self getSDCardInfo];
    // Do any additional setup after loading the view.
}

-(void)setup{
    self.navigationController.title = LOCALSTR(@"Camera Information");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"UID") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Version") showValue:YES value:nil viewId:TableViewCell_TextField_Disable]
                         ,nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1,nil];
    }
    return _listItems;
}

-(void)getSDCardInfo{
    SMsgAVIoctrlDeviceInfoReq *req = malloc(sizeof(SMsgAVIoctrlDeviceInfoReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_DEVINFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlDeviceInfoReq)];
    free(req);
    req = nil;
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
            [self setRowValue:[NSString stringWithFormat:@"%d.%d.%d.%d",v[0],v[1],v[2],v[3]] row:1 section:0];
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
