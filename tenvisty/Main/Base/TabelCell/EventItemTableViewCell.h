//
//  EventItemTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_eventTypeIcon;
@property (weak, nonatomic) IBOutlet UILabel *labEventDate;
@property (weak, nonatomic) IBOutlet UILabel *labCameraName;
@property (weak, nonatomic) IBOutlet UILabel *labEventTime;
@property (weak, nonatomic) IBOutlet UILabel *labEventType;
@property (weak, nonatomic) IBOutlet UIImageView *imgEventThumb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_centerY_img_eventTypeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_btnSelect;

-(void)setEditMode:(BOOL)edit;
-(void)setDisableMode:(BOOL)disable;
-(void)setModel:(Event*)model;

@end
