//
//  DownloadView.h
//  tenvisty
//
//  Created by Tenvis on 2018/2/13.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadContentView.h"

@interface DownloadView : UIView

@property (nonatomic, weak) IBOutlet DownloadContentView *contentView;
- (void)show;
- (void)dismiss;
-(void)refreshView;
@end
