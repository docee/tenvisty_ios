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
@property (nonatomic,copy) NSString *loadingText;
@property (nonatomic,copy) NSString *titleValue;
@property (nonatomic,copy) NSString *viewId;

+(ListImgTableViewCellModel*) initObj:(NSString *)titleImge title:(NSString *)titleTxt loadingTxt:(NSString *)loadingTxt value:(NSString *)value;


+(ListImgTableViewCellModel*) initObj:(NSString *)titleImge title:(NSString *)titleTxt loadingTxt:(NSString *)loadingTxt value:(NSString *)value viewId:(NSString *)vid;
@end
