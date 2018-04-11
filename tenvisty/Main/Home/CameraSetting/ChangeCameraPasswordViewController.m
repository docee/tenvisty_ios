//
//  ChangeCameraNameViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ChangeCameraPasswordViewController.h"
#import "TextFieldTableViewCell.h"

@interface ChangeCameraPasswordViewController ()<MyCameraDelegate>{
    NSString *newCameraPassword;
}

@property (strong,nonatomic) NSArray *listItems;
@end

@implementation ChangeCameraPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setup];
    if([self.camera.pwd isEqualToString:DEFAULT_PASSWORD]){
        [self.navigationItem.leftBarButtonItem setEnabled:NO];// = nil;
    }
//    [_btnChangePassword setTitleEdgeInsets:UIEdgeInsetsMake(0, -_btnChangePassword.currentImage.size.width, 0, _btnChangePassword.currentImage.size.width)];
//    [_btnChangePassword setImageEdgeInsets:UIEdgeInsetsMake(0, _btnChangePassword.titleLabel.bounds.size.width, 0, -_btnChangePassword.titleLabel.bounds.size.width)];
}
-(void)setup{
    self.navigationController.title = LOCALSTR(@"Change Camera Password");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Old") value:[self.camera.pwd isEqualToString:DEFAULT_PASSWORD]?self.camera.pwd:@"" placeHodler:LOCALSTR(@"Old Password") maxLength:31 viewId:TableViewCell_TextField_Password],
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"New") value:nil placeHodler:LOCALSTR(@"New Password") maxLength:31 viewId:TableViewCell_TextField_Password],
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Confirm") value:nil placeHodler:LOCALSTR(@"Confirm Password") maxLength:31 viewId:TableViewCell_TextField_Password], nil];
        for(int i = 0; i< sec1.count ;i++){
            ((ListImgTableViewCellModel*)sec1[i]).rightImage = nil;
        }
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (IBAction)save:(id)sender {
    [self.view endEditing:YES];
    NSString *oldPassword = [self getRowValue:0 section:0];
    NSString *newPassword =[self getRowValue:1 section:0];
    NSString *confirmPassword = [self getRowValue:2 section:0];
    if(oldPassword.length == 0 || newPassword.length == 0 || confirmPassword.length == 0){
        [[iToast makeText:LOCALSTR(@"Please complete each password.")] show];
    }
    else if(![oldPassword isEqualToString:self.camera.pwd]){
        [[iToast makeText:LOCALSTR(@"The old password is wrong.")] show];
    }
    else if(![newPassword isEqualToString:confirmPassword]){
        [[iToast makeText:LOCALSTR(@"New Password does not match.")] show];
    }
    else if([oldPassword isEqualToString:newPassword]){
        [[iToast makeText:LOCALSTR(@"The new password is the same as the old password.")] show];
    }
    else if(newPassword.length>12 || newPassword.length<6){
        [[iToast makeText:LOCALSTR(@"The format of password is incorrect.")] show];
    }
    else if(![TwsTools checkPasswordFormat:newPassword]){
        [[iToast makeText:LOCALSTR(@"The format of password is incorrect.")] show];
    }
    else{
        newCameraPassword = newPassword;
        [self doModifyPassword:oldPassword newPwd:newPassword];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewCellFooter"];
    for (UIView *view in [[cell.contentView subviews] objectAtIndex:0].subviews) {
        if([view isKindOfClass:[UIButton class]]){
            UIButton * btn = (UIButton *)view;
            [btn setTitle:LOCALSTR(@"show password") forState:UIControlStateNormal];
            CGFloat btnImageWidth = btn.imageView.bounds.size.width;
            CGFloat btnLabelWidth = btn.titleLabel.bounds.size.width;
            CGFloat margin = 3;
            
            btnImageWidth += margin;
            btnLabelWidth += margin;
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnImageWidth, 0, btnImageWidth)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btnLabelWidth, 0, -btnLabelWidth)];
            [btn addTarget:self action:@selector(togglePassword:) forControlEvents:UIControlEventTouchUpInside];
//            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.currentImage.size.width - btn.titleLabel.bounds.size.width, 0, btn.currentImage.size.width)];
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width+btn.currentImage.size.width, 0, -btn.titleLabel.bounds.size.width)];
            break;
        }
        else if([view isKindOfClass:[UILabel class]]){
               UILabel *lab = (UILabel *)view;
                lab.text = LOCALSTR(@"Please make sure your password length is 6-12 characters and contains at least two combinations of below characters.\n    1.capital\n    2.small letter\n    3.number\n    4.special character：~!@$%^()_-,|/*.");
        }
    }
    return cell.contentView;
}

-(void)togglePassword:(UIButton *)sender{
    sender.selected = !sender.selected;
    for(int i=0; i< 3;i++){
        PasswordFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(sender.selected){
            [cell showPassword];
        }
        else{
            [cell hidePassword];
        }
    }
}

-(void)doModifyPassword:(NSString*)oldPassword newPwd:(NSString*)newPassword{
    [MBProgressHUD showMessag:LOCALSTR(@"Changing") toView:self.tableView].userInteractionEnabled = YES;
    SMsgAVIoctrlSetPasswdReq *req = malloc(sizeof(SMsgAVIoctrlSetPasswdReq));
    memset(req, 0, sizeof(SMsgAVIoctrlSetPasswdReq));
    memcpy(req->oldpasswd, [oldPassword UTF8String], oldPassword.length);
    memcpy(req->newpasswd, [newPassword UTF8String], newPassword.length);
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_SETPASSWORD_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlSetPasswdReq)];
    free(req);
    req = nil;
}


- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_SETPASSWORD_RESP:
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                
                self.camera.pwd = newCameraPassword;
                [GBase editCamera:self.camera];
                [self.camera stop];
                [self.camera start];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[iToast makeText:LOCALSTR(@"Password changed successfully, device will reconnect soon.")] show];
                });
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            });
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
