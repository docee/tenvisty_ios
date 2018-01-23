//
//  AppDelegate.m
//  tenvisty
//
//  Created by Tenvis on 17/11/2.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "AppDelegate.h"
#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#import "MyCamera.h"
#import "HiChipSDK.h"
const uint8_t ff_h264_cabac_tables[512 + 4*2*64 + 4*64 + 63] = {
    9,8,7,7,6,6,6,6,5,5,5,5,5,5,5,5,
    4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
    3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
    3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    // LPS range
    -128,    -128,    -128,    -128,    -128,    -128,    123,     123,
    116,     116,     111,     111,     105,     105,     100,     100,
    95,      95,      90,      90,      85,      85,      81,      81,
    77,      77,      73,      73,      69,      69,      66,      66,
    62,      62,      59,      59,      56,      56,      53,      53,
    51,      51,      48,      48,      46,      46,      43,      43,
    41,      41,      39,      39,      37,      37,      35,      35,
    33,      33,      32,      32,      30,      30,      29,      29,
    27,      27,      26,      26,      24,      24,      23,      23,
    22,      22,      21,      21,      20,      20,      19,      19,
    18,      18,      17,      17,      16,      16,      15,      15,
    14,      14,      14,      14,      13,      13,      12,      12,
    12,      12,      11,      11,      11,      11,      10,      10,
    10,      10,      9,       9,       9,       9,       8,       8,
    8,       8,       7,       7,       7,       7,       7,       7,
    6,       6,       6,       6,       6,       6,       2,       2,
    -80,     -80,     -89,     -89,     -98,     -98,     -106,    -106,
    -114,    -114,    -121,    -121,    -128,    -128,    122,     122,
    116,     116,     110,     110,     104,     104,     99,      99,
    94,      94,      89,      89,      85,      85,      80,      80,
    76,      76,      72,      72,      69,      69,      65,      65,
    62,      62,      59,      59,      56,      56,      53,      53,
    50,      50,      48,      48,      45,      45,      43,      43,
    41,      41,      39,      39,      37,      37,      35,      35,
    33,      33,      31,      31,      30,      30,      28,      28,
    27,      27,      26,      26,      24,      24,      23,      23,
    22,      22,      21,      21,      20,      20,      19,      19,
    18,      18,      17,      17,      16,      16,      15,      15,
    14,      14,      14,      14,      13,      13,      12,      12,
    12,      12,      11,      11,      11,      11,      10,      10,
    9,       9,       9,       9,       9,       9,       8,       8,
    8,       8,       7,       7,       7,       7,       2,       2,
    -48,     -48,     -59,     -59,     -69,     -69,     -78,     -78,
    -87,     -87,     -96,     -96,     -104,    -104,    -112,    -112,
    -119,    -119,    -126,    -126,    123,     123,     117,     117,
    111,     111,     105,     105,     100,     100,     95,      95,
    90,      90,      86,      86,      81,      81,      77,      77,
    73,      73,      69,      69,      66,      66,      63,      63,
    59,      59,      56,      56,      54,      54,      51,      51,
    48,      48,      46,      46,      43,      43,      41,      41,
    39,      39,      37,      37,      35,      35,      33,      33,
    32,      32,      30,      30,      29,      29,      27,      27,
    26,      26,      25,      25,      23,      23,      22,      22,
    21,      21,      20,      20,      19,      19,      18,      18,
    17,      17,      16,      16,      15,      15,      15,      15,
    14,      14,      13,      13,      12,      12,      12,      12,
    11,      11,      11,      11,      10,      10,      10,      10,
    9,       9,       9,       9,       8,       8,       2,       2,
    -16,     -16,     -29,     -29,     -40,     -40,     -51,     -51,
    -61,     -61,     -71,     -71,     -81,     -81,     -90,     -90,
    -98,     -98,     -106,    -106,    -114,    -114,    -121,    -121,
    -128,    -128,    122,     122,     116,     116,     110,     110,
    104,     104,     99,      99,      94,      94,      89,      89,
    85,      85,      80,      80,      76,      76,      72,      72,
    69,      69,      65,      65,      62,      62,      59,      59,
    56,      56,      53,      53,      50,      50,      48,      48,
    45,      45,      43,      43,      41,      41,      39,      39,
    37,      37,      35,      35,      33,      33,      31,      31,
    30,      30,      28,      28,      27,      27,      25,      25,
    24,      24,      23,      23,      22,      22,      21,      21,
    20,      20,      19,      19,      18,      18,      17,      17,
    16,      16,      15,      15,      14,      14,      14,      14,
    13,      13,      12,      12,      12,      12,      11,      11,
    11,      11,      10,      10,      9,       9,       2,       2,
    // mlps state
    127,     126,     77,      76,      77,      76,      75,      74,
    75,      74,      75,      74,      73,      72,      73,      72,
    73,      72,      71,      70,      71,      70,      71,      70,
    69,      68,      69,      68,      67,      66,      67,      66,
    67,      66,      65,      64,      65,      64,      63,      62,
    61,      60,      61,      60,      61,      60,      59,      58,
    59,      58,      57,      56,      55,      54,      55,      54,
    53,      52,      53,      52,      51,      50,      49,      48,
    49,      48,      47,      46,      45,      44,      45,      44,
    43,      42,      43,      42,      39,      38,      39,      38,
    37,      36,      37,      36,      33,      32,      33,      32,
    31,      30,      31,      30,      27,      26,      27,      26,
    25,      24,      23,      22,      23,      22,      19,      18,
    19,      18,      17,      16,      15,      14,      13,      12,
    11,      10,      9,       8,       9,       8,       5,       4,
    5,       4,       3,       2,       1,       0,       0,       1,
    2,       3,       4,       5,       6,       7,       8,       9,
    10,      11,      12,      13,      14,      15,      16,      17,
    18,      19,      20,      21,      22,      23,      24,      25,
    26,      27,      28,      29,      30,      31,      32,      33,
    34,      35,      36,      37,      38,      39,      40,      41,
    42,      43,      44,      45,      46,      47,      48,      49,
    50,      51,      52,      53,      54,      55,      56,      57,
    58,      59,      60,      61,      62,      63,      64,      65,
    66,      67,      68,      69,      70,      71,      72,      73,
    74,      75,      76,      77,      78,      79,      80,      81,
    82,      83,      84,      85,      86,      87,      88,      89,
    90,      91,      92,      93,      94,      95,      96,      97,
    98,      99,      100,     101,     102,     103,     104,     105,
    106,     107,     108,     109,     110,     111,     112,     113,
    114,     115,     116,     117,     118,     119,     120,     121,
    122,     123,     124,     125,     124,     125,     126,     127,
    // last_coeff_flag_offset_8x8
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4,
    5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8
};
@interface AppDelegate ()<UNUserNotificationCenterDelegate,HiChipInitCallback>{
    BOOL isEnterBackground;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    // 保证app运行期间不锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    NSLog(@"%@ %s %d",[self class],__func__,__LINE__);
    NSLog(@"%@",[NSString stringWithFormat:@"IOTCAPIs %@", [Camera getIOTCAPIsVerion]]);
    NSLog(@"%@",[NSString stringWithFormat:@"AVAPIs %@", [Camera getAVAPIsVersion]]);
    [self registerUMPush:launchOptions];
    // 处理远程通知信息
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self checkAlarmEvent:userInfo];
    }
    [MyCamera initIOTC];
    [HiChipSDK init];
    [GBase initCameras];
    [self.window makeKeyAndVisible];
    
    
   // [NSThread sleepForTimeInterval:[GBase sharedInstance].cameras.count == 0 ? 2.0:1.0];
    
    return YES;
}
#pragma mark - HiChipInitCallback
- (void)onInitResult:(int)result {
    
    LOG(@"onInitResult :%d", result)
    
}

