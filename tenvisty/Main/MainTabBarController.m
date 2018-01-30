//
//  MainTabBarController.m
//  tenvisty
//
//  Created by Tenvis on 17/11/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *homeboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *homeController = [homeboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    UITabBarItem* item1 = [[UITabBarItem alloc]initWithTitle:LOCALSTR(@"Home") image:[UIImage imageNamed:@"Home"] tag:0];
    homeController.tabBarItem = item1;
    
    UIStoryboard *imageBoard = [UIStoryboard storyboardWithName:@"Image" bundle:nil];
    UINavigationController *imageViewController = [imageBoard instantiateViewControllerWithIdentifier:@"imageViewController"];
    UITabBarItem* item2 = [[UITabBarItem alloc]initWithTitle:LOCALSTR(@"Image") image:[UIImage imageNamed:@"Image"] tag:1];
    imageViewController.tabBarItem = item2;
    
    UIStoryboard *aboutBoard = [UIStoryboard storyboardWithName:@"About" bundle:nil];
    UINavigationController *aboutViewController = [aboutBoard instantiateViewControllerWithIdentifier:@"aboutViewController"];
    UITabBarItem* item3 = [[UITabBarItem alloc]initWithTitle:LOCALSTR(@"About") image:[UIImage imageNamed:@"About"] tag:2];
    aboutViewController.tabBarItem = item3;
    
    NSArray* array = [[NSArray alloc]initWithObjects:homeController,imageViewController,aboutViewController, nil];
    self.viewControllers = array;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
