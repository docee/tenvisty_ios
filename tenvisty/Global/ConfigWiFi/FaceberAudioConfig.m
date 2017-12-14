//
//  FaceberAudioConfig.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/12.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "FaceberAudioConfig.h"
#import "voiceEncoder.h"
#import <AVFoundation/AVFoundation.h>
#import "GCDAsyncUdpSocket.h"

@interface FaceberAudioConfig ()<VoiceMsgBack, GCDAsyncUdpSocketDelegate>{
    BOOL isStopped;
    GCDAsyncUdpSocket *udpSocket;
}
@property(nonatomic,strong)VoicePlayer *player;
@property(nonatomic,assign)NSInteger playCnt;
@end
int freqss[] = {15000,15200,15400,15600,15800,16000,16200,16400,16600,16800,17000,17200,17400,17600,17800,18000,18200,18400,18600};

@implementation FaceberAudioConfig

-(void) runConfig{
     isStopped = NO;
    [self initObj];
     [_player playSSIDWiFi:self.ssid pwd:self.pwd playCount:1 muteInterval:200];
}

-(void) stopConfig{
    isStopped = YES;
    if(![_player isStopped]){
        [_player stop];
    }
    
    if(udpSocket != nil){
        [udpSocket close];
        udpSocket = nil;
    }
}
- (void)setupSocket
{
    // Setup our socket.
    // The socket will invoke our delegate methods using the usual delegate paradigm.
    // However, it will invoke the delegate methods on a specified GCD delegate dispatch queue.
    //
    // Now we can configure the delegate dispatch queues however we want.
    // We could simply use the main dispatc queue, so the delegate methods are invoked on the main thread.
    // Or we could use a dedicated dispatch queue, which could be helpful if we were doing a lot of processing.
    //
    // The best approach for your application will depend upon convenience, requirements and performance.
    //
    // For this simple example, we're just going to use the main thread.
    
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![udpSocket bindToPort:8601 error:&error])
    {
        NSLog(@"%@", FORMAT(@"Error binding: %@", error));
        return;
    }
    if (![udpSocket beginReceiving:&error])
    {
        NSLog(@"%@", FORMAT(@"Error receiving: %@", error));
        return;
    }
    
    NSLog(@"Ready");
}
-(void)initObj{
    if(_player==nil)
    {
        AVAudioSession *mySession = [AVAudioSession sharedInstance];
        [mySession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        int base = 4000;
        for (int i = 0; i < sizeof(freqss)/sizeof(int); i ++) {
            freqss[i] = base + i *150;
        }
        _player=[[VoicePlayer alloc] init];
        _player.delegate = self;
        [_player setFreqs:freqss freqCount:sizeof(freqss)/sizeof(int)];
        //[NSThread detachNewThreadSelector:@selector(GoSmartLinkThread) toTarget:self withObject:nil];
        //[self GoSmartLinkThread];
    }
    if(udpSocket == nil){
        [self setupSocket];
    }
}
-(void)VoiceOverMsg:(int)flag{
    if(flag==1)
    {
        if(isStopped)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                btnSend.enabled=true;
                //                [btnSend setSelected:NO];
                //                [btnNext setTitle:NSLocalizedString(@"ForgotNext", nil) forState:UIControlStateNormal];
                //                btnNext.enabled=YES;
                //                labTip2.hidden=NO;
            });
        }else{
            _playCnt++;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_player playSSIDWiFi:self.ssid pwd:self.pwd playCount:1 muteInterval:200];
            });
        }
    }
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:[[msg substringToIndex:msg.length-1] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if(jsonObject != nil && [jsonObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *jsonDic = (NSDictionary *)jsonObject;
            NSString *uid = jsonDic[@"SmLinkReport"][@"DID"];
            NSString *status = jsonDic[@"SmLinkReport"][@"Status"];
            NSString *ip = jsonDic[@"SmLinkReport"][@"IP"];
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(onReceived:ip:uid:)]){
                [self.delegate onReceived:status ip:ip uid:uid];
            }
        }
        NSLog(FORMAT(@"RECV: %@", msg));
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
        NSLog(FORMAT(@"RECV: Unknown message from: %@:%hu", host, port));
    }
}

+(id)sharedInstance{
    static FaceberAudioConfig *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}
@end
