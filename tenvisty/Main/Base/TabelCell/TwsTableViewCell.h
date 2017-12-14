//
//  TwsTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 2017/12/14.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwsTableViewCell : UITableViewCell
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* value;
@property (nonatomic,assign) CGFloat valueMarginLeft;
@property (nonatomic,assign) NSTextAlignment valueAligment;
@property (nonatomic,strong) NSString* desc;
@property (nonatomic,strong) NSString* leftImage;
@property (nonatomic,strong) NSString* rightImage;
@property (nonatomic,strong) NSString* placeHolder;
@property (nonatomic,assign) SEL action;
@property (nonatomic,weak) NSObject *actionOwner;

@end
