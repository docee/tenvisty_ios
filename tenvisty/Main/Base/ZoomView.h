//
//  ZoomView.h
//  tenvisty
//
//  Created by Tenvis on 2018/2/9.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomContentView.h"

@interface ZoomView : UIView
@property (nonatomic,assign) id<ZoomViewDelegate> delegate;
@end
