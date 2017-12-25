//
//  PlaybackViewController.h
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "BaseViewController.h"
#import "Event.h"

@interface PlaybackViewController : BaseViewController

@property (nonatomic,strong) Event *evt;

@property (nonatomic,assign) BOOL needCreateSnapshot;
@end
