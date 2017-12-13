//
//  ViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //统一返回按钮
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = LOCALSTR(@"Back");
    self.navigationItem.backBarButtonItem = backBarButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self.camera registerIOSessionDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[self.camera unregisterIOSessionDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate
- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}


#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}



- (void)presentAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];

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
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:NULL];
    });
}

- (void)presentAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock textColor:(UIColor*)color startPos:(NSInteger)start length:(NSInteger)length{
    
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
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}




//根据键盘移动视图高度
- (void)offViewWithFrame:(CGRect)frame
{
    //NSLog(@"frame.origin.y:%f", frame.origin.y);
    //NSLog(@"frame.size.height:%f", frame.size.height);
    
    //键盘高度
    int offset = frame.origin.y + frame.size.height + 64 - (self.view.frame.size.height - 216);
    
    NSLog(@"offset:%d", offset);
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if (offset > 0)
    {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= offset;
        self.view.frame = viewFrame;
        [UIView commitAnimations];
    }
    
}

- (void)offViewWithHeight:(CGFloat)height {
    NSLog(@"height:%f", height);
    //键盘高度
    //int offset = height - (self.view.frame.size.height - 216);
    int offset = height - (self.view.frame.size.height/2);
    NSLog(@"offset:%d", offset);
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if (offset > 0)
    {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= offset;
        self.view.frame = viewFrame;
        
        [UIView commitAnimations];
    }
    
}


//收起键盘是恢复视图高度
- (void)resetView
{
    /* 恢复位置时同样要启动动画，不然会使视图跳跃 2016.1.6 */
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}
- (void)resetView:(CGFloat)y
{
    /* 恢复位置时同样要启动动画，不然会使视图跳跃 2016.1.6 */
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = y;
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}
#pragma mark - 无网络提示
- (void)presentNoNetworkWarning {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:LOCALSTR(@"The current network is not available, please check the network connection!") delegate:self cancelButtonTitle:LOCALSTR(@"Yes") otherButtonTitles:nil, nil];
    [alertView show];
}


#pragma mark - 国际化字符
- (NSString *)keySetupWifiWarning {
    return LOCALSTR(@"Before click the setting button, please turn the phone volume up to the maximum, and put the phone close to the camera");
}


-(void)goPhoneSettingPage:(NSString *)root{
   [self openScheme:root];
}

- (void)openScheme:(NSString *)scheme{
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

@end
