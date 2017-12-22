//
//  AboutViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/11/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "AboutListViewController.h"
#import "ListImgTableViewCellModel.h"
#import "ListImgTableViewCell.h"

@interface AboutListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSArray *listItems;


@end

@implementation AboutListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerNib:[UINib nibWithNibName:@"ListImgTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_ListImg];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)listItems{
    if(!_listItems){
        _listItems = [[NSArray alloc] initWithObjects:[ListImgTableViewCellModel initObj:@"ic_menu_help" title:LOCALSTR(@"Help") showValue:NO value:nil viewId:TableViewCell_ListImg],
                      [ListImgTableViewCellModel initObj:@"ic_menu_privacypolicy" title:LOCALSTR(@"Privacy Policy") showValue:NO value:nil viewId:TableViewCell_ListImg],
                      [ListImgTableViewCellModel initObj:@"ic_menu_info" title:LOCALSTR(@"APP Version") showValue:NO value:nil viewId:TableViewCell_ListImg], nil];
        
        
    }
    return _listItems;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    
    ListImgTableViewCellModel *model = [[self listItems]objectAtIndex:indexPath.row];
    NSString *vid = model.viewId;
    if([vid isEqualToString:TableViewCell_ListImg]){
        ListImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
        [cell setLeftImage:model.titleImgName];
        cell.title = model.titleText;
        cell.showValue = model.showValue;
        cell.value = model.titleValue;
        //        [cell setSeparatorInset:UIEdgeInsetsZero];
        //        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
