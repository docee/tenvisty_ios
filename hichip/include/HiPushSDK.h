//
//  HiPushSDK.h
//  HiP2PSDK
//
//  Created by zhao qi on 16/7/19.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PUSH_TYPE_BIND 0
#define PUSH_TYPE_UNBIND 1

#define PUSH_RESULT_SUCCESS 0
#define PUSH_RESULT_FAIL -1
#define PUSH_RESULT_NULL_TOKEN -2




@protocol OnPushResult <NSObject>
@optional
- (void)pushBindResult:(int)subID Type:(int)type Result:(int)result;
@end




@interface HiPushSDK : NSObject
{
    id<OnPushResult> delegate;
}

@property (nonatomic, assign) id<OnPushResult> delegate;


-(id) initWithXGToken:(NSString*) xingeToken Uid:(NSString*)cameraUid Company:(NSString*)company Delegate:(id<OnPushResult>)delegate;

// 新增接口，抛出推送服务器地址参数设置
-(id) initWithXGToken:(NSString*) xingeToken Uid:(NSString*)cameraUid Company:(NSString*)comp Delegate:(id<OnPushResult>)del pushServerAddress:(NSString *)pushserverAddress;
- (void)setAlarmPushServerIPAddress:(NSString *)ipaddress;

-(void) bind;
-(void) unbind;
-(void) unbindWithSubID:(int)subid;
-(NSString *)getPushServer;
@end
