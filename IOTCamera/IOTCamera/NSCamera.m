//
//  NSCamera.m
//  IOTCamera
//
//  Created by liuchan_xin on 13-10-12.
//
//

#import "NSCamera.h"
#import "FHVideoRecorder.h"

@implementation NSCamera
@synthesize cameraModel;
@synthesize sdTotal;
@synthesize cameramodelADD;

@synthesize uid;
@synthesize name;
@synthesize host;
@synthesize port;
@synthesize LANHost;
@synthesize LANPort;
@synthesize user;
@synthesize pwd;
@synthesize ddns;

@synthesize sessionState;
@synthesize remoteNotifications;

@synthesize delegateForMonitor;
@synthesize delegate2;
@synthesize databaseId;

@synthesize  nStatus;

-(void)startRecordVideo:(NSString *)filePath{
    [[FHVideoRecorder getInstance] startVideoRecord:filePath];
}
-(BOOL)stopRecordVideo{
    return [[FHVideoRecorder getInstance] stopVideoRecord];
}

@end
