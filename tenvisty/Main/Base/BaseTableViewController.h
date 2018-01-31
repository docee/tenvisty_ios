//
//  BaseTableViewController.h
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordFieldTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "TextFieldImgTableViewCell.h"
#import "TextFieldDisableTableViewCell.h"
#import "DetailTableViewCell.h"
#import "ListImgTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "SelectItemTableViewCell.h"
#import "MutilTextFieldTableViewCell.h"
#import "ListImgTableViewCellModel.h"

@interface BaseTableViewController : UITableViewController<UITableViewDelegate>

@property (nonatomic,weak) BaseCamera *camera;

-(TwsTableViewCell*) getRowCell:(NSInteger)row;
@end
