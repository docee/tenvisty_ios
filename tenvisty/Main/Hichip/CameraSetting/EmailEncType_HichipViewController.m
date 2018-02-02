//
//  EmailEncTypeViewController.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/2.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "EmailEncType_HichipViewController.h"
#import "SelectItemTableViewCell.h"

@interface EmailEncType_HichipViewController ()

@property (strong,nonatomic) NSArray *items;
@end

@implementation EmailEncType_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)items{
    if(_items == nil){
        _items = [[NSArray alloc] initWithObjects:LOCALSTR(@"None"),LOCALSTR(@"SSL"),LOCALSTR(@"TLS"),LOCALSTR(@"STARTTLS"), nil];
    }
    return _items;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self items].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_SelectItem;
    SelectItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    cell.leftLabel.text = [[self items] objectAtIndex:indexPath.row];
    
    [cell setSelect:indexPath.row == self.encType];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.encType = indexPath.row;
    [self performSegueWithIdentifier:@"unwind_EmailEncTypp2EmailSetting" sender:self];
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
