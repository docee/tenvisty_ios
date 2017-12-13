//
//  SaveCameraTableViewController.h
//  tenvisty
//
//  Created by Tenvis on 17/11/30.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "OCScanLifeViewController.h"

@interface SaveCameraTableViewController : BaseTableViewController<OCScanLifeViewControllerDelegate>

@property (nonatomic,strong) NSString *uid;
@end
