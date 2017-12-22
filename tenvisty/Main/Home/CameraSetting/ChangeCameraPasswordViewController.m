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

@end

@implementation ChangeCameraPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if([self.camera.pwd isEqualToString:DEFAULT_PASSWORD]){
        [self.navigationItem.leftBarButtonItem setEnabled:NO];// = nil;
    }
//    [_btnChangePassword setTitleEdgeInsets:UIEdgeInsetsMake(0, -_btnChangePassword.currentImage.size.width, 0, _btnChangePassword.currentImage.size.width)];
//    [_btnChangePassword setImageEdgeInsets:UIEdgeInsetsMake(0, _btnChangePassword.titleLabel.bounds.size.width, 0, -_btnChangePassword.titleLabel.bounds.size.width)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{

    NSString *id = TableViewCell_TextField_Password;
    PasswordFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.title = LOCALSTR(@"Old");
        cell.placeHolder = LOCALSTR(@"Old Password");
        if([self.camera.pwd isEqualToString:DEFAULT_PASSWORD]){
            cell.value = self.camera.pwd;
        }
        //[cell.rightTextField becomeFirstResponder];
    }
    else if(indexPath.row == 1){
        cell.title = LOCALSTR(@"New");
        cell.placeHolder  = LOCALSTR(@"New Password");
    }
    else if(indexPath.row == 2){
        cell.title = LOCALSTR(@"Confirm");
        cell.placeHolder = LOCALSTR(@"Confirm Password");
    }
    [cell hideImgBtn];
    return cell;
}
- (IBAction)save:(id)sender {
    TwsTableViewCell *cell0 = (TwsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    TwsTableViewCell *cell1 = (TwsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    TwsTableViewCell *cell2 = (TwsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell0 resignFirstResponder];
    [cell1 resignFirstResponder];
    [cell2 resignFirstResponder];
    NSString *oldPassword =  cell0.value;
    NSString *newPassword = cell1.value;
    NSString *confirmPassword = cell2.value;
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
}


- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case IOTYPE_USER_IPCAM_SETPASSWORD_RESP:
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
               
                [[[iToast makeText:LOCALSTR(@"Password changed successfully, device will reconnect soon.")] setDuration:1] show];
                self.camera.pwd = newCameraPassword;
                [GBase editCamera:self.camera];
                [self.camera stop];
                [self.camera start];
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
