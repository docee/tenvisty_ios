//
//  TwsMonitor.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/9.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "TwsMonitor.h"
@interface TwsMonitor(){
    id<TwsMonitorTouchDelegate>delegate;
    BaseCamera *camera;
    
    CGPoint gestureStartPoint;
    CGPoint initFontSize;
    NSInteger minGestureLength;
    NSInteger maxVariance;
}

@end

@implementation TwsMonitor

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - Public Methods

- (void)attachCamera:(BaseCamera *)cam
{
    camera = cam;
    dispatch_async(dispatch_get_main_queue(), ^{
        [camera SetImgview:self];
    });
}

- (void)deattachCamera
{
    if(camera){
        dispatch_async(dispatch_get_main_queue(), ^{
            [camera RemImgview];
            camera = nil;
        });
    }
}


- (void)dealloc
{
    self.delegate = nil;
}


- (void)setMinimumGestureLength:(NSInteger)length MaximumVariance:(NSInteger)variance
{
    minGestureLength = length;
    maxVariance = variance;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(doPinch:)];
    [self addGestureRecognizer:pinch];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    gestureStartPoint = [touch locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    
    CGFloat deltaX = currentPosition.x - gestureStartPoint.x;
    CGFloat deltaY = currentPosition.y - gestureStartPoint.y;
    TwsCameraDirection direction = TwsDirectionNone;
    
    // pan
    if (fabs(deltaX) >= minGestureLength && fabs(deltaY) <= maxVariance) {
        
        if (deltaX > 0) direction = TwsDirectionPanLeft;
        else direction = TwsDirectionPanRight;
    }
    // tilt
    else if (fabs(deltaY) >= minGestureLength && fabs(deltaX) <= maxVariance) {
        
        if (deltaY > 0) direction = TwsDirectionTiltUp;
        else direction = TwsDirectionTiltDown;
    }
    
    if (direction != TwsDirectionNone) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(monitor:gestureSwiped:)]) {
            [self.delegate monitor:self gestureSwiped:direction];
        }
        else {
            
//            unsigned char ctrl = -1;
//            if (direction == DirectionTiltUp) ctrl = AVIOCTRL_PTZ_UP;
//            else if (direction == DirectionTiltDown) ctrl = AVIOCTRL_PTZ_DOWN;
//            else if (direction == DirectionPanLeft) ctrl = AVIOCTRL_PTZ_LEFT;
//            else if (direction == DirectionPanRight) ctrl = AVIOCTRL_PTZ_RIGHT;
            
            [camera PTZ:direction];
        }
    }
}

- (void)doPinch:(UIPinchGestureRecognizer *)pinch
{
    if (pinch.state == UIGestureRecognizerStateEnded) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(monitor:gesturePinched:)]) {
            [self.delegate monitor:self gesturePinched:pinch.scale];
        }
    }
}
@end
