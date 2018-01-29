//
//  OCScanLifeViewController.m
//  OcTrain
//
//  Created by HXjiang on 16/3/25.
//  Copyright © 2016年 蒋林. All rights reserved.
//

#import "OCScanLifeViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "AddCameraNavigationTypeViewController.h"


@interface OCScanLifeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn_searchLan;

@property (nonatomic, assign) BOOL isReading;
@property (nonatomic, strong) CALayer *scanLayer;
//@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic, strong) UIButton *noUIDBtn;

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnTorch;

@property (nonatomic,strong) NSTimer *reRunTimer;


@property (nonatomic,strong) NSString *uid;
@end

@implementation OCScanLifeViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_Primary;
    if([self checkPermission]){
        [self.view layoutIfNeeded];
        [self setUp];
    }
    else{
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(BOOL)checkPermission{
    NSInteger n = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(n == 2) {
        [TwsTools presentAlertTitle:self title:nil message:[NSString stringWithFormat:LOCALSTR(@"Please enable \"%@\" in Mobile \"Set-Privacy-Camera\""),[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]] alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            [TwsTools goPhoneSettingPage:@"prefs:root=NOTIFICATIONS_ID"];
            
        } actionCancelTitle:LOCALSTR(@"Cancel")  actionCancelBlock:^{
            
        }];
        return NO;
    }
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = true;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = true;
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.session startRunning];
    });
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.session isRunning]){
            [self.session stopRunning];
        }
    });
    self.btnTorch.selected = NO;
    if(_reRunTimer != nil){
        [_reRunTimer invalidate];
        _reRunTimer = nil;
    }
}

- (void)didReceiveMemoryWarning
{
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

- (IBAction)goSearchLan:(id)sender {
    [self performSegueWithIdentifier:@"ScanQRCode2SearchCamera" sender:sender];
}
- (IBAction)goInputUIDManually:(id)sender {
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate)
    {
        [self.delegate scanResult:nil];
    }
}

//其他界面返回到此界面调用的方法
- (IBAction)ScanQRCodeViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}
- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{
    if([self checkUID:sender sender:fromViewController]){
        [self go2AddCameraNavigationType:sender];
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ScanQRCode2AddCameraNavigationType"]){
        AddCameraNavigationTypeViewController *controller= segue.destinationViewController;
        controller.uid = self.uid;
    }
    
}

-(void)go2AddCameraNavigationType:(NSString*)_uid{
    self.uid = _uid;
    [self performSegueWithIdentifier:@"ScanQRCode2AddCameraNavigationType" sender:self];
}

-(BOOL)checkUID:(NSString*)_uid sender:(UIViewController*)sender{
    
    if(_uid.length == 0){
        if(sender == self){
            [TwsTools presentAlertMsg:sender message:LOCALSTR(@"Invalid QR code, please scan QR code on the camera label") actionDefaultBlock:^{
                [self reRunScan];
            }];
        }
        else{
            [TwsTools presentAlertMsg:sender message:LOCALSTR(@"[UID] is not entered.")];
        }
    }
    else{
        _uid = [TwsTools readUID:_uid];
        if(_uid){
            return YES;
        }
        else{
            if(sender == self){
                [TwsTools presentAlertMsg:sender message:LOCALSTR(@"Invalid QR code, please scan QR code on the camera label") actionDefaultBlock:^{
                    [self reRunScan];
                }];
            }
            else {
                [TwsTools presentAlertMsg:sender message:LOCALSTR(@"Invalid UID")];
            }
        }
    }
    return NO;
}

- (void)setUp
{
//    CGFloat screenW = self.view.frame.size.width;
//    CGFloat screenH = self.view.frame.size.height;
    
    //遮盖的阴影
//    self.viewPreview = [[UIView alloc] initWithFrame:self.view.bounds];
//    self.viewPreview.backgroundColor = [UIColor blackColor];
//    self.viewPreview.alpha = 0.7;
//    [self.view addSubview:self.viewPreview];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [maskPath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(self.boxView.frame.origin.x+1, self.boxView.frame.origin.y + 1  - (self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height)/2, self.boxView.frame.size.width-2, self.boxView.frame.size.height -2)]];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.path = maskPath.CGPath;
    self.viewPreview.layer.mask = maskLayer;

    
    //获取AVCaptureDevice的实例
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //初始化输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    //初始化输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //创建会话
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        //添加输入流
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        //添加输出流
        [self.session addOutput:self.output];
    }
    
    //条码类型
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
//   
//    
    //创建输出对象
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //设置扫描范围
    self.output.rectOfInterest = CGRectMake(0.2, 0.2, 0.8, 0.8);

    //扫描框
