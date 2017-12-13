//
//  ListImgTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListImgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightLabLoading;
@property (weak, nonatomic) IBOutlet UILabel *rightLabValue;
-(void) setLeftImage:(NSString*)imageName;
@end
