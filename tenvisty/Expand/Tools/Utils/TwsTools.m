//
//  TwsTools.m
//  tenvisty
//
//  Created by Tenvis on 17/12/8.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TwsTools.h"

@implementation TwsTools

+(NSString*)readUID:(NSString*)source{
    if([source length] > 20){
        source = [[source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    }
    if(![NO_USE_UID isEqualToString:source]){
        if([source length] != 20){
            return nil;
        }
        else{
            return source;
        }
    }
    else{
        return NO_USE_UID;
    }
}


+ (void)presentAlertTitle:(UIViewController*)owner title:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock textColor:(UIColor*)color startPos:(NSInteger)start length:(NSInteger)length{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:style];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(start,length)];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    if(cancelTitle){
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            cancelBlock();
        }];
        [alertController addAction:actionNO];
    }
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        defaultBlock();
    }];
    
    //    [actionNO setValue:LightBlueColor forKey:@"_titleTextColor"];
    //    [actionOk setValue:LightBlueColor forKey:@"_titleTextColor"];
    
    [alertController addAction:actionOk];
    
    [owner presentViewController:alertController animated:YES completion:^{
        
    }];
}

+ (void)presentAlertTitle:(UIViewController*)owner title:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    if(cancelTitle){
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if(cancelBlock != nil){
                cancelBlock();
            }
        }];
        [alertController addAction:actionNO];
    }
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(defaultBlock != nil){
            defaultBlock();
        }
    }];
    
    //    [actionNO setValue:LightBlueColor forKey:@"_titleTextColor"];
    //    [actionOk setValue:LightBlueColor forKey:@"_titleTextColor"];
    
    [alertController addAction:actionOk];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [owner presentViewController:alertController animated:YES completion:NULL];
    });
}

+ (void)presentAlertTitle:(UIViewController*)owner title:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock defaultActionStyle:(UIAlertActionStyle)actionstyle actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    if(cancelTitle){
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if(cancelBlock != nil){
                cancelBlock();
            }
        }];
        [alertController addAction:actionNO];
    }
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:defaultTitle style:actionstyle handler:^(UIAlertAction * _Nonnull action) {
        if(defaultBlock != nil){
            defaultBlock();
        }
    }];
    
    //    [actionNO setValue:LightBlueColor forKey:@"_titleTextColor"];
    //    [actionOk setValue:LightBlueColor forKey:@"_titleTextColor"];
    
    [alertController addAction:actionOk];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [owner presentViewController:alertController animated:YES completion:NULL];
    });
}


+ (void)presentAlertMsg:(UIViewController*)owner message:(NSString *)message  {
    
    [self presentAlertTitle:owner title:nil message:message alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:nil actionCancelTitle:nil actionCancelBlock:nil];
}
+ (void)presentAlertMsg:(UIViewController*)owner message:(NSString *)message actionDefaultBlock:(void (^)(void))defaultBlock  {
    
    [self presentAlertTitle:owner title:nil message:message alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:defaultBlock actionCancelTitle:nil actionCancelBlock:nil];
}

+(void)goPhoneSettingPage:(NSString *)root{
    [self openScheme:root];
}

+(void)openScheme:(NSString *)scheme{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //if([[UIApplication sharedApplication] canOpenURL:URL]) {
    //URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //}
    if([app respondsToSelector:@selector(openURL:options:completionHandler:)]){
        [app openURL:URL options:@{} completionHandler:^(BOOL success){
            NSLog(@"Open %@: %d",scheme,success);
        }];
    }else {
        BOOL success = [app openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}

+ (void)presentMessage:(NSString *)message atDeviceOrientation:(DeviceOrientation)orientation {
    
    if (orientation == DeviceOrientationPortrait) {
        [[[iToast makeText:message]setDuration:1] show];
    }
    
    if (orientation == DeviceOrientationLandscapeLeft) {
        [[[iToast makeText:message] setDuration:1] showRota];
    }
    
    if (orientation == DeviceOrientationLandscapeRight) {
        [[[iToast makeText:message] setDuration:1] showUnRota];
    }
}

+ (BOOL)checkPasswordFormat:(NSString*)pwd{
    if(pwd!=nil){
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"[0-9A-Za-z\\.@_~!$%^(),|/\\*\\-]{6,12}" options:NSRegularExpressionCaseInsensitive error:nil];
        if([regular numberOfMatchesInString:pwd options:0 range:NSMakeRange(0, pwd.length)] > 0){
            regular = [[NSRegularExpression alloc] initWithPattern:@"^[0-9]{6,12}$" options:NSRegularExpressionCaseInsensitive error:nil];
            if([regular numberOfMatchesInString:pwd options:0 range:NSMakeRange(0, pwd.length)] == 0){
                regular = [[NSRegularExpression alloc] initWithPattern:@"^[A-Z]{6,12}$" options:NSRegularExpressionCaseInsensitive error:nil];
                if([regular numberOfMatchesInString:pwd options:0 range:NSMakeRange(0, pwd.length)] == 0){
                    regular = [[NSRegularExpression alloc] initWithPattern:@"^[a-z]{6,12}$" options:NSRegularExpressionCaseInsensitive error:nil];
                    if([regular numberOfMatchesInString:pwd options:0 range:NSMakeRange(0, pwd.length)] == 0){
                        regular = [[NSRegularExpression alloc] initWithPattern:@"^[\\.@_~!$%^(),|\\*/\\-]{6,12}$" options:NSRegularExpressionCaseInsensitive error:nil];
                        if([regular numberOfMatchesInString:pwd options:0 range:NSMakeRange(0, pwd.length)] == 0){
                            return YES;
                        }
                    }
                }
            }
        }
    }
    return NO;
}
@end
