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
#import "EmailEncType_HichipViewController.h"
#import "AlarmLink.h"
#import "EmailModel.h"

#define EMAIL_DEFAULT_SUBJECT LOCALSTR(@"IP Camera sent you an Email alert")
#define EMAIL_DEFAULT_TEXT LOCALSTR(@"Hello! Your camera has detected suspicious motion. Snapshots have been sent to your email address. Please log in to check.")
#define EMAIL_DEFAULT_PORT 465
#define EMAIL_DEFAULT_AUTH 1


@interface EmailSetting_HichipViewController ()<CellModelDelegate>{
    BOOL originEmailSwitch;
    AlarmLink *alarmParas;
    BOOL isSetting;
    NSMutableArray *emailArray;
    EmailModel *emailModel;
}
@property (weak, nonatomic) IBOutlet BaseTableView *tableview;
@property (nonatomic,strong) EmailParam *paras;

@property (strong,nonatomic) NSArray *listItems;
@end

@implementation EmailSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    originEmailSwitch = self.enableEmail;
}
-(void)setup{
    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
    emailArray = [[NSMutableArray alloc]initWithObjects:
                  [[EmailModel alloc] initWithData:@"yahoo.com" smtpServer:@"smtp.mail.yahoo.com" port:465 encryptType:ENCTYPE_SSL],
                  [[EmailModel alloc] initWithData:@"outlook.com" smtpServer:@"smtp-mail.outlook.com" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"qq.com" smtpServer:@"smtp.qq.com" port:465 encryptType:ENCTYPE_SSL],
                  [[EmailModel alloc] initWithData:@"163.com" smtpServer:@"smtp.163.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"126.com" smtpServer:@"smtp.126.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"yeah.net" smtpServer:@"smtp.yeah.net" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"sohu.com" smtpServer:@"smtp.sohu.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"tom.com" smtpServer:@"smtp.tom.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"21cn.com" smtpServer:@"smtp.21cn.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"aol.com" smtpServer:@"smtp.aol.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"orange.fr" smtpServer:@"smtp.orange.fr" port:465 encryptType:ENCTYPE_SSL],
                  [[EmailModel alloc] initWithData:@"wanadoo.fr" smtpServer:@"smtp.orange.fr" port:465 encryptType:ENCTYPE_SSL],
                  [[EmailModel alloc] initWithData:@"hotmail.com" smtpServer:@"smtp.live.com" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"hotmail.fr" smtpServer:@"smtp.live.com" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"live.com" smtpServer:@"smtp.live.com" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"live.fr" smtpServer:@"smtp.live.com" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"msn.com" smtpServer:@"smtp.live.com" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"yahoo.fr" smtpServer:@"smtp.mail.yahoo.fr" port:465 encryptType:ENCTYPE_SSL],
                  [[EmailModel alloc] initWithData:@"sfr.fr" smtpServer:@"smtp.sfr.fr" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"neuf.fr" smtpServer:@"smtp.sfr.fr" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"free.fr" smtpServer:@"smtp.free.fr" port:465 encryptType:ENCTYPE_SSL],
                  [[EmailModel alloc] initWithData:@"gmail.com" smtpServer:@"smtp.gmail.com" port:465 encryptType:ENCTYPE_SSL],
                  [[EmailModel alloc] initWithData:@"club-internet.fr" smtpServer:@"smtp.sfr.fr" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"aol.com" smtpServer:@"smtp.fr.aol.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"laposte.net" smtpServer:@"smtp.laposte.net" port:465 encryptType:ENCTYPE_SSL],
                  [[EmailModel alloc] initWithData:@"cegetel.fr" smtpServer:@"smtp.sfr.fr" port:587 encryptType:ENCTYPE_STARTTLS],
                  [[EmailModel alloc] initWithData:@"alice.fr" smtpServer:@"smtp.alice.fr" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"Noos.fr" smtpServer:@"mail.noos.fr" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"tele2.fr" smtpServer:@"smtp.tele2.fr" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"tiscali.fr" smtpServer:@"smtp.tiscali.fr" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"netcourrier.com" smtpServer:@"smtp.orange.fr" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"libertysurf.fr" smtpServer:@"mail.libertysurf.fr" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"gmx.fr" smtpServer:@"smail.gmx.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"caramail.fr" smtpServer:@"mail.gmx.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"gmx.com" smtpServer:@"mail.gmx.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"caramail.com" smtpServer:@"mail.gmx.com" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"bbox.fr" smtpServer:@"smtp.bouygtel.fr" port:25 encryptType:ENCTYPE_NONE],
                  [[EmailModel alloc] initWithData:@"numericable.fr" smtpServer:@"smtps.numericable.fr" port:587 encryptType:ENCTYPE_STARTTLS],  nil];
    [self doGetEmailSetting];
}

-(NSArray *)listItems{
    if(!_listItems){
        ListImgTableViewCellModel *emailAddrModel = [ListImgTableViewCellModel initObj:LOCALSTR(@"Email") value:nil placeHodler:LOCALSTR(@"Email Address") maxLength:63 viewId:TableViewCell_TextField_Normal];
        emailAddrModel.delegate = self;
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         emailAddrModel,
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Password") value:nil placeHodler:LOCALSTR(@"Email Password") maxLength:63 viewId:TableViewCell_TextField_Password], nil];
        NSArray *sec2 = [[NSArray alloc] initWithObjects:
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Send to") value:nil placeHodler:LOCALSTR(@"Receiver Email") maxLength:63 viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:LOCALSTR(@"SMTP Server Host") value:nil placeHodler:LOCALSTR(@"SMTP Server Host") maxLength:63 viewId:TableViewCell_TextField_Normal],
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Port") value:@"465" placeHodler:LOCALSTR(@"587/465/25") maxLength:5 filter:REGEX_NUMBER viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Encrypt Type") value:@"SSL" placeHodler:LOCALSTR(@"Encrypt Type") maxLength:5 viewId:TableViewCell_ListImg],
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Subject") value:EMAIL_DEFAULT_SUBJECT placeHodler:LOCALSTR(@"Subject") maxLength:127 viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:LOCALSTR(@"Message") value:EMAIL_DEFAULT_TEXT placeHodler:LOCALSTR(@"Message Body") maxLength:255 viewId:TableViewCell_TextField_Multi], nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1,sec2, nil];
    }
    return _listItems;
}

-(void)refreshTable{
    if(_paras){
        [self setRowValue:_paras.strUsernm row:0 section:0];
        [self setRowValue:_paras.strPasswd row:1 section:0];
        [self setRowValue:_paras.strTo row:0 section:1];
        [self setRowValue:_paras.strSvr row:1 section:1];
        [self setRowValue:FORMAT(@"%d",_paras.u32Port) row:2 section:1];
        [self setRowValue:[_paras connectionType] row:3 section:1];
        if(![_paras.strSubject isEqualToString:@""]){
            [self setRowValue:_paras.strSubject row:4 section:1];
        }
        else{
            [self setRowValue:EMAIL_DEFAULT_SUBJECT row:4 section:1];
        }
        if(![_paras.strText isEqualToString:@""]){
            [self setRowValue:_paras.strText row:5 section:1];
        }
        else{
            [self setRowValue:EMAIL_DEFAULT_TEXT row:5 section:1];
        }
        [self.tableview reloadData];
    }
}

-(void)reloadParasFromTable{
    if(_paras){
        _paras.strUsernm = [self getRowValue:0 section:0];
        _paras.strPasswd = [self getRowValue:1 section:0];
        _paras.strTo = [self getRowValue:0 section:1];
        _paras.strSvr = [self getRowValue:1 section:1];
        _paras.u32Port =   [[self getRowValue:2 section:1] intValue];
        _paras.u32Auth = [_paras connectionTypeValue:[self getRowValue:3 section:1]];
        _paras.strSubject = [self getRowValue:4 section:1];
        _paras.strText = [self getRowValue:5 section:1];
        _paras.u32LoginType = 1;
        _paras.strFrom = _paras.strUsernm;
        if([_paras.strSubject isEqualToString:@""]){
            _paras.strSubject = EMAIL_DEFAULT_SUBJECT;
        }
        
        if([_paras.strText isEqualToString:@""]){
            _paras.strText = EMAIL_DEFAULT_TEXT;
        }
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
    //[self refreshTable];
}
- (IBAction)doSaveSetting:(id)sender {
    [self.view endEditing:YES];
    if(self.enableEmail){
        [self doTest];
    }
    else if(self.enableEmail != originEmailSwitch){
        [self getEmailAlarmParas];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)doTest {
    [self reloadParasFromTable];
    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES].userInteractionEnabled = YES;
    HI_P2P_S_EMAIL_PARAM_EXT *p = [self.paras checkModel];
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_EMAIL_PARAM_EXT Data:(char*)p DataSize:sizeof(HI_P2P_S_EMAIL_PARAM_EXT)];
    free(p);
    p = nil;
}

- (void)doSave {
    HI_P2P_S_EMAIL_PARAM *p = [self.paras model];
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_EMAIL_PARAM Data:(char*)p DataSize:sizeof(HI_P2P_S_EMAIL_PARAM)];
    free(p);
    p = nil;
}

