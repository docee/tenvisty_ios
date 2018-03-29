//
//  BaseTableViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()<BaseCameraDelegate,CellModelDelegate>

@property (strong,nonatomic) NSArray *listItems;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Normal];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldImgTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Img];
    [self.tableView registerNib:[UINib nibWithNibName:@"PasswordFieldTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Password];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldDisableTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Disable];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_Detail];
    [self.tableView registerNib:[UINib nibWithNibName:@"ListImgTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_ListImg];
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_Switch];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectItemTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_SelectItem];
    [self.tableView registerNib:[UINib nibWithNibName:@"MultiTextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Multi];
    [self.tableView registerNib:[UINib nibWithNibName:@"LinkButtonTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_Button_HyperLink];
    [self.tableView registerNib:[UINib nibWithNibName:@"SliderTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_Slider];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.listItems){
        return self.listItems.count;
    }
    else{
        return [super numberOfSectionsInTableView:tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.listItems){
        return ((NSArray*)self.listItems[section]).count;
    }
    else{
         return [super tableView:tableView numberOfRowsInSection:section];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.camera.cameraDelegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.camera.cameraDelegate = nil;
}


-(TwsTableViewCell*) getRowCell:(NSInteger)row{
    return (TwsTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    if(self.listItems){
        TwsTableViewCell *cell = nil;
        ListImgTableViewCellModel *model  = [[self.listItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:model.viewId forIndexPath:indexPath];
        cell.cellModel = model;
        model.delegate = self;
        return cell;
    }
    else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(NSString*)getRowValue:(NSInteger)row section:(NSInteger)section{
    NSString *v = ((ListImgTableViewCellModel*)self.listItems[section][row]).titleValue;
    if(v == nil){
        v = @"";
    }
    return v;
}

-(NSIndexPath*)getIndexPath:(ListImgTableViewCellModel*)cellModel{
    for( int i = 0; i < self.listItems.count; i++){
        for(int j = 0; j < ((NSArray*)self.listItems[i]).count; j++){
            if(self.listItems[i][j] == cellModel){
                return [NSIndexPath indexPathForRow:j inSection:i];
            }
        }
    }
    return nil;
}

-(void)setRowValue:(NSString*)val row:(NSInteger)row section:(NSInteger)section{
    ((ListImgTableViewCellModel*)self.listItems[section][row]).titleValue = val;
}

- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    if(self.camera != nil && self.camera.isSleeping){
        [TwsTools presentAlertMsg:self message:LOCALSTR(@"the camera is sleeping, you need to wake it up first.") actionDefaultBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
