//
//  ChangeCameraNameViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ChangeCameraPassword_HichipViewController.h"
#import "TextFieldTableViewCell.h"

@interface ChangeCameraPassword_HichipViewController ()<MyCameraDelegate>{
    NSString *newCameraPassword;
}

@property (strong,nonatomic) NSArray *listItems;
@end

@implementation ChangeCameraPassword_HichipViewController

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
    
//    TwsTableViewCell *cell0 = (TwsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    TwsTableViewCell *cell1 = (TwsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    TwsTableViewCell *cell2 = (TwsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    [cell0 resignFirstResponder];
//    [cell1 resignFirstResponder];
//    [cell2 resignFirstResponder];
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
    
    NSLog(@"%@ setUpCamera:%@ newUserName:%@   newPassword:%@", self.title, self.camera.uid, @"admin", newPassword);
    
    HI_P2P_SET_AUTH *auth = (HI_P2P_SET_AUTH*)malloc(sizeof(HI_P2P_SET_AUTH));
    memset(auth, 0, sizeof(HI_P2P_SET_AUTH));
    
    auth->sOldUser.u32UserLevel = 0;
    base64Encode((char *)[self.camera.user UTF8String],(char *)auth->sOldUser.u8UserName);
    base64Encode((char *)[self.camera.pwd UTF8String],(char *)auth->sOldUser.u8Password);
    
    auth->sNewUser.u32UserLevel = 0;
    base64Encode((char *)[self.camera.user UTF8String],(char *)auth->sNewUser.u8UserName);
    base64Encode((char *)[newPassword UTF8String],(char *)auth->sNewUser.u8Password);
    
    /*
     *  HI_P2P_SET_USERNAME     可以修改用户名与密码  （暂时失效）
     *  HI_P2P_SET_USER_PARAM   修改密码
     */
    //    [myCamera sendIOCtrl:HI_P2P_SET_USERNAME Data:(char *)auth Size:sizeof(HI_P2P_SET_AUTH)];
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_USER_PARAM Data:(char*)auth DataSize:sizeof(HI_P2P_SET_AUTH)];
    free(auth);
}


- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_SET_USER_PARAM:
            if(size >= 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    self.camera.pwd = newCameraPassword;
                    [GBase editCamera:self.camera];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                        [[[iToast makeText:LOCALSTR(@"Password changed successfully, device will reconnect soon.")] setDuration:1] show];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                    
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                    [[[iToast makeText:LOCALSTR(@"Setting Failed")] setDuration:1] show];
                });
            }
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
