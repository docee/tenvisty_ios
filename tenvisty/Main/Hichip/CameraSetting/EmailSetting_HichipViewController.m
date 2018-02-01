//
//  EmailSetting_HichipViewController.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/31.
//  Copyright © 2018年 Tenvis. All rights reserved.
//
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenB [UIScreen mainScreen].bounds

#import "EmailSetting_HichipViewController.h"
#import "ListImgTableViewCellModel.h"
#import "TextFieldTableViewCell.h"
#import "PasswordFieldTableViewCell.h"
#import "MutilTextFieldTableViewCell.h"
#import "BaseTableView.h"
#import "EmailParam.h"
#import "ListImgTableViewCell.h"

@interface EmailSetting_HichipViewController ()
@property (weak, nonatomic) IBOutlet BaseTableView *tableview;
@property (nonatomic,strong) EmailParam *paras;

@property (strong,nonatomic) NSArray *listItems;
@end

@implementation EmailSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
-(void)setup{
    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
    [self doGetEmailSetting];
}

-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Email") value:nil placeHodler:LOCALSTR(@"Email Address") maxLength:63 viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Password") value:nil placeHodler:LOCALSTR(@"Email Password") maxLength:63 viewId:TableViewCell_TextField_Password], nil];
        NSArray *sec2 = [[NSArray alloc] initWithObjects:
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Send to") value:nil placeHodler:LOCALSTR(@"Receiver Email") maxLength:63 viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:LOCALSTR(@"SMTP Server Host") value:nil placeHodler:LOCALSTR(@"SMTP Server Host") maxLength:63 viewId:TableViewCell_TextField_Normal],
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Port") value:@"587" placeHodler:LOCALSTR(@"SMTP Server Port") maxLength:5 filter:@"^[0-9]$" viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Encrypt Type") value:@"STARTTLS" placeHodler:LOCALSTR(@"Encrypt Type") maxLength:5 viewId:TableViewCell_ListImg],
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Subject") value:LOCALSTR(@"IP Camera sent you an Email alert") placeHodler:LOCALSTR(@"Subject") maxLength:127 viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Message") value:LOCALSTR(@"Hello! Your camera has detected suspicious motion. Snapshots have been sent to your email address. Please log in to check.") placeHodler:LOCALSTR(@"Message Body") maxLength:255 viewId:TableViewCell_TextField_Multi], nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1,sec2, nil];
    }
    return _listItems;
}

-(void)refreshTable{
    if(_paras){
        ListImgTableViewCellModel *emailModel = self.listItems[0][0];
        emailModel.titleValue = _paras.strUsernm;
        ListImgTableViewCellModel *passwordModel = self.listItems[0][1];
        passwordModel.titleValue = _paras.strPasswd;
        ListImgTableViewCellModel *sendToModel = self.listItems[1][0];
        sendToModel.titleValue = _paras.strTo;
        ListImgTableViewCellModel *smtpModel = self.listItems[1][1];
        smtpModel.titleValue = _paras.strSvr;
        ListImgTableViewCellModel *portModel = self.listItems[1][2];
        portModel.titleValue = FORMAT(@"%d",_paras.u32Port);
        ListImgTableViewCellModel *encTypeModel = self.listItems[1][3];
        encTypeModel.titleValue = [_paras connectionType];
        ListImgTableViewCellModel *subjectModel = self.listItems[1][4];
        subjectModel.titleValue = _paras.strSubject;
        ListImgTableViewCellModel *messageModel = self.listItems[1][5];
        messageModel.titleValue = _paras.strText;
        [self.tableview reloadData];
    }
}

-(void)doGetEmailSetting{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_EMAIL_PARAM Data:(char*)nil DataSize:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.enableEmail?self.listItems.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        if(self.enableEmail){
            return ((NSArray*)[self.listItems objectAtIndex:section]).count;
        }
        else{
            return 0;
        }
    }
    else if(section == 1){
        if(self.enableAdvance){
            return ((NSArray*)[self.listItems objectAtIndex:section]).count;
        }
        else{
            return 0;
        }
    }
    return  ((NSArray*)[self.listItems objectAtIndex:section]).count;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewCell *cell = nil;
    if(section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewCell_emailSwitch"];
        for(UISwitch *view in cell.contentView.subviews){
            if([view isKindOfClass:[UISwitch class]]){
                [view addTarget:self action:@selector(doEnableEmail:) forControlEvents:UIControlEventTouchUpInside];
                [view setOn:self.enableEmail];
                break;
            }
        }
    }
    else if(section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell_emailAdvanceSwitch"];
        for(UISwitch *view in cell.contentView.subviews){
             if([view isKindOfClass:[UISwitch class]]){
                [view addTarget:self action:@selector(doEnableAdvance:) forControlEvents:UIControlEventTouchUpInside];
                 [view setOn:self.enableAdvance];
                break;
            }
        }
    }
    [cell.contentView setBackgroundColor:Color_GrayLightest];
    return cell.contentView;
}

-(void)doEnableEmail:(UISwitch*)sender{
    self.enableEmail = sender.isOn;
    [self.tableview reloadData];
}

-(void)doEnableAdvance:(UISwitch*)sender{
    self.enableAdvance = sender.isOn;
    [self.tableview reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if(indexPath.section == 1&& indexPath.row == 5){
        return 100.0;
    }
    return 50.0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     self.tableview.translatesAutoresizingMaskIntoConstraints = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshTable];
}
- (IBAction)doSaveSetting:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
    HI_P2P_S_EMAIL_PARAM *p = [self.paras model];
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_EMAIL_PARAM Data:(char*)p DataSize:sizeof(HI_P2P_S_EMAIL_PARAM)];
    free(p);
    p = nil;
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_EMAIL_PARAM:{
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            if(size >= sizeof(HI_P2P_S_EMAIL_PARAM)){
                self.paras =[[EmailParam alloc] initWithData:(char*)data size:(int)size];
                [self refreshTable];
            }
        }
            break;
        case HI_P2P_SET_EMAIL_PARAM:{
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            if(size >=0){
                [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
            }
        }
        case HI_P2P_SET_EMAIL_PARAM_EXT:{
            if(size >=0){
                [[iToast makeText:LOCALSTR(@"Test Successfully")] show];
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
