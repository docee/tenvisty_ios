//
//  SelectItemTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
-(void) setLeftImage:(NSString*)imageName;
-(void) setSelect:(Boolean)selected;
@end
