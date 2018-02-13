//
//  DownloadContentView.h
//  tenvisty
//
//  Created by Tenvis on 2018/2/13.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#define DOWNLOAD_BTN_CANCEL 0

#import <UIKit/UIKit.h>

@protocol DownloadViewDelegate;

@interface DownloadContentView : UIView

@property (nonatomic,assign) id<DownloadViewDelegate> delegate;

-(void)setPercent:(int)per;
-(void)setAccFile:(int)index total:(int)total desc:(NSString*)desc;

@end

@protocol DownloadViewDelegate <NSObject>
@optional
- (void)DownloadContentView:(DownloadContentView *)view didClickButton:(UIButton*)btn type:(NSInteger)type;
@end