-(void)doSetEmailEnable{
    if(alarmParas){
        alarmParas.u32EmailSnap = self.enableEmail ? 1 : 0;
        HI_P2P_S_ALARM_PARAM *model = [alarmParas model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_ALARM_PARAM Data:(char*)model DataSize:sizeof(HI_P2P_S_ALARM_PARAM)];
        free(model);
        model = nil;
    }
}

-(void)getEmailAlarmParas{
    isSetting = YES;
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_ALARM_PARAM Data:(char*)nil DataSize:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 && indexPath.row == 3){
        [self performSegueWithIdentifier:@"EmailSetting2EncType" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_EMAIL_PARAM:{
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            if(size >= sizeof(HI_P2P_S_EMAIL_PARAM)){
                self.paras =[[EmailParam alloc] initWithData:(char*)data size:(int)size];
                self.enableAdvance = ![self isDefaultConf];
                [self refreshTable];
            }
        }
            break;
        case HI_P2P_SET_EMAIL_PARAM:{
            if(self.enableEmail == originEmailSwitch){
                [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
                if(size >=0){
                    [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
                }
            }
            else{
                [self getEmailAlarmParas];
            }
        }
            break;
        case HI_P2P_SET_EMAIL_PARAM_EXT:{
            if(size >=0){
                [self doSave];
            }
            else{
                [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Test failed, continue to save?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"Continue") actionDefaultBlock:^{
                    //[MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
                    [self doSave];
                } actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:^{
                    
                    [MBProgressHUD hideAllHUDsForView:self.tableview animated:NO];
                }];
            }
        }
            break;
        case HI_P2P_GET_ALARM_PARAM:{
            if(isSetting){
                if(size >= sizeof(HI_P2P_S_ALARM_PARAM)){
                    alarmParas =[[AlarmLink alloc] initWithData:(char*)data size:(int)size];
                    [self doSetEmailEnable];
                }
                else{
                    [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
                }
            }
        }
            break;
        case HI_P2P_SET_ALARM_PARAM:{
            if(isSetting){
                [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
                if(size >=0){
                    [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                     [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
                }
            }
        }
            break;
        default:
            break;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EmailSetting2EncType"]){
        EmailEncType_HichipViewController *controller = segue.destinationViewController;
        if(self.paras){
            controller.encType = self.paras.u32Auth;
        }
    }
}

//其他界面返回到此界面调用的方法
- (IBAction)EmailSettingViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{
    EmailEncType_HichipViewController *controller = (EmailEncType_HichipViewController*)fromViewController;
    if(self.paras){
        self.paras.u32Auth = (int)controller.encType;
        [self setRowValue:[_paras connectionType] row:3 section:1];
        [self.tableview reloadData];
    }
    return YES;
}


#pragma mark - getNeedServer
-(EmailModel *)getEmailModel:(NSString *)domainStr{
    for (EmailModel *m in emailArray) {
        if ([domainStr rangeOfString:m.domain].length > 0) {
            emailModel = m;
            return m;
        }
    }
    emailModel = nil;
    return nil;
}
-(NSString *)getSMTPServer:(NSString *)email{
    int location = (int)[email rangeOfString:@"@"].location + 1;
    if(location!= NSNotFound && location<[email length]){
        return [[NSString alloc] initWithFormat:@"smtp.%@",[email substringFromIndex:location] ] ;
    }
    return @"";
}

-(BOOL)isDefaultConf{
    if(!_paras){
        return YES;
    }
    if(_paras.strUsernm && _paras.strUsernm.length > 0){
        EmailModel *em = [self getEmailModel:_paras.strUsernm];
        if(em != nil && em.port == _paras.u32Port && em.encryptType == _paras.u32Auth && [em.smtpServer isEqualToString:_paras.strSvr]){
            return YES;
        }
        else if(_paras.u32Port == EMAIL_DEFAULT_PORT && _paras.u32Auth == EMAIL_DEFAULT_AUTH && [_paras.strFrom isEqualToString:_paras.strTo] && [_paras.strSvr isEqualToString:[self getSMTPServer:_paras.strUsernm]] && [_paras.strSubject isEqualToString:EMAIL_DEFAULT_SUBJECT] && [_paras.strText isEqualToString:EMAIL_DEFAULT_TEXT]){
            return YES;
        }
        else{
            return NO;
        }
    }
    else if(_paras.strFrom.length > 0 || _paras.strTo.length > 0 || _paras.strSvr.length > 0 || _paras.u32Port != 25 || _paras.u32Auth != 0){
        return NO;
    }
    else{
        return YES;
    }
}
- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didEndTextFiledEditing:(UITextField*)sender{
    NSIndexPath *indexPath = [self getIndexPath:cellModel];
    if(indexPath.row == 0 && indexPath.section == 0){
        if(![self.paras.strUsernm isEqualToString:cellModel.titleValue]){
            self.paras.strUsernm = cellModel.titleValue;
            self.paras.strTo = cellModel.titleValue;
            self.paras.strFrom = cellModel.titleValue;
            EmailModel *em1 = [self getEmailModel:cellModel.titleValue];
            if(em1 != nil){
                self.paras.strSvr = em1.smtpServer;
                self.paras.u32Port = em1.port;
                self.paras.u32Auth = em1.encryptType;
                [self refreshTable];
            }
            else{
                self.paras.strSvr = [self getSMTPServer:cellModel.titleValue];
                self.paras.u32Port = EMAIL_DEFAULT_PORT;
                self.paras.u32Auth = EMAIL_DEFAULT_AUTH;
                [self refreshTable];
            }
        }
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
