//
//  OCScanLifeViewController.h
//  OcTrain
//
//  Created by HXjiang on 16/3/25.
//  Copyright © 2016年 蒋林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OCScanLifeViewControllerDelegate <NSObject>

- (void)scanResult:(NSString * _Nullable )result;

@end

@interface OCScanLifeViewController : UIViewController

@property (nonnull, retain) id<OCScanLifeViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL hasNoQRCodeBtn;
@property (nonatomic,assign) NSInteger fromType;

@end
