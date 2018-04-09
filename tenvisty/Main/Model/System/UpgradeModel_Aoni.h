//
//  UpgradeModel_Aoni.h
//  tenvisty
//
//  Created by Tenvis on 2018/4/6.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpgradeModel_Aoni : NSObject

@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *version;

- (SMsgAVIoctrlRemoteUpgradeReq *)model;
@end
