//
//  AppVersionController.h
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "AppVersionController.h"

@interface AppVersionController ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labAppVersion;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labAppName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labSDKVersion;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labCopyright;

@end

@implementation AppVersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // information of NSBundle
    NSDictionary *informationDic = [NSBundle mainBundle].infoDictionary;
    
    // App Name
    self.labAppName.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    // App Version
    self.labAppVersion.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Version", nil), [informationDic objectForKey:@"CFBundleShortVersionString"]];
    
    // SDK Version
    NSString *sdkVersion = FORMAT(LOCALSTR(@"SDK Version:%@"),[NSString stringWithFormat:@"IOTCAPIs %@", [Camera getIOTCAPIsVerion]]);
    self.labSDKVersion.text = sdkVersion;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
