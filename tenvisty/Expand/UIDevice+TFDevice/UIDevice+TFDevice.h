//
//  UIDevice+TFDevice.h
//  tenvisty
//
//  Created by lu yi on 12/17/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIDevice (TFDevice)
/**
 * @interfaceOrientation 输入要强制转屏的方向
 */
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end

