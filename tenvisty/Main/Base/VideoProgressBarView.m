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
@interface VideoProgressBarView(){
    int days;
    int hours;
    int minutes;
    int seconds;
}

@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,assign) long startTime;
@property (nonatomic,assign) long endTime;
@property (nonatomic,assign) long nowTime;
@property (nonatomic,assign,readonly) long totalTime;
@property (nonatomic,strong) NSString *strStartTime;
@property (nonatomic,strong) NSString *strNowTime;
@property (nonatomic,strong) NSString *strEndTime;

@end

IB_DESIGNABLE
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

-(void)setTime:(long)nowTime start:(long)startTime end:(long)endTime{
    self.startTime = startTime;
    self.endTime = endTime;
    self.nowTime = nowTime;
    
    int nowTotalTime = (int)(nowTime-startTime);
    int nowDays = nowTotalTime/(3600*24);
    int nowHours = nowTotalTime%(3600*24)/3600;
    int nowMinutes = nowTotalTime%(3600*24)%3600/60;
    int nowSeconds = nowTotalTime%(3600*24)%3600%60;
    
    
    days=((int)self.totalTime)/(3600*24);
    hours = ((int)self.totalTime)%(3600*24)/3600;
    minutes = ((int)self.totalTime)%(3600*24)%3600/60;
    seconds = ((int)self.totalTime)%(3600*24)%3600%60;
    
    if (days > 0) {
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d:%02d",nowDays,nowHours,nowMinutes,nowSeconds];
        self.view.labEndTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d:%02d",days,hours,minutes,seconds];
    }else if(hours >0){
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d",nowHours,nowMinutes,nowSeconds];
        self.view.labEndTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }else {
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d",nowMinutes,nowSeconds];
        self.view.labEndTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d",minutes,seconds];
    }
    self.view.sliderProgress.value = self.view.sliderProgress.maximumValue * (nowTime - startTime)/(endTime - startTime);
}

-(void)setCurrentTimeLab:(long)time{
    int nowTotalTime = (int)(time-self.startTime);
    int nowDays = nowTotalTime/(3600*24);
    int nowHours = nowTotalTime%(3600*24)/3600;
    int nowMinutes = nowTotalTime%(3600*24)%3600/60;
    int nowSeconds = nowTotalTime%(3600*24)%3600%60;
    if (days > 0) {
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d:%02d",nowDays,nowHours,nowMinutes,nowSeconds];
    }else if(hours >0){
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d",nowHours,nowMinutes,nowSeconds];
    }else {
        self.view.labPlayTime.text = [[NSString alloc] initWithFormat:@"%02d:%02d",nowMinutes,nowSeconds];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"VideoProgressBar" owner:self options:nil];
    self.view.sliderProgress.minimumValue = 1;
    self.view.sliderProgress.maximumValue = 100;
    [self.view.sliderProgress addTarget:self action:@selector(sliderEndAction:)forControlEvents:UIControlEventTouchUpInside];
    [self.view.sliderProgress addTarget:self action:@selector(sliderChangedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view.sliderProgress addTarget:self action:@selector(sliderClickAction:) forControlEvents:UIControlEventTouchDown];
    
    [self.view.btnExit addTarget:self action:@selector(clickExit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.btnPlay addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.view];
}

- (void)clickExit:(UIButton*)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didClickExitButton:)]){
        [self.delegate VideoProgressBarView:self didClickExitButton:sender];
    }
}

- (void)clickPlay:(UIButton*)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didClickPlayButton:)]){
        [self.delegate VideoProgressBarView:self didClickPlayButton:sender];
    }
}

-(long)getSliderTime:(UISlider*)sender{
    return self.startTime + (int)(self.totalTime * sender.value / sender.maximumValue);
}

- (void)sliderEndAction:(UISlider*)sender {
    long time = [self getSliderTime:sender];
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didEndSliderChanging:time:)]){
        [self.delegate VideoProgressBarView:self didEndSliderChanging:sender time:time];
    }
}


- (void)sliderChangedAction:(UISlider*)sender {
    long time = [self getSliderTime:sender];
   [self setCurrentTimeLab:time];
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didSliderChanging:time:)]){
        [self.delegate VideoProgressBarView:self didSliderChanging:sender time:time];
    }
}
- (void)sliderClickAction:(UISlider*)sender {
    long time = [self getSliderTime:sender];
    [self setCurrentTimeLab:time];
    if(self.delegate && [self.delegate respondsToSelector:@selector(VideoProgressBarView:didClickSlider:time:)]){
        [self.delegate VideoProgressBarView:self didClickSlider:sender time:time];
    }
}


- (void)show {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.view.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.y -= currentframe.size.height;
        weakSelf.view.frame = currentframe;
    }];
    
}

- (void)dismiss {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.view.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.y += currentframe.size.height;
        weakSelf.view.frame = currentframe;
    }];
    
}
@end
