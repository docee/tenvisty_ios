//
//  PasswordFieldTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *midPasswordField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_left_midPasswordField;


-(void) setLeftImage:(NSString*)imageName;
@end
