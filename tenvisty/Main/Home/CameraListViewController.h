//
//  CameraListViewController.h
//  tenvisty
//
//  Created by Tenvis on 17/11/29.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFragmentViewController.h"

@interface CameraListViewController : BaseFragmentViewController<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
