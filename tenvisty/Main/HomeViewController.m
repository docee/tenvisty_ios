//
//  HomeViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/11/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view ] setBackgroundColor:[UIColor whiteColor]];
   // [self.navBar.maskView setBackgroundColor:Color_Primary];
    [self.navigationBar setBarTintColor:Color_Primary];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
