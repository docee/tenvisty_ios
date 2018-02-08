//
//  SDCardViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SDCard_HichipViewController.h"
#import "SDCard.h"

@interface SDCard_HichipViewController (){
    BOOL isFormatting;
}

@property (strong,nonatomic) NSArray *listItems;
@property (nonatomic, strong) SDCard *sdcard;
@end

@implementation SDCard_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    // Do any additional setup after loading the view.
}
-(void)setup{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES].userInteractionEnabled = YES;
    [self getSDCardInfo];
}
-(void)getSDCardInfo{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_SD_INFO Data:(char*)nil DataSize:0];
}

-(void)doFormatSDCard{
    [MBProgressHUD showMessag:LOCALSTR(@"formating...") toView:self.tableView].userInteractionEnabled = YES;
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_FORMAT_SD Data:(char*)nil DataSize:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Total size")  showValue:YES value:nil viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Free size")  showValue:YES value:nil viewId:TableViewCell_TextField_Disable]
                         ,nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
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

-(void)refreshTable{
    if(self.sdcard){
        [self setRowValue:FORMAT(@"%d MB",self.sdcard.u32Space/1024) row:0 section:0];
        [self setRowValue:FORMAT(@"%d MB",self.sdcard.u32LeftSpace/1024) row:1 section:0];
        [self.tableView reloadData];
    }
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_SD_INFO:{
            if(size >= sizeof(HI_P2P_S_SD_INFO)){
                SDCard *sdcardTemp = [[SDCard alloc] initWithData:(char*)data size:(int)size];
                if(self.sdcard  && isFormatting){
                    if(self.sdcard.u32Space > 0){
                        if(sdcardTemp.u32Space > 0){
                            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                            [[[iToast makeText:LOCALSTR(@"format success")]setDuration:1] show];
                            isFormatting= NO;
                            self.sdcard = sdcardTemp;
                            [self refreshTable];
                        }
                        else{
                            [self getSDCardInfo];
                        }
                    }
                    else{
                        [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                        [[[iToast makeText:LOCALSTR(@"format success")]setDuration:1] show];
                        isFormatting= NO;
                        self.sdcard = sdcardTemp;
                        [self refreshTable];
                    }
                }
                else{
                    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                    self.sdcard = sdcardTemp;
                    [self refreshTable];
                }
            }
            else{
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            }
            break;
        }
        case HI_P2P_SET_FORMAT_SD:{
            isFormatting = YES;
            [self setRowValue:nil row:0 section:0];
            [self setRowValue:nil row:1 section:0];
            [self.tableView reloadData];
            sleep(15);
            [self getSDCardInfo];
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
