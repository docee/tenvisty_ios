//
//  ChangeCameraNameViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ChangeCameraPasswordViewController.h"
#import "TextFieldTableViewCell.h"

@interface ChangeCameraPasswordViewController ()

@end

@implementation ChangeCameraPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if([self.camera.pwd isEqualToString:DEFAULT_PASSWORD]){
        [self.navigationItem.leftBarButtonItem setEnabled:NO];// = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_TextField_Normal;
    TwsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.title = LOCALSTR(@"Old");
        cell.placeHolder = @"Old Password";
        //[cell.rightTextField becomeFirstResponder];
    }
    else if(indexPath.row == 1){
        cell.title = LOCALSTR(@"New");
        cell.placeHolder  = @"New Password";
    }
    else if(indexPath.row == 2){
        cell.title = LOCALSTR(@"Confirm");
        cell.placeHolder = @"Confirm Password";
    }
    return cell;
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
