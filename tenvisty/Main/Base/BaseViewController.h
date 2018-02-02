//
//  BaseViewController.h
//  tenvisty
//
//  Created by Tenvis on 17/12/8.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListImgTableViewCellModel.h"

@interface BaseViewController : UIViewController

@property (nonatomic,strong) BaseCamera *camera;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath;
-(NSString*)getRowValue:(NSInteger)row section:(NSInteger)section;
-(void)setRowValue:(NSString*)val row:(NSInteger)row section:(NSInteger)section;
-(NSIndexPath*)getIndexPath:(ListImgTableViewCellModel*)cellModel;
@end
