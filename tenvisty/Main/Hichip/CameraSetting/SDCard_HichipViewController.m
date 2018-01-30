//
//  SDCardViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SDCard_HichipViewController.h"

@interface SDCard_HichipViewController (){
    NSInteger freeSize;
    NSInteger totalSize;
    BOOL isFormatting;
}

@end

@implementation SDCard_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    // Do any additional setup after loading the view.
}
-(void)setup{
    [self getSDCardInfo];
}
-(void)getSDCardInfo{
    freeSize = -1;
    totalSize = -1;
    SMsgAVIoctrlDeviceInfoReq *req = malloc(sizeof(SMsgAVIoctrlDeviceInfoReq));
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_DEVINFO_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlDeviceInfoReq)];
    free(req);
}

-(void)doFormatSDCard{
    [MBProgressHUD showMessag:LOCALSTR(@"formating...") toView:self.tableView].userInteractionEnabled = YES;
    SMsgAVIoctrlFormatExtStorageReq *req = malloc(sizeof(SMsgAVIoctrlFormatExtStorageReq));
    req->storage = 0;
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlFormatExtStorageReq)];
    free(req);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_TextField_Disable;
    TwsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.title = LOCALSTR(@"Total size");
        if(totalSize == -1){
            cell.value = LOCALSTR(@"loading...");
        }
        else{
            cell.value = FORMAT(@"%d MB",(int)totalSize);
        }
    }
    else if(indexPath.row == 1){
        cell.title = LOCALSTR(@"Free size");
        if(freeSize == -1){
            cell.value = LOCALSTR(@"loading...");
        }
        else{
            cell.value = FORMAT(@"%d MB",(int)freeSize);
        }
    }
    
    return cell;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewCellFooter"];
    for(UIView *view in cell.contentView.subviews){
        if([view isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton*)view;
            [btn addTarget:self action:@selector(clickFormat:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
    return cell.contentView;
}

-(void)clickFormat:(UIButton*)sender{
    [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Format command will ERASE all data of SD Card, continue?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
        [self doFormatSDCard];
    } defaultActionStyle:UIAlertActionStyleDestructive actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90.0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_DEVINFO_RESP:{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            SMsgAVIoctrlDeviceInfoResp *resp = (SMsgAVIoctrlDeviceInfoResp*)data;
            freeSize = resp->free;
            totalSize = resp->total;
            [self.tableView reloadData];
            if(isFormatting){
                [[[iToast makeText:LOCALSTR(@"format success")]setDuration:1] show];
                isFormatting= NO;
            }
            break;
        }
        case IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_RESP:{
            SMsgAVIoctrlFormatExtStorageResp *resp = (SMsgAVIoctrlFormatExtStorageResp*)data;
            if(resp->result == 0){
                isFormatting = YES;
                [self getSDCardInfo];
                [self.tableView reloadData];
            }
            else{
                [[iToast makeText:LOCALSTR(@"format failed, please try again later")] show];
            }
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
