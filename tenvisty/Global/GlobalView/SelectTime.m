//
//  SelectTime.m
//  ThomView
//
//  Created by Tenvis on 16/12/27.
//  Copyright © 2016年 Hichip. All rights reserved.
//


#import "SelectTime.h"

@interface SelectTime ()
{
    CGFloat w;
    CGFloat h;
}

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIImageView *imgViewTo;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnOK;
@property (nonatomic, strong) UIDatePicker *dpFromTime;
@property (nonatomic, strong) UIDatePicker *dpToTime;
@end

@implementation SelectTime


+ (SelectTime *)sharedInstance {
    
    static SelectTime *singleton = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        singleton = [[SelectTime alloc] init];
    });
    
    return singleton;
}


- (instancetype)init {
    if (self = [super init]) {
        
        w = [UIScreen mainScreen].bounds.size.width*0.95;
        h = w;
        
        self.backgroundColor = RGBA_COLOR(220, 220, 220, 0.8);// [UIColor lightGrayColor];
        self.frame = [UIScreen mainScreen].bounds;
        //self.alpha = 0.9;
        
        [self addSubview:self.viewBackground];
        
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (UIView *)viewBackground {
    if (!_viewBackground) {
        
        _viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _viewBackground.backgroundColor = [UIColor whiteColor];
        _viewBackground.layer.cornerRadius = 8.0f;
        _viewBackground.center = self.center;
        _viewBackground.alpha = 1;
        [_viewBackground addSubview:self.labTitle];
        [_viewBackground addSubview:self.dpFromTime];
        if(_fromTime){
            [_dpFromTime setDate:_fromTime];
        }
        [_viewBackground addSubview:self.dpToTime];
        if(_toTime){
            [_dpToTime setDate:_toTime];
        }
        [_viewBackground addSubview:self.imgViewTo];
        [_viewBackground addSubview:self.btnOK];
        [_viewBackground addSubview:self.btnCancel];
        
    }
    
    return _viewBackground;
}


- (UIButton *)btnCancel {
    if (!_btnCancel) {
        int btnW = 80;
        int btnH = 40;
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(40, h/4*3, btnW, btnH)];
        [_btnCancel setTitle:LOCALSTR(@"Cancel") forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        //        _btnCancel.backgroundColor = [UIColor redColor];
    }
    return _btnCancel;
}
- (UIButton *)btnOK {
    if (!_btnOK) {
        
        int btnW = 80;
        int btnH = 40;
        _btnOK = [[UIButton alloc] initWithFrame:CGRectMake(w-40 - btnW, h/4*3, btnW, btnH)];
        [_btnOK setTitle:LOCALSTR(@"OK") forState:UIControlStateNormal];
        [_btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnOK addTarget:self action:@selector(btnOKAction:) forControlEvents:UIControlEventTouchUpInside];
        //        _btnCancel.backgroundColor = [UIColor redColor];
    }
    return _btnOK;
}

-(UIDatePicker *)dpFromTime{
    if (!_dpFromTime) {
        
        _dpFromTime = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, h/4, w/8 * 3 +36, h/4*2)];
        _dpFromTime.datePickerMode = UIDatePickerModeTime;
        _dpFromTime.minuteInterval = 30;
        [_dpFromTime setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return _dpFromTime;
}

-(UIDatePicker *)dpToTime{
    if (!_dpToTime) {
        
        _dpToTime = [[UIDatePicker alloc] initWithFrame:CGRectMake(w-w/8 * 3 -36, h/4, w/8 * 3+36, h/4*2)];
        _dpToTime.datePickerMode = UIDatePickerModeTime;
        _dpToTime.minuteInterval = 30;
        [_dpToTime setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        //        _btnCancel.backgroundColor = [UIColor redColor];
    }
    return _dpToTime;
}
-(UIImageView *)imgViewTo{
    if (!_imgViewTo) {
        
        _imgViewTo = [[UIImageView alloc] initWithFrame:CGRectMake(w/8/2 + w/8*3 + w/8/2 -w/8/2/2, h/4 * 2 - w/8/2/2, w/8/2, w/8/2)];
        _imgViewTo.image = [UIImage imageNamed:@"tws_timeschedule_to"];
    }
    return _imgViewTo;
}


- (void)btnCancelAction:(id)sender {
    if (_cancelBlock) {
        _cancelBlock();
    }
    [[SelectTime sharedInstance] removeFromSuperview];
}
- (void)btnOKAction:(id)sender {
    if (_okBlock) {
       // if([[_dpToTime date] timeIntervalSinceDate:[_dpFromTime date]] > 0){
            _okBlock([_dpFromTime date],[_dpToTime date]);
        //}
//        else{
//            [HXProgress showText:NSLocalizedString(@"End time should be after start time.", nil)];
//            return;
//        }
    }
    [[SelectTime sharedInstance] removeFromSuperview];
}



+ (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    SelectTime *s = [SelectTime sharedInstance];
    if(s.fromTime){
        [s.dpFromTime setDate:s.fromTime];
    }
    if(s.toTime){
        [s.dpToTime setDate:s.toTime];
    }
    //s.center = window.center;
    
    [window addSubview:s];
}

+ (void)show :(NSDate*)fromTime toTime:(NSDate*)toTime{
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    SelectTime *s = [SelectTime sharedInstance];
    s.fromTime = fromTime;
    s.toTime = toTime;
    if(s.fromTime){
        [s.dpFromTime setDate:s.fromTime];
    }
    if(s.toTime){
        [s.dpToTime setDate:s.toTime];
    }
    //s.center = window.center;
    
    [window addSubview:s];
}

+ (void)dismiss {
    
    SelectTime *s = [SelectTime sharedInstance];
    [s removeFromSuperview];
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, w-40, h/4)];
        _labTitle.adjustsFontSizeToFitWidth = YES;
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.text = LOCALSTR(@"Schedule Setting");
    }
    return _labTitle;
}

@end
