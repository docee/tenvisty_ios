//
//  AppDelegate.m
//  tenvisty
//
//  Created by Tenvis on 17/11/2.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "AppDelegate.h"
#import "XGPush.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate,XGPushDelegate>{
    BOOL isEnterBackground;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[XGPush defaultManager] startXGWithAppID:2200274193 appKey:@"IX15RLJ3U94V" delegate:self];
    //[[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
    // Override point for customization after application launch.
    NSLog(@"%@ %s %d",[self class],__func__,__LINE__);
    NSLog(@"%@",[NSString stringWithFormat:@"IOTCAPIs %@", [Camera getIOTCAPIsVerion]]);
    NSLog(@"%@",[NSString stringWithFormat:@"AVAPIs %@", [Camera getAVAPIsVersion]]);
    [MyCamera initIOTC];
    [GBase initCameras];
    [self.window makeKeyAndVisible];
    
    
    [NSThread sleepForTimeInterval:[GBase sharedInstance].cameras.count == 0 ? 2.0:1.0];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    isEnterBackground = YES;
    for(MyCamera *camera in [GBase sharedInstance].cameras){
        [camera stop];
        //camera.delegate2 = nil;
    }
    [MyCamera uninitIOTC];
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //isEnterBackground = NO;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        for(MyCamera *camera in [GBase sharedInstance].cameras){
//            [camera start];
//            //camera.delegate2 = nil;
//        }
//    });
    isEnterBackground = NO;
     [MyCamera initIOTC];
     for(MyCamera *camera in [GBase sharedInstance].cameras){
        [camera start];
            //camera.delegate2 = nil;
     }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    isEnterBackground = NO;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


-(void)checkAlarmEvent:(NSDictionary*) dic {
    
    if (dic == nil) {
        return;
    }
    
    NSString *responseString = (NSString*)[dic objectForKey:@"tws"];
    NSLog(@"checkAlarmEvent:%@",responseString);
    
    if (responseString == nil) {
        NSLog(@"return:%@",responseString);
        
        return;
    }
    
    NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        
        NSLog(@"Dersialized JSON Dictionary = %@ %ld", dictionary[@"uid"], (long)[dictionary[@"type"] integerValue]);
        
        NSString *uid =[dictionary objectForKey:@"uid"];
        //NSInteger type =[[dictionary objectForKey:@"type"]integerValue];
        
        NSString* dictime =[dictionary objectForKey:@"time"];
        NSInteger time = 0;
        if (dictime!=nil) {
            time = [dictime integerValue];
        }
        if (time <=0) {
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            time = [dat timeIntervalSince1970];
        }
        NSLog(@"time:%ld",(long)time);
        BOOL isNotExist = YES;
        for (MyCamera *cam in [GBase sharedInstance].cameras) {
            // [HXProgress showText:cam.uid];
            if ([cam.uid isEqualToString:uid]) {
                isNotExist = NO;
                if(cam.remoteNotifications > 0){
                    [cam setRemoteNotification:1 EventTime:[[NSDate date] timeIntervalSince1970]];
                }
                else{
                    [cam closePush:nil];
                }
                
            }//@isEqualToString
            
        }// @for
        if(isNotExist){
            MyCamera *cam = [[MyCamera alloc] initWithUid:uid Name:@"camera name" UserName:@"admin" Password:@"admin"];
            [cam closePush:nil];
        }
        
    }// @jsonObject
    
}

-(void)checkAlarmEventByUID:(NSString*) uid {
    if(uid && uid.length == 20){
        BOOL isNotExist = YES;
        for (MyCamera *cam in [GBase sharedInstance].cameras) {
            // [HXProgress showText:cam.uid];
            if ([cam.uid isEqualToString:uid]) {
                isNotExist = NO;
                if(cam.remoteNotifications > 0){
                    [cam setRemoteNotification:1 EventTime:[[NSDate date] timeIntervalSince1970]];
                }
                else{
                    [cam closePush:nil];
                }
                
            }//@isEqualToString
            
        }// @for
        if(isNotExist){
            MyCamera *cam = [[MyCamera alloc] initWithUid:uid Name:@"camera name" UserName:@"admin" Password:@"admin"];
            [cam closePush:nil];
        }
    }
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"tenvisty"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotate
{
    return true;
}



// 此方法是必须要有实现，否则SDK将无法处理应用注册的Token，推送也就不会成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //    [[XGPushTokenManager defaultManager] registerDeviceToken:deviceToken]; // 此方法可以不需要调用，SDK已经在内部处理
    NSString *token =  [[XGPushTokenManager defaultTokenManager] deviceTokenString];
    NSLog(@"[XGDemo] device token is %@", token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"push_deviceToken"];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}


/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    [self checkAlarmEvent:userInfo];
}


/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //[[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self checkAlarmEvent:userInfo];
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    //[[XGPush defaultManager] reportXGNotificationInfo:response.notification.request.content.userInfo];
    
    completionHandler();
    [self checkAlarmEventByUID:response.notification.request.content.title];
}

// App 在前台弹通知需要调用这个接口
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //[[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    [self checkAlarmEventByUID:notification.request.content.title];
    
}
#endif

@end






