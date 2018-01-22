//
//  SearchCameraTableViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/11/30.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SearchCameraTableViewController.h"
#import "SaveCameraTableViewController.h"

@interface SearchCameraTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labSearchOnLan;
@property (weak, nonatomic) IBOutlet UIImageView *imgSubLoading;
@property (weak, nonatomic) IBOutlet UIView *viewSubLoading;

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic,strong) SearchLanAsync* lanSearcher;
@end

@implementation SearchCameraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.lanSearcher = [[SearchLanAsync alloc] init];
    self.lanSearcher.delegate = self;
    [self.lanSearcher beginSearch];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lanSearcher.delegate = self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.lanSearcher stopSearch];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.lanSearcher.delegate = nil;
    [MBProgressHUD hideAllHUDsForView:self.viewSubLoading animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onReceiveSearchResult:(LANSearchCamera *)device status:(NSInteger)status{
    //开始搜索摄像机
    if(status == 2){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        });
    }
    //搜索到摄像机
    else if(status == 1){
        [self.searchResults addObject:device];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            MBProgressHUD *dd =[MBProgressHUD showHUDAddedTo:self.viewSubLoading animated:YES];
           // [dd setMode:MBProgressHUDModeAnnularDeterminate];
            [dd setColor:[UIColor clearColor]];
            [dd setTintColor:Color_Primary];
            [self.tableView reloadData];
            //[self.tableView insertRowsAtIndexPaths:[[NSArray alloc]initWithObjects:[NSIndexPath indexPathForRow:self.accRow inSection:0] , nil]withRowAnimation:NO];
        });
    }
    //搜索结束
    else if(status == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.viewSubLoading animated:YES];
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            if(self.searchResults.count == 0){
                [[iToast makeText:@"No Device on LAN"] show];
            }
        });
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    DetailTableViewCell *cell = nil;
    NSString *id = TableViewCell_Detail;
    cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    
    if (row < self.searchResults.count) {
        LANSearchCamera *result = [self.searchResults objectAtIndex:row];
        cell.labDesc.text = result.ip;
        cell.labTitle.text = result.uid;
        BOOL hasAdded = NO;
        for(BaseCamera *camera in [GBase sharedInstance].cameras){
            if([camera.uid isEqualToString:result.uid]){
                hasAdded = YES;
                break;
            }
        }
        if(hasAdded){
            [cell.labDesc setTextColor:RGB_COLOR(206, 206, 206)];
            [cell.labTitle setTextColor:RGB_COLOR(206, 206, 206)];
        }
        else{
            [cell.labDesc setTextColor:RGB_COLOR(153, 153, 153)];
            [cell.labTitle setTextColor:RGB_COLOR(122, 122, 122)];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* uid = ((LANSearchCamera*)[self.searchResults objectAtIndex:[self.tableView indexPathForSelectedRow].row]).uid;
    for(BaseCamera *camera in [GBase sharedInstance].cameras){
        if([camera.uid isEqualToString:uid]){
            [[iToast makeText:LOCALSTR(@"this camera is in your camera list, please tap other camera.")] show];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
    }
  self.lanSearcher.delegate = nil;
  [self.lanSearcher stopSearch];
  [self performSegueWithIdentifier:@"SearchCamera2SaveCamera" sender:self];
}

//其他界面返回到此界面调用的方法
- (IBAction)SearchCameraViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SearchCamera2SaveCamera"]){
        SaveCameraTableViewController *controller= segue.destinationViewController;
        controller.uid = ((LANSearchCamera*)[self.searchResults objectAtIndex:[self.tableView indexPathForSelectedRow].row]).uid;
    }
}

- (IBAction)searchLan:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [_lanSearcher stopSearch];
    [_lanSearcher beginSearch];
    [self.searchResults removeAllObjects];
    [self.tableView reloadData];
}

- (NSMutableArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _searchResults;
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
