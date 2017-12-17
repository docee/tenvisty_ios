//
//  LiveViewController.m
//  tenvisty
//
//  Created by lu yi on 12/3/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()<MyCameraDelegate>
@property (weak, nonatomic) IBOutlet UIView *toolbtns_land;
@property (weak, nonatomic) IBOutlet UIView *connectStatus_port;
@property (weak, nonatomic) IBOutlet UIView *toolbtns_portrait;
@property (weak, nonatomic) IBOutlet UIView *video_wrapper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_status_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_videowrapper_height;
@property (nonatomic,assign) Boolean isFullscreen;
@property (weak, nonatomic) IBOutlet UILabel *labConnectState;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_toolbar_portrait_height;
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFullscreen = self.view.bounds.size.width > self.view.bounds.size.height;// self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight;
    [self rotateOrientation:_isFullscreen?UIInterfaceOrientationLandscapeLeft:UIInterfaceOrientationPortrait];
    [self setup];
    // Do any additional setup after loading the view.
}

-(void)setup{
    self.title = self.camera.nickName;
}

-(void)viewWillAppear:(BOOL)animated{
    self.camera.delegate2 = self;
    _labConnectState.text = [(self.camera) strConnectState];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.camera.delegate2 = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||

            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}



-(void) rotateOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    CGFloat width = Screen_Main.width>Screen_Main.height?Screen_Main.height:Screen_Main.width;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       
       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ){
        [self.toolbtns_land setHidden:NO];
        [self.constraint_status_height setConstant:0];
        
        [self.constraint_toolbar_portrait_height setConstant:0];
        [self.toolbtns_portrait setHidden:YES];
        self.navigationController.navigationBar.hidden=YES;
        [self.constraint_videowrapper_height setConstant:width+300];
        _isFullscreen = YES;
    }
    else{
        [self.toolbtns_land setHidden:YES];
        [self.constraint_status_height setConstant:40];
        [self.constraint_toolbar_portrait_height setConstant:40];
        [self.toolbtns_portrait setHidden:NO];
        self.navigationController.navigationBar.hidden=NO;
        [self.constraint_videowrapper_height setConstant:width*9/16];
        _isFullscreen = NO;
      //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
}

- (BOOL)prefersStatusBarHidden {
    return _isFullscreen;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self rotateOrientation:toInterfaceOrientation];
    [self setNeedsStatusBarAppearanceUpdate];
    
}
//在试图将要已将出现的方法中
//- (void)viewDidAppear:(BOOL)animated{
//    
//    [super viewDidAppear:animated];
//    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        
//        //调用隐藏方法
//        [self prefersStatusBarHidden];
//        
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//        
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)camera:(NSCamera *)camera _didChangeSessionStatus:(NSInteger)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        _labConnectState.text = [((MyCamera*)camera) strConnectState];
    });
}


@end
