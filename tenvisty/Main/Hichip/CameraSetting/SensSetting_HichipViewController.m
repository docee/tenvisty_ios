//
//  SensSettingViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SensSetting_HichipViewController.h"
#import "MdParam.h"

@interface SensSetting_HichipViewController (){
    NSInteger sensLevel;
    MdParam *gmMdParamArea1;
    MdParam *gmMdParamArea2;
    MdParam *gmMdParamArea3;
    MdParam *gmMdParamArea4;
    
}
@property (nonatomic,strong) NSArray *sensValue;
@property (strong,nonatomic) NSArray *items;
@end

@implementation SensSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

-(void)setup{
    self.navigationController.title = LOCALSTR(@"Sensitivity Setting");
    sensLevel = -1;
    _sensValue = @[@80,@60,@40,@20,@0];
    [self doGetEventSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doGetEventSetting{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].userInteractionEnabled = YES;
    // 获取全部区域的参数
    for (NSInteger i = HI_P2P_MOTION_AREA_1; i <= HI_P2P_MOTION_AREA_MAX; i++) {
        HI_P2P_S_MD_PARAM *md_param = (HI_P2P_S_MD_PARAM*)malloc(sizeof(HI_P2P_S_MD_PARAM));
        memset(md_param, 0, sizeof(HI_P2P_S_MD_PARAM));
        md_param->struArea.u32Area = (HI_U32)i;
        md_param->u32Channel = 0;
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_MD_PARAM Data:(char *)md_param DataSize:sizeof(HI_P2P_S_MD_PARAM)];
        free(md_param);
        md_param = nil;
    }
}

-(void)doSetEventSetting:(NSInteger)sens{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].userInteractionEnabled = YES;
    if(gmMdParamArea1){
        gmMdParamArea1.u32Enable = sens == 0?0:1;
        gmMdParamArea1.u32Sensi = (int)sens;
        HI_P2P_S_MD_PARAM *para1 = [gmMdParamArea1 model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_MD_PARAM Data:(char*)para1 DataSize:sizeof(HI_P2P_S_MD_PARAM)];
        free(para1);
        para1 = nil;
    }
    if(gmMdParamArea2 && sens == 0){
        gmMdParamArea2.u32Enable = 0;
        HI_P2P_S_MD_PARAM *para2 = [gmMdParamArea2 model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_MD_PARAM Data:(char*)para2 DataSize:sizeof(HI_P2P_S_MD_PARAM)];
        free(para2);
        para2 = nil;
    }
    if(gmMdParamArea3 && sens == 0){
        gmMdParamArea3.u32Enable = 0;
        HI_P2P_S_MD_PARAM *para3 = [gmMdParamArea3 model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_MD_PARAM Data:(char*)para3 DataSize:sizeof(HI_P2P_S_MD_PARAM)];
        free(para3);
        para3 = nil;
    }
    if(gmMdParamArea4 && sens == 0){
        gmMdParamArea4.u32Enable = 0;
        HI_P2P_S_MD_PARAM *para4 = [gmMdParamArea4 model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_MD_PARAM Data:(char*)para4 DataSize:sizeof(HI_P2P_S_MD_PARAM)];
        free(para4);
        para4 = nil;
    }
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
        if(sens >= [(NSNumber*)_sensValue[i] intValue]){
            return i;
        }
    }
    return 0;
}
-(NSInteger)getSens:(NSInteger)level{
    return [(NSNumber*)_sensValue[level] integerValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self doSetEventSetting:[self getSens:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_MD_PARAM:{
            HI_P2P_S_MD_PARAM *resp = (HI_P2P_S_MD_PARAM*)data;
            if(resp->struArea.u32Area == HI_P2P_MOTION_AREA_1){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if(resp->struArea.u32Enable == 0){
                        sensLevel = [self getLevel:0];
                    }
                    else{
                        for(int i=0;i<_sensValue.count;i++){
                            if(resp->struArea.u32Sensi >= [(NSNumber*)_sensValue[i] intValue]){
                                sensLevel = i;
                                break;
                            }
                        }
                    }
                gmMdParamArea1 = [[MdParam alloc] initWithData:(char*)data size:(int)size] ;
                [self.tableView reloadData];
            }
            else if(resp->struArea.u32Area == HI_P2P_MOTION_AREA_2){
                gmMdParamArea2 = [[MdParam alloc] initWithData:(char*)data size:(int)size];
            }
            else if(resp->struArea.u32Area == HI_P2P_MOTION_AREA_3){
                gmMdParamArea3 =  [[MdParam alloc] initWithData:(char*)data size:(int)size];
            }
            else if(resp->struArea.u32Area == HI_P2P_MOTION_AREA_4){
                gmMdParamArea4 = [[MdParam alloc] initWithData:(char*)data size:(int)size];
            }
            break;
        }
        case HI_P2P_SET_MD_PARAM:{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
            [self.navigationController popViewControllerAnimated:YES];
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
