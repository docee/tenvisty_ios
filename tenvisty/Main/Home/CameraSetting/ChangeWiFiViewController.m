//
//  ChangeWiFiViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ChangeWiFiViewController.h"

@interface ChangeWiFiViewController ()

@end

@implementation ChangeWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"mid :%f",[NSDate timeIntervalSinceReferenceDate]);
    // Do any additional setup after loading the view.
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
    if(indexPath.row == 0){
        NSString *id = TableViewCell_TextField_Disable;
        TextFieldDisableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
        cell.leftLabel.text = LOCALSTR(@"SSID");
        cell.rightTextField.text = @"tenvis";
        [cell setLeftImage:@"ic_wifi"];
        NSLog(@"end1 :%f",[NSDate timeIntervalSinceReferenceDate]);
        return cell;
    }
    else{
        NSString *id = TableViewCell_TextField_Password;
        PasswordFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
        cell.leftLabel.text = LOCALSTR(@"Password");
        [cell setLeftImage:@"ic_password"];
        //[cell.midPasswordField becomeFirstResponder];
        NSLog(@"end2 :%f",[NSDate timeIntervalSinceReferenceDate]);
        return cell;
    }
    return nil;
}
- (IBAction)save:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
