//
//  LANSearchDevice.h
//  tenvisty
//
//  Created by Tenvis on 2018/1/22.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LANSearchCamera : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic,assign) NSInteger port;
@end
