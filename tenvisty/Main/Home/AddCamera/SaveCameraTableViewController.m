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

@property (strong,nonatomic) NSArray *listItems;
@end

@implementation SaveCameraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"UID") value:self.uid placeHodler:nil maxLength:20 viewId:TableViewCell_TextField_Disable],
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Password") value:nil placeHodler:LOCALSTR(@"Camera Password") maxLength:31 viewId:TableViewCell_TextField_Password],
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Name") value:nil placeHodler:LOCALSTR(@"Camera Name") maxLength:20  viewId:TableViewCell_TextField_Normal],
                        nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}
- (IBAction)saveCamera:(id)sender {
    [self.view endEditing:YES];
    if([self checkData]){
        NSString *nickName = [self getRowValue:2 section:0];
        if(nickName.length == 0){
            nickName = LOCALSTR(@"Camera Name");
        }
        NSString *password =  [self getRowValue:1 section:0];;
        BaseCamera *camera = [[BaseCamera alloc] initWithUid:self.uid Name:nickName UserName:@"admin" Password:password];
        [camera start];
        [GBase addCamera:camera];
        [self.navigationController popToRootViewControllerAnimated:YES];
        //[self performSegueWithIdentifier:@"SaveCamera2CameraList" sender:self];
    }
    
}
-(BOOL)checkData{
    NSString *uid = [self getRowValue:0 section:0];
    NSString *password = [self getRowValue:1 section:0];
    if(uid.length == 0){
        [TwsTools presentAlertMsg:self message:LOCALSTR(@"[UID] is not entered.")];
        return NO;
    }
    uid = [TwsTools readUID:uid];
    for(BaseCamera *camera in [GBase sharedInstance].cameras){
        if([camera.uid isEqualToString:uid]){
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"This camera already exists, please enter another one.")];
            return NO;
        }
    }
    if(uid == nil){
        [TwsTools presentAlertMsg:self message:LOCALSTR(@"Invalid UID")];
        return NO;
    }
    if(password.length == 0){
        [TwsTools presentAlertMsg:self message:LOCALSTR(@"[Password] is not entered.")];
        return NO;
    }
    self.uid = uid;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SaveCamera2ScanQRCode"]){
        
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
