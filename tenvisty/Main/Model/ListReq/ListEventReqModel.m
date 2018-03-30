//
//  ListEventReqModel.m
//  tenvisty
//
//  Created by Tenvis on 2018/3/30.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "ListEventReqModel.h"

@implementation ListEventReqModel

-(SMsgAVIoctrlListEventReq_Ausdom*)model{
    SMsgAVIoctrlListEventReq_Ausdom *req = (SMsgAVIoctrlListEventReq_Ausdom *) malloc(sizeof(SMsgAVIoctrlListEventReq_Ausdom));
    memset(req, 0, sizeof(SMsgAVIoctrlListEventReq_Ausdom));
    req->day = self.day;
    req->month = self.month;
    req->year = self.year;
    req->type = self.type;
    return req;
}

@end
