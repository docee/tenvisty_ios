//
//  BaseViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/8.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "BaseViewController.h"
#import "TwsTableViewCell.h"
#import "ListImgTableViewCellModel.h"

@interface BaseViewController ()<BaseCameraDelegate,CellModelDelegate>
@property (nonatomic,strong) UIButton *doneButton;
@property (strong,nonatomic) NSArray *listItems;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.camera.cameraDelegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.camera.cameraDelegate = nil;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)self.listItems[section]).count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    TwsTableViewCell *cell = nil;
    ListImgTableViewCellModel *model  = [[self.listItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:model.viewId forIndexPath:indexPath];
    cell.cellModel = model;
    model.delegate = self;
    return cell;
}

-(NSString*)getRowValue:(NSInteger)row section:(NSInteger)section{
    NSString *v = ((ListImgTableViewCellModel*)self.listItems[section][row]).titleValue;
    if(v == nil){
        v = @"";
    }
    return v;
}
-(void)setRowValue:(NSString*)val row:(NSInteger)row section:(NSInteger)section{
    ((ListImgTableViewCellModel*)self.listItems[section][row]).titleValue = val;
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
//-(void) keyboardWillChangeFrame: (NSNotification *)notification
//{
//    self.doneButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
//    self.doneButton.frame = CGRectMake(0, 228, 70, 35);
//    [self.doneButton setTitle:@"完成编辑" forState: UIControlStateNormal];
//    [self.doneButton addTarget: self action:@selector(hideKeyboard) forControlEvents: UIControlEventTouchUpInside];
//
//    [self.view addSubview:self.doneButton];
//}

-(void) hideKeyboard
{
    [self.doneButton removeFromSuperview];
    //[myTextView resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
@end
