//
//  TextFieldDisableTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldDisableTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_left_rightTextField;

-(void) setLeftImage:(NSString*)imageName;
@end
