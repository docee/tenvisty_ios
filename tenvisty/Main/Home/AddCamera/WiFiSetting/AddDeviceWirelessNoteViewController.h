//
//  AddDeviceWirelessNoteViewController.h
//  tenvisty
//
//  Created by Tenvis on 17/12/11.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "BaseViewController.h"

@interface AddDeviceWirelessNoteViewController : BaseViewController

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *wifiSsid;
@property (nonatomic,strong) NSString *wifiPassword;
@property (nonatomic,assign) NSInteger wifiAuthMode;
@end