//    self.boxView = [[UIView alloc] initWithFrame:CGRectMake(0.1*screenW, 0.2*screenH, 0.8*screenW, 0.4*screenH)];
    self.boxView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.boxView.layer.borderWidth = 1.0f;
    //self.boxView.backgroundColor = [UIColor greenColor];
    //[self.view addSubview:self.boxView];
    
    //四个角
    CGFloat boxW = self.boxView.frame.size.width;
    CGFloat boxH = self.boxView.frame.size.height;
    CGFloat labx = -1;
    CGFloat labY = -1;
    CGFloat labW = 20;
    CGFloat labH = 2;
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(labx, labY, labW, labH)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(labx, labY, labH, labW)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(labx, boxH+1-labH, labW, labH)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(labx, boxH+1-labW, labH, labW)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(boxW+1-labW, labY, labW, labH)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(boxW+1-labH, labY, labH, labW)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(boxW+1-labW, boxH+1-labH, labW, labH)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(boxW+1-labH, boxH+1-labW, labH, labW)]];
    
    
//    _messageLable = [[UILabel alloc] init];
//    _messageLable.frame = CGRectMake(20, self.boxView.frame.origin.y+30+boxH, screenW-40, 150);
//    _messageLable.text = NSLocalizedString(@"Please put the QR Code within the frame.", nil);
//    _messageLable.numberOfLines = 0;
//    _messageLable.textColor = [UIColor whiteColor];
//    _messageLable.textAlignment = NSTextAlignmentCenter;
//    [_messageLable sizeToFit];
//    [self.viewPreview addSubview:_messageLable];
    
//    if(self.hasNoQRCodeBtn){
//        _noUIDBtn = [[UIButton alloc] init];
//        [_noUIDBtn setTitle:NSLocalizedString(@"No QR Code? click here.", nil) forState:UIControlStateNormal];
//        [_noUIDBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [_noUIDBtn setTitleColor:RGB_COLOR(100, 0, 0) forState:UIControlStateSelected];
//        _noUIDBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        _noUIDBtn.frame = CGRectMake(20, self.boxView.frame.origin.y+70+boxH, screenW-40, 20);
//        [_noUIDBtn sizeToFit];
//        _noUIDBtn.center = CGPointMake(self.view.center.x, self.preview.frame.size.height- 100);
//        [_noUIDBtn addTarget:self action:@selector(btnNoQRCodeAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.viewPreview addSubview:_noUIDBtn];
//    }
    
    
    
    //扫描线
    [self showScanLine];
     NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveLayer) userInfo:nil repeats:YES];
    [timer fire];
    //[self.view layoutIfNeeded];


    //start session
    //[self.session startRunning];
    [self.view setBackgroundColor:Color_Black];
}

- (void)showScanLine
{
    self.scanLayer = [[CALayer alloc] init];
    self.scanLayer.frame = CGRectMake(0, 0, self.boxView.frame.size.width, 1);
    self.scanLayer.backgroundColor = Color_Primary.CGColor;
    [self.boxView.layer addSublayer:self.scanLayer];
}

- (void)dismissScanLine
{
    [self.scanLayer removeFromSuperlayer];
}

- (void)moveLayer
{
    CGRect frame = self.scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y)
    {
//        frame.origin.y = 0;
//        _scanLayer.frame = frame;
        [self dismissScanLine];
        [self showScanLine];
    }
    else
    {
        frame.origin.y += 10;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] > 0)
    {
        //stop session
        [self.session stopRunning];
        //self.output.metadataObjectTypes = @[];
       // [self.session startRunning];
       
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"metadataObject = %@", metadataObject.stringValue);
        if([self checkUID:stringValue sender:self]){
            [self go2AddCameraNavigationType:stringValue];
        }
        else{
            self.output.metadataObjectTypes = @[];
            [self.session startRunning];
//            [[[iToast makeText:LOCALSTR(@"Invalid QR code, please scan QR code on the camera label")] setDuration:3] show];
//            if(_reRunTimer == nil){
//                _reRunTimer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(reRunScan) userInfo:nil repeats:NO];
//            }
        }
//        NSString *uid = [TwsTools readUID:stringValue];;
//        if(uid == nil){
//            self.output.metadataObjectTypes = @[];
//            [self.session startRunning];
//            [[[iToast makeText:LOCALSTR(@"Invalid QR code, please scan QR code on the camera label")] setDuration:3] show];
//            if(_reRunTimer == nil){
//               _reRunTimer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(reRunScan) userInfo:nil repeats:NO];
//            }
//        }
//        else if (self.delegate){
//            [self.navigationController popViewControllerAnimated:!self.hasNoQRCodeBtn];
//            [self.delegate scanResult:stringValue];
//        }
        
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            NSLog(@"是二维码...");
        }
        
    }
}

#pragma mark - 扫描框的四个角
- (UILabel *)setUpLabelFrame:(CGRect)frame
{
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.backgroundColor = Color_Primary;// [UIColor redColor];
    return lable;
}

- (IBAction)skipScanQrCode:(id)sender {
    if (self.delegate)
    {
        [self.navigationController popViewControllerAnimated:!self.hasNoQRCodeBtn];
        [self.delegate scanResult:NO_USE_UID];
    }

}

-(void)reRunScan{
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    [_reRunTimer invalidate];
    _reRunTimer = nil;
}
- (IBAction)openFlash:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected == YES) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
        else{
            sender.selected = NO;
            [[[iToast makeText:LOCALSTR(@"no flash detected")] setDuration:1] show];
        }
    }else{//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }  
    }
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

@end
