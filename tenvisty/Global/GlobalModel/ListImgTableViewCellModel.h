//
//  ListImgTableViewCellModel.h
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListImgTableViewCellModel : NSObject
@property (nonatomic,copy) NSString *titleImgName;
@property (nonatomic,copy) NSString *titleText;
@property (nonatomic,copy) NSString *titleValue;
@property (nonatomic,copy) NSString *viewId;
@property (nonatomic,copy) NSString *textPlaceHolder;
@property (nonatomic,assign) BOOL showValue;
@property (nonatomic,assign) NSInteger maxLength;
@property (nonatomic,copy) NSString *textFilter;
@property (nonatomic,assign) BOOL autoUppercase;


+(ListImgTableViewCellModel*) initObj:(NSString *)titleImge title:(NSString *)titleTxt showValue:(BOOL)showV value:(NSString *)value;


+(ListImgTableViewCellModel*) initObj:(NSString *)titleImge title:(NSString *)titleTxt showValue:(BOOL)showV value:(NSString *)value viewId:(NSString *)vid;

+(ListImgTableViewCellModel*) initObj:(NSString *)titleTxt value:(NSString *)value placeHodler:(NSString*)placeHolder maxLength:(NSInteger)maxLength viewId:(NSString *)vid;

+(ListImgTableViewCellModel*) initObj:(NSString *)titleTxt value:(NSString *)value placeHodler:(NSString*)placeHolder maxLength:(NSInteger)maxLength filter:(NSString*)filter viewId:(NSString *)vid;
+(ListImgTableViewCellModel*) initObj:(NSString *)titleTxt value:(NSString *)value placeHodler:(NSString*)placeHolder maxLength:(NSInteger)maxLength filter:(NSString*)filter autoUppercase:(BOOL)autoUppercase viewId:(NSString *)vid;
@end
