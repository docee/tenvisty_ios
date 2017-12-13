//
//  CameraListItemTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 17/11/29.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraListItemTableViewCell : UITableViewCell
@property(nonatomic,copy) NSString *uid;

@property (weak, nonatomic) IBOutlet UIImageView *imgCameraSnap;
@property (weak, nonatomic) IBOutlet UILabel *labCameraName;
@property (weak, nonatomic) IBOutlet UIButton *btnModifyCameraName;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlarm;
@property (weak, nonatomic) IBOutlet UILabel *labCameraConnectState;
@property (weak, nonatomic) IBOutlet UIButton *btnCameraEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnCameraSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnCameraDelete;

@end
