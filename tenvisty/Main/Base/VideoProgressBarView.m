//
//  VideoProgressBarView.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/7.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#define SECONDS_DAY     (60*60*24)
#define SECONDS_HOUR     (60*60)

#import "VideoProgressBarView.h"
@interface VideoProgressBarView()<UIGestureRecognizerDelegate>{
    int days;
    int hours;
    int minutes;
    int seconds;
}

@property (nonatomic,assign) BOOL isDraging;
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,assign) long startTime;
@property (nonatomic,assign) long endTime;
@property long firstPlayTime;
@property BOOL isFirstPlayTime;
@property BOOL isChangingPos;
@property (nonatomic,assign) BOOL isVisibility;
@property (nonatomic,assign,readonly) long totalTime;
@property (nonatomic,strong) NSString *strStartTime;
@property (nonatomic,strong) NSString *strNowTime;
@property (nonatomic,strong) NSString *strEndTime;
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

@end

@implementation VideoProgressBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(long)totalTime{
    return _endTime - _startTime;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect rect = frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.view.frame = rect;
}

-(void)setTime:(long)startTime end:(long)endTime{
    [self setFrame:self.frame];
    self.startTime = startTime;
    self.endTime = endTime;
    days=((int)self.totalTime)/(3600*24);
    hours = ((int)self.totalTime)%(3600*24)/3600;
    minutes = ((int)self.totalTime)%(3600*24)%3600/60;
    seconds = ((int)self.totalTime)%(3600*24)%3600%60;
    
    if (days > 0) {
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d:%02d",0,0,0,0];
        self.view.labEndTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d:%02d",days,hours,minutes,seconds];
    }else if(hours >0){
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d",0,0,0];
        self.view.labEndTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }else {
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d",0,0];
        self.view.labEndTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d",minutes,seconds];
    }
    self.view.sliderProgress.value = 0;
    self.view.btnPlay.selected = YES;
    self.isFirstPlayTime = YES;
}


-(void)setNowTime:(long)nowTime{
    if(self.isFirstPlayTime){
        self.firstPlayTime = nowTime;
        self.isFirstPlayTime = NO;
    }
    self.view.btnPlay.selected = YES;
    if(!self.isDraging && !self.isChangingPos){
        self.view.sliderProgress.value = self.view.sliderProgress.maximumValue * (nowTime - self.firstPlayTime)/1000/(self.endTime - self.startTime);
        [self setCurrentTimeLab:(nowTime - self.firstPlayTime)/1000];
    }
}

-(void)setCurrentTimeLab:(long)nowTotalTime{
    int nowDays = (int)nowTotalTime/(3600*24);
    int nowHours = (int)nowTotalTime%(3600*24)/3600;
    int nowMinutes = (int)nowTotalTime%(3600*24)%3600/60;
    int nowSeconds = (int)nowTotalTime%(3600*24)%3600%60;
    if (days > 0) {
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d:%02d",nowDays,nowHours,nowMinutes,nowSeconds];
    }else if(hours >0){
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d",nowHours,nowMinutes,nowSeconds];
    }else {
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d",nowMinutes,nowSeconds];
    }
}
-(void)setEnd{
    self.view.sliderProgress.value = self.view.sliderProgress.maximumValue;
    self.view.btnPlay.selected = NO;
     [self setCurrentTimeLab:self.totalTime];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        self.isVisibility = YES;
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"VideoProgressBar" owner:self options:nil];
    self.view.sliderProgress.minimumValue = 1;
    self.view.sliderProgress.maximumValue = 100;
    [self.view.sliderProgress addTarget:self action:@selector(sliderEndAction:)forControlEvents:UIControlEventTouchUpInside];
    [self.view.sliderProgress addTarget:self action:@selector(sliderEndAction:)forControlEvents:UIControlEventTouchUpOutside];
    
    [self.view.sliderProgress addTarget:self action:@selector(sliderChangedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view.sliderProgress addTarget:self action:@selector(sliderClickAction:) forControlEvents:UIControlEventTouchDown];
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    _tapGesture.delegate = self;
    [self.view.sliderProgress addGestureRecognizer:_tapGesture];
    [self.view.btnExit addTarget:self action:@selector(clickExit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.btnPlay addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.view];
}
- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    self.isChangingPos = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isChangingPos = NO;
    });
    CGPoint touchPoint = [sender locationInView:self.view.sliderProgress];
    CGFloat value = (self.view.sliderProgress.maximumValue - self.view.sliderProgress.minimumValue) * (touchPoint.x / self.view.sliderProgress.frame.size.width);
    [self.view.sliderProgress setValue:value animated:YES];
    long time = [self getSliderTime:self.view.sliderProgress];
    [self setCurrentTimeLab:time-self.startTime];
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didClickSlider:time:)]){
        [self.delegate VideoProgressBarView:self didClickSlider:self.view.sliderProgress time:time];
    }
}

- (void)clickExit:(UIButton*)sender {
    sender.selected = !sender.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didClickFullScreenButton:)]){
        [self.delegate VideoProgressBarView:self didClickFullScreenButton:sender];
    }
}

- (void)clickPlay:(UIButton*)sender {
    sender.selected = !sender.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didClickPlayButton:)]){
        [self.delegate VideoProgressBarView:self didClickPlayButton:sender];
    }
}

-(long)getSliderTime:(UISlider*)sender{
    return self.startTime + (int)(self.totalTime * sender.value / sender.maximumValue);
}

- (void)sliderEndAction:(UISlider*)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isChangingPos = NO;
    });
    self.isDraging = NO;
    _tapGesture.enabled = YES;
    long time = [self getSliderTime:sender];
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didEndSliderChanging:time:)]){
        [self.delegate VideoProgressBarView:self didEndSliderChanging:sender time:time];
    }
}


- (void)sliderChangedAction:(UISlider*)sender {
    long time = [self getSliderTime:sender];
   [self setCurrentTimeLab:time-self.startTime];
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didSliderChanging:time:)]){
        [self.delegate VideoProgressBarView:self didSliderChanging:sender time:time];
    }
}
- (void)sliderClickAction:(UISlider*)sender {
    self.isChangingPos = YES;
    _tapGesture.enabled = NO;
    self.isDraging = YES;
}


- (void)show {
    _isVisibility = YES;
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.view.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        currentframe.origin.y -= currentframe.size.height+80;
        weakSelf.view.frame = currentframe;
    }];
    
}

- (void)dismiss {
    _isVisibility = NO;
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.view.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        currentframe.origin.y += currentframe.size.height+80;
        weakSelf.view.frame = currentframe;
    }];
    
}
//-(void)showExit{
//    self.view.constraint_width_btnExit.constant = 30;
//    [self.view updateConstraints];
//}
//-(void)hideExit{
//     self.view.constraint_width_btnExit.constant = 0;
//    [self.view updateConstraints];
//}
@end
