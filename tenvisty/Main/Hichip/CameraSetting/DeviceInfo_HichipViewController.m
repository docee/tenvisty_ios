//
//  DeviceInfoViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "DeviceInfo_HichipViewController.h"
#import "DeviceInfoExt.h"
#import "NetParam.h"
#import "HichipCamera.h"

@interface DeviceInfo_HichipViewController (){
    NSString *fmVersion;
    BOOL hasFm;
}
@property (strong,nonatomic) NSArray *listItems;
@property (nonatomic, strong)  DeviceInfoExt *deviceInfoExt;
@property (nonatomic, strong)  NetParam *netParam;
@property (nonatomic, strong)  HichipCamera *originCamera;


@end

@implementation DeviceInfo_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originCamera = (HichipCamera*)self.camera.orginCamera;
    [self getDeviceInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = nil;
        if(hasFm){
            sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"UID") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Software Version") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Firmware Version") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable]
                         ,nil];
        }
        else{
            sec1 = [[NSArray alloc] initWithObjects:
                             [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"UID") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable],
                             [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Software Version") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable]
                             ,nil];
        }
        NSArray *sec2 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Network") showValue:YES value:nil viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"IP") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Subnet Mask") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Gate Way") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"DNS") showValue:YES value:self.camera.uid viewId:TableViewCell_TextField_Disable]
                         ,nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1,sec2,nil];
    }
    return _listItems;
}

-(void)refreshTable{
    if(self.originCamera.deviceInfoExt){
        [self setRowValue:self.originCamera.deviceInfoExt.aszSystemSoftVersion row:1 section:0];
        if(((NSArray*)self.listItems[0]).count > 2){
            [self setRowValue:self.originCamera.deviceInfoExt.aszWebVersion row:2 section:0];
        }
        [self setRowValue:self.originCamera.deviceInfoExt.netType row:0 section:1];
    }
    if(self.netParam){
        [self setRowValue:self.netParam.strIPAddr row:1 section:1];
        [self setRowValue:self.netParam.strNetMask row:2 section:1];
        [self setRowValue:self.netParam.strGateWay row:3 section:1];
        [self setRowValue:self.netParam.strFDNSIP row:4 section:1];
    }
    [self.tableView reloadData];
}

-(void)getDeviceInfo{
    if(self.originCamera.deviceInfoExt){
        if(self.originCamera.deviceInfoExt !=nil && [[self.originCamera.deviceInfoExt.aszWebVersion substringWithRange:NSMakeRange(1, 2)] intValue] >= 16){
            hasFm = YES;
        }
    }
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_DEV_INFO_EXT Data:(char*)nil DataSize:0];
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_NET_PARAM Data:(char*)nil DataSize:0];
    
}


- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_DEV_INFO_EXT:{
            if(size>=sizeof(HI_P2P_S_DEV_INFO_EXT)){
                self.originCamera.deviceInfoExt = [[DeviceInfoExt alloc] initWithData:(char*)data size:(int)size];
                if(self.originCamera.deviceInfoExt !=nil && [[self.originCamera.deviceInfoExt.aszWebVersion substringWithRange:NSMakeRange(1, 2)] intValue] >= 16){
                    hasFm = YES;
                }
                [self refreshTable];
            }
            
            break;
        }
        case HI_P2P_GET_NET_PARAM:{
            if(size >= sizeof(HI_P2P_S_NET_PARAM)){
                self.netParam = [[NetParam alloc] initWithData:(char*)data size:(int)size];
                [self refreshTable];
            }
        }
            break;
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

