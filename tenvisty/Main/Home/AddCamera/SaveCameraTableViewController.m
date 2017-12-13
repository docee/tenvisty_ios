//
//  SaveCameraTableViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/11/30.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SaveCameraTableViewController.h"
#import "TextFieldImgTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "PasswordFieldTableViewCell.h"

@interface SaveCameraTableViewController ()

@end

@implementation SaveCameraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)saveCamera:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *id = TableViewCell_TextField_Disable;
    if(indexPath.row == 0){
        TextFieldImgTableViewCell *cell = nil;
        id = TableViewCell_TextField_Img;
        cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
        if(self.uid != nil && ![self.uid isEqualToString:NO_USE_UID]){
            cell.midTextField.text = self.uid;
        }
        cell.leftLabel.text = LOCALSTR(@"Name");
        [cell.rightButton setImage:[UIImage imageNamed:@"btnQRCode"] forState:UIControlStateNormal];
        [cell.rightButton addTarget:self action:@selector(go2ScanQRCode) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(indexPath.row ==1){
        PasswordFieldTableViewCell *cell = nil;
        id =  TableViewCell_TextField_Password;
        cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
        //[cell.midPasswordField becomeFirstResponder];
        return cell;
    }
    else if(indexPath.row == 2){
        TextFieldTableViewCell *cell = nil;
        id = TableViewCell_TextField_Normal;
        cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

-(void)go2ScanQRCode{
    [self performSegueWithIdentifier:@"SaveCamera2ScanQRCode" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SaveCamera2ScanQRCode"]){
        OCScanLifeViewController *controller= segue.destinationViewController;
        controller.hasNoQRCodeBtn = NO;
        controller.delegate = self;
    }
    
}

- (void)scanResult:(NSString *)result{
    if(result){
        if(![result isEqualToString:NO_USE_UID]){
            _uid = result;
            TextFieldImgTableViewCell *cell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            cell.midTextField.text = _uid;
        }
    }
}



- (IBAction)back:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)unwindSegueToViewController:(UIStoryboardSegue *)segue{
    
    NSLog(@"unwindSegueToViewController");
    
}

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{

    NSLog(@"canPerformUnwindSegueAction");
    return YES;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{
    
    NSLog(@"canPerformUnwindSegueAction");
    
    return nil;
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
