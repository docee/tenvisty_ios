//
//  ListImgTableViewCellModel.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ListImgTableViewCellModel.h"

@implementation ListImgTableViewCellModel

+(ListImgTableViewCellModel*) initObj:(NSString *)titleImge title:(NSString *)titleTxt showValue:(BOOL)showV value:(NSString *)value{
    ListImgTableViewCellModel *model = [[ListImgTableViewCellModel alloc] init];
    model.titleImgName = titleImge;
    model.titleText = titleTxt;
    model.showValue = showV;
    model.titleValue = value;
    return model;
}


+(ListImgTableViewCellModel*) initObj:(NSString *)titleImge title:(NSString *)titleTxt showValue:(BOOL)showV value:(NSString *)value viewId:(NSString *)vid{
    ListImgTableViewCellModel *model = [[ListImgTableViewCellModel alloc] init];
    model.titleImgName = titleImge;
    model.titleText = titleTxt;
    model.showValue = showV;
    model.titleValue = value;
    model.viewId = vid;
    return model;
}
+(ListImgTableViewCellModel*) initObj:(NSString *)titleTxt value:(NSString *)value placeHodler:(NSString*)placeHolder maxLength:(NSInteger)maxLength viewId:(NSString *)vid{
    ListImgTableViewCellModel *model = [[ListImgTableViewCellModel alloc] init];
    model.titleText = titleTxt;
    model.textPlaceHolder = placeHolder;
    model.titleValue = value;
    model.viewId = vid;
    model.maxLength = maxLength;
    return model;
}

+(ListImgTableViewCellModel*) initObj:(NSString *)titleTxt value:(NSString *)value placeHodler:(NSString*)placeHolder maxLength:(NSInteger)maxLength filter:(NSString*)filter viewId:(NSString *)vid{
    ListImgTableViewCellModel *model = [[ListImgTableViewCellModel alloc] init];
    model.titleText = titleTxt;
    model.textPlaceHolder = placeHolder;
    model.titleValue = value;
    model.viewId = vid;
    model.maxLength = maxLength;
    model.textFilter = filter;
    return model;
}

+(ListImgTableViewCellModel*) initObj:(NSString *)titleTxt value:(NSString *)value placeHodler:(NSString*)placeHolder maxLength:(NSInteger)maxLength filter:(NSString*)filter autoUppercase:(BOOL)autoUppercase viewId:(NSString *)vid{
    ListImgTableViewCellModel *model = [[ListImgTableViewCellModel alloc] init];
    model.titleText = titleTxt;
    model.textPlaceHolder = placeHolder;
    model.titleValue = value;
    model.viewId = vid;
    model.maxLength = maxLength;
    model.textFilter = filter;
    model.autoUppercase = autoUppercase;
    return model;
}
@end
