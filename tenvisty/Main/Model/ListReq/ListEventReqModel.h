//
//  ListEventReqModel.h
//  tenvisty
//
//  Created by Tenvis on 2018/3/30.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListEventReqModel : NSObject
@property (nonatomic,assign) int year;
@property (nonatomic,assign) int month;
@property (nonatomic,assign) int day;
@property (nonatomic,assign) int type;

-(SMsgAVIoctrlListEventReq_Ausdom*)model;
@end
