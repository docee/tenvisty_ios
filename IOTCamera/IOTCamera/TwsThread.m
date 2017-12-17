//
//  TwsThread.m
//  IOTCamera
//
//  Created by lu yi on 12/15/17.
//

#import "TwsThread.h"
@interface TwsThread()
@property (nonatomic,assign) NSCondition *runLock;
@property (nonatomic,assign) NSInteger *runLockSignal;


@end
@implementation TwsThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        _runLock = [[NSCondition alloc] init];
        _runLockSignal = 0;
    }
    return self;
}
-(void)sleep:(NSInteger)timeSecond{
    [_runLock lock];
    //while (_runLockSignal <= 0) {
    [_runLock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:timeSecond]];
    //}
    [_runLock unlock];
}
-(void)sleep{
    [_runLock lock];
    _runLockSignal = 0;
    while (_runLockSignal <= 0) {
        [_runLock wait];
    }
    [_runLock unlock];
}

- (void)dealloc
{
    [_runLock release];
    [super dealloc];
}
-(void)wakeup{
    [_runLock lock];
    _runLockSignal = 1;
    [_runLock signal];
    [_runLock unlock];
}
-(void)stopThread{
    _isRunningThread = NO;
    [self wakeup];
}

-(void)runThread{
    _isRunningThread = YES;
    [super start];
}

@end
