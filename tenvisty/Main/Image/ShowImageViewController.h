//
//  ShowImageViewController.h
//  tenvisty
//
//  Created by Tenvis on 17/12/7.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "BaseViewController.h"
#import "LocalPictureInfo.h"

@interface ShowImageViewController : BaseViewController

@property (nonatomic,strong) LocalPictureInfo *selectPic;
@property (nonatomic, strong) NSMutableArray *images;
@end
