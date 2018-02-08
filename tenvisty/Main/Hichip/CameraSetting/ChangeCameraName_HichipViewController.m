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

@property (strong,nonatomic) NSArray *listItems;
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



-(NSArray *)listItems{
    if(!_listItems){
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         [ListImgTableViewCellModel initObj:LOCALSTR(@"Name") value:self.camera.nickName placeHodler:LOCALSTR(@"Camera Name")  maxLength:20 viewId:TableViewCell_TextField_Normal],
                         nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}

- (IBAction)save:(id)sender {
    [self.view endEditing:YES];
    NSString *nickName = [self getRowValue:0 section:0];
    // 用于过滤空格和Tab换行符
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    nickName = [nickName stringByTrimmingCharactersInSet:characterSet];
    if(nickName.length == 0){
        nickName = LOCALSTR(@"Camera Name");
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
