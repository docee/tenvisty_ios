//
//  ListImgTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListImgTableViewCell : UITableViewCell
-(void) setLeftImage:(NSString*)imageName;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *value;
@property (nonatomic,assign) BOOL showValue;
@end
