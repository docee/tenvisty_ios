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
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.leftLabel.text = LOCALSTR(@"Old");
        [cell.rightTextField setPlaceholder:@"Old Password"];
        //[cell.rightTextField becomeFirstResponder];
    }
    else if(indexPath.row == 1){
        cell.leftLabel.text = LOCALSTR(@"New");
        [cell.rightTextField setPlaceholder:@"New Password"];
    }
    else if(indexPath.row == 2){
        cell.leftLabel.text = LOCALSTR(@"Confirm");
        [cell.rightTextField setPlaceholder:@"Confirm Password"];
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
