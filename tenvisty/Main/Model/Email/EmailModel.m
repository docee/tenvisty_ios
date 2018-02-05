//
//  EmailModel.m
//  Visia
//
//  Created by Tenvis on 16/10/11.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmailModel.h"

@implementation EmailModel

- (id)initWithData:(NSString *)domain smtpServer:(NSString*)smtpServer port:(unsigned int)port encryptType:(int)encryptType{
    self.domain = domain;
    self.smtpServer = smtpServer;
    self.port = port;
    self.encryptType= encryptType;
    return self;
}
@end