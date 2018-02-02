//
//  TwsTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 2017/12/14.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListImgTableViewCellModel.h"

@interface TwsTableViewCell : UITableViewCell<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong,readonly) NSString* title;
@property (nonatomic,strong,readonly) NSString* value;
@property (nonatomic,assign,readonly) CGFloat valueMarginLeft;
@property (nonatomic,assign,readonly) NSTextAlignment valueAligment;
@property (nonatomic,strong) NSString* desc;
@property (nonatomic,strong,readonly) NSString* leftImage;
@property (nonatomic,strong) NSString* rightImage;
@property (nonatomic,strong,readonly) NSString* placeHolder;
@property (nonatomic,assign) SEL action;
@property (nonatomic,weak) NSObject *actionOwner;
@property (nonatomic,assign) NSInteger maxLength;
@property (nonatomic,strong) NSString* textFilter;
@property (nonatomic,assign) BOOL autoUppercase;
@property (nonatomic,assign) BOOL showValue;
@property (nonatomic,strong) ListImgTableViewCellModel *cellModel;

-(void)resignFirstResponder;
-(void)textFieldDidChange:(UITextField *)textField;
-(void)refreshCell;
@end
