//
//  FTPSetting_HichipViewController.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/5.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "FTPSetting_HichipViewController.h"
#import "FTPParam.h"

@interface FTPSetting_HichipViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSArray *listItems;
@property (strong,nonatomic) FTPParam *paras;

@end

@implementation FTPSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup{
    self.navigationController.title = LOCALSTR(@"FTP Setting");
    [self.tableview setBackgroundColor:Color_GrayLightest];
    [self.view setBackgroundColor:Color_GrayLightest];
    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
    [self doGetFtpSetting];
}

-(void)doGetFtpSetting{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_FTP_PARAM_EXT Data:(char *)nil DataSize:0];
}

-(void)doSaveFtpSetting{
    if(self.paras){
        self.paras.u32Check = 0;
        HI_P2P_S_FTP_PARAM_EXT *p = [self.paras model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_FTP_PARAM_EXT Data:(char*)p DataSize:sizeof(HI_P2P_S_FTP_PARAM_EXT)];
        free(p);
        p = nil;
    }
}

-(void)doTestFtpSetting{
    if(self.paras){
        self.paras.u32Check = 1;
        HI_P2P_S_FTP_PARAM_EXT *p = [self.paras model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_FTP_PARAM_EXT Data:(char*)p DataSize:sizeof(HI_P2P_S_FTP_PARAM_EXT)];
        free(p);
        p = nil;
    }
}

-(void)refreshTable{
    if(_paras){
        [self setRowValue:_paras.strSvr row:0 section:0];
        [self setRowValue:FORMAT(@"%d",_paras.u32Port) row:1 section:0];
        [self setRowValue:_paras.strUsernm row:2 section:0];
        [self setRowValue:_paras.strPasswd row:3 section:0];
        [self setRowValue:FORMAT(@"%d",_paras.u32Mode) row:4 section:0];
        [self setRowValue:_paras.strFilePath row:5 section:0];
        [self.tableview reloadData];
    }
}


-(void)reloadParasFromTable{
    if(_paras){
        _paras.strSvr = [self getRowValue:0 section:0];
        _paras.u32Port =   [[self getRowValue:1 section:0] intValue];
        _paras.strUsernm = [self getRowValue:2 section:0];
        _paras.strPasswd = [self getRowValue:3 section:0];
        _paras.u32Mode =   [[self getRowValue:4 section:0] intValue];
        _paras.strFilePath = [self getRowValue:5 section:0];
    }
}

- (IBAction)clickSave:(id)sender {
    [self.view endEditing:YES];
    [self reloadParasFromTable];
    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES].userInteractionEnabled = YES;
    [self doTestFtpSetting];
}

-(NSArray *)listItems{
    if(!_listItems){
        
       ListImgTableViewCellModel *passModel = [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Passive mode") showValue:NO value:nil viewId:TableViewCell_Switch];
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Server") value:nil placeHodler:LOCALSTR(@"Ftp Server Address") maxLength:31 viewId:TableViewCell_TextField_Normal],
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Port") value:@"21" placeHodler:LOCALSTR(@"21") maxLength:5 filter:REGEX_NUMBER viewId:TableViewCell_TextField_Normal],
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"User Name") value:nil placeHodler:LOCALSTR(@"Ftp Account") maxLength:31 viewId:TableViewCell_TextField_Normal],
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Password") value:nil placeHodler:LOCALSTR(@"Ftp Password") maxLength:31 viewId:TableViewCell_TextField_Normal],
                         passModel,
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Path") value:@"./" placeHodler:LOCALSTR(@"Path") maxLength:63 viewId:TableViewCell_TextField_Normal], nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_FTP_PARAM_EXT:{
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            if(size >= sizeof(HI_P2P_S_FTP_PARAM_EXT)){
                self.paras =[[FTPParam alloc] initWithData:(char*)data size:(int)size];
                [self refreshTable];
            }
        }
            break;
        case HI_P2P_SET_FTP_PARAM_EXT:{
                if(size >=0){
                    if(self.paras){
                        if(self.paras.u32Check == 1){
                            [self doSaveFtpSetting];
                        }
                        else{
                            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
                            [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }
                else{
                    if(self.paras && self.paras.u32Check == 1){
                        [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Test failed, continue to save?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"Continue") actionDefaultBlock:^{
                            //[MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
                            [self doSaveFtpSetting];
                        } actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:^{
                            
                            [MBProgressHUD hideAllHUDsForView:self.tableview animated:NO];
                        }];
                    }
                    else{
                        [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
                        [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
                    }
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