-(void)registerUMPush:(NSDictionary *)launchOptions{
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:@"5a45c144b27b0a10ed000155" launchOptions:launchOptions httpsEnable:YES ];
    [UMessage openDebugMode:NO];
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [UMessage addLaunchMessageWithWindow:self.window finishViewController:[board instantiateInitialViewController]];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    
    //    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    //    if (([[[UIDevice currentDevice] systemVersion]intValue]>=8)&&([[[UIDevice currentDevice] systemVersion]intValue]<10)) {
    //        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    //        action1.identifier = @"action1_identifier";
    //        action1.title=@"打开应用";
    //        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    //
    //        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    //        action2.identifier = @"action2_identifier";
    //        action2.title=@"忽略";
    //        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    //        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    //        action2.destructive = YES;
    //        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    //        actionCategory1.identifier = @"category1";//这组动作的唯一标示
    //        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    //        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    //        [UMessage registerForRemoteNotifications:categories];
    //    }
    //
    //
    //    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    //    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
    //        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
    //        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
    //
    //        //UNNotificationCategoryOptionNone
    //        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
    //        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
    //        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    //        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
    //        [center setNotificationCategories:categories_ios10];
    //    }
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    //UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    //UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    //[UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    //for log
    // [UMessage setAutoAlert:NO];
    
    //[UMessage setLogEnabled:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    isEnterBackground = YES;
    for(BaseCamera *camera in [GBase sharedInstance].cameras){
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
     for(BaseCamera *camera in [GBase sharedInstance].cameras){
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
    
    id jsonObject = [dic objectForKey:@"eventData"];
    NSLog(@"checkAlarmEvent:%@",jsonObject);
    
    if (jsonObject == nil) {
        NSLog(@"return:%@",jsonObject);
        
        return;
    }
    
//    NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSError *error = nil;
//
//
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
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
        for (BaseCamera *cam in [GBase sharedInstance].cameras) {
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
            BaseCamera *cam = [[BaseCamera alloc] initWithUid:uid Name:@"camera name" UserName:@"admin" Password:@"admin"];
            [cam closePush:nil];
        }
        
    }// @jsonObject
    
}

-(void)checkAlarmEventByUID:(NSString*) uid {
    if(uid && uid.length == 20){
        BOOL isNotExist = YES;
        for (BaseCamera *cam in [GBase sharedInstance].cameras) {
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
            BaseCamera *cam = [[BaseCamera alloc] initWithUid:uid Name:@"camera name" UserName:@"admin" Password:@"admin"];
            [cam closePush:nil];
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    // [UMessage registerDeviceToken:deviceToken];
    NSString *token = [self stringDevicetoken:deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"push_deviceToken"];
    //[[iToast makeText:token] show];
    NSLog(@"%@",token);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
    
    [self checkAlarmEvent:userInfo];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    
}

-(NSString *)stringDevicetoken:(NSData *)deviceToken
{
    NSString *token=[deviceToken description];
    NSString *pushToken=[[[token stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">"withString:@""] stringByReplacingOccurrencesOfString:@" "withString:@""];
    return pushToken;
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [self checkAlarmEvent:userInfo];
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    BaseCamera *camera = nil;
    for (BaseCamera *c in [GBase sharedInstance].cameras) {
        if([c.uid isEqualToString:(NSString*)[[userInfo objectForKey:@"eventData"] objectForKey:@"uid"]]){
            camera = c;
            break;
        }
    }
    if(camera != nil && !camera.isPlaying){
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    }
    else{
        completionHandler(0);
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self checkAlarmEvent:userInfo];
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于后台时的本地推送接受
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

@end






