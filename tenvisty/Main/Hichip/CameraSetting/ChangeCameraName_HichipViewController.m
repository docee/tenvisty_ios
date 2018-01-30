//
//  ChangeCameraNameViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ChangeCameraName_HichipViewController.h"
#import "TextFieldTableViewCell.h"

@interface ChangeCameraName_HichipViewController ()

@end

@implementation ChangeCameraName_HichipViewController

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
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_TextField_Normal;
    TwsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    cell.title = LOCALSTR(@"Name");
    cell.value = self.camera.nickName;
    //[cell.rightTextField becomeFirstResponder];
    return cell;
}
- (IBAction)save:(id)sender {
    NSString *nickName = ((TwsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).value;
    // 用于过滤空格和Tab换行符
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    nickName = [nickName stringByTrimmingCharactersInSet:characterSet];
    if(nickName.length == 0){
        [TwsTools presentAlertMsg:self message:LOCALSTR(@"[Camera name] must be entered.")];
        return;
    }
    self.camera.nickName = nickName;
    [GBase editCamera:self.camera];
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
