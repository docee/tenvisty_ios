//
//  UpgradeModel_Aoni.m
//  tenvisty
//
//  Created by Tenvis on 2018/4/6.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "UpgradeModel_Aoni.h"

@implementation UpgradeModel_Aoni

- (SMsgAVIoctrlRemoteUpgradeReq *)model{
    SMsgAVIoctrlRemoteUpgradeReq *m = malloc(sizeof(SMsgAVIoctrlRemoteUpgradeReq));
    memset(m, 0, sizeof(SMsgAVIoctrlRemoteUpgradeReq));
    memcpy(m->new_version, [self.version UTF8String], self.version.length);
    memcpy(m->url_parth, [self.url UTF8String], self.url.length);
    return m;
}

@end
