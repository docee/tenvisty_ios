//
//  TwsTools.h
//  tenvisty
//
//  Created by Tenvis on 17/12/8.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceOrientation) {
    DeviceOrientationUnknown,
    DeviceOrientationPortrait,
    DeviceOrientationLandscapeLeft,
    DeviceOrientationLandscapeRight
};

@interface TwsTools : NSObject

+(NSString*)readUID:(NSString*)source;
+(void)goPhoneSettingPage:(NSString *)root;

+ (void)presentAlertMsg:(UIViewController*)owner message:(NSString *)message;
+ (void)presentAlertMsg:(UIViewController*)owner message:(NSString *)message actionDefaultBlock:(void (^)(void))defaultBlock;

+ (void)presentAlertTitle:(UIViewController*)owner title:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock textColor:(UIColor*)color startPos:(NSInteger)start length:(NSInteger)length;



+ (void)presentAlertTitle:(UIViewController*)owner title:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock;

+ (void)presentAlertTitle:(UIViewController*)owner title:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock defaultActionStyle:(UIAlertActionStyle)actionstyle actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock;

+ (void)presentMessage:(NSString *)message atDeviceOrientation:(DeviceOrientation)orientation;
+ (BOOL)checkPasswordFormat:(NSString*)pwd;
@end
