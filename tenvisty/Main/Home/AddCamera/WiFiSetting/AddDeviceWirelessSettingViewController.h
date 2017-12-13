//
//  AddDeviceWirelessSettingViewController.h
//  tenvisty
//
//  Created by Tenvis on 2017/12/12.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "BaseViewController.h"

@interface AddDeviceWirelessSettingViewController : BaseViewController

@property (nonatomic,strong) NSString *wifiSsid;
@property (nonatomic,strong) NSString *wifiPassword;
@property (nonatomic,assign) NSInteger wifiAuthMode;

@end
