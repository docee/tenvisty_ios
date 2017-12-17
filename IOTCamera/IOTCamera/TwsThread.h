//
//  TwsThread.h
//  IOTCamera
//
//  Created by lu yi on 12/15/17.
//

#import <Foundation/Foundation.h>

@interface TwsThread : NSThread

@property (nonatomic,assign) BOOL isRunningThread;

-(void)sleep:(NSInteger)timeSecond;
-(void)sleep;
-(void)wakeup;
-(void)runThread;
-(void)stopThread;
@end
