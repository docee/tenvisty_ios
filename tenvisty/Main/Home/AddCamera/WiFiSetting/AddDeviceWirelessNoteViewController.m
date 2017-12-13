//
//  AddDeviceWirelessNoteViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/11.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "AddDeviceWirelessNoteViewController.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "AddDeviceWirelessViewController.h"

@interface AddDeviceWirelessNoteViewController ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *gifView;

@end

@implementation AddDeviceWirelessNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"configwifi_note" withExtension:@"gif"];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    self.gifView.animatedImage = animatedImage1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AddDeviceWirelessNote2AddDeviceWireless"]){
        AddDeviceWirelessViewController *controller= segue.destinationViewController;
        controller.uid = self.uid;
    }
}

//其他界面返回到此界面调用的方法
- (IBAction)AddDeviceWirelessNoteViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
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
