//
//  EmailModel.h
//  Visia
//
//  Created by Tenvis on 16/10/11.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#ifndef EmailModel_h
#define EmailModel_h


#endif /* EmailModel_h */
#define ENCTYPE_NONE 0
#define ENCTYPE_SSL 1
#define ENCTYPE_TLS 2
#define ENCTYPE_STARTTLS 3

@interface EmailModel : NSObject{
    NSString *domain;
    NSString *smtpServer;
    int port;
    int encryptType;
}
@property (nonatomic, assign) unsigned int port;
@property (nonatomic, assign) unsigned int encryptType;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *smtpServer;

- (id)initWithData:(NSString *)domain smtpServer:(NSString*)smtpServer port:(unsigned int)port encryptType:(int)encryptType;
@end