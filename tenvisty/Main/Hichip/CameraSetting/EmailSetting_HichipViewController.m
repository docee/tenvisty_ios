//
//  EmailSetting_HichipViewController.m
//  tenvisty
//
//  Created by Tenvis on 2018/1/31.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "EmailSetting_HichipViewController.h"
#import "ListImgTableViewCellModel.h"
#import "TextFieldTableViewCell.h"
#import "PasswordFieldTableViewCell.h"
#import "MutilTextFieldTableViewCell.h"
#import "BaseTableView.h"

@interface EmailSetting_HichipViewController ()
@property (weak, nonatomic) IBOutlet BaseTableView *tableview;

@property (strong,nonatomic) NSArray *listItems;
@end

@implementation EmailSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview setBackgroundColor:Color_GrayLightest];
    // Do any additional setup after loading the view.
}

-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
            [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Email") showValue:YES value:@"" viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Password") showValue:YES value:@"" viewId:TableViewCell_TextField_Password],nil];
        NSArray *sec2 = [[NSArray alloc] initWithObjects:
            [ListImgTableViewCellModel initObj:@"" title:LOCALSTR(@"Send to") showValue:YES value:@"" viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:@"" title:LOCALSTR(@"SMTP Server Host") showValue:YES value:@"" viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:@"" title:LOCALSTR(@"Port") showValue:YES value:@"" viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:@"" title:LOCALSTR(@"Safe link") showValue:YES value:@"" viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:@"" title:LOCALSTR(@"Subject") showValue:YES value:@"" viewId:TableViewCell_TextField_Normal],
            [ListImgTableViewCellModel initObj:@"" title:LOCALSTR(@"Message") showValue:YES value:@"" viewId:TableViewCell_TextField_Multi],
                         nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1,sec2, nil];
    }
    return _listItems;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    ListImgTableViewCellModel *model  = [[self.listItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if([model.viewId isEqualToString:TableViewCell_TextField_Normal]){
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.viewId forIndexPath:indexPath];
        cell.title = model.titleText;
        cell.value= model.titleValue;
        return cell;
    }
    else if([model.viewId isEqualToString:TableViewCell_TextField_Password]){
        PasswordFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.viewId forIndexPath:indexPath];
        cell.title = model.titleText;
        cell.value = model.titleValue;
        return cell;
    }
    else if([model.viewId isEqualToString:TableViewCell_TextField_Multi]){
        MutilTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.viewId forIndexPath:indexPath];
        cell.title = model.titleText;
        cell.value = model.titleValue;
        return cell;
    }
    return nil;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
