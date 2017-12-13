//
//  FHVideoRecorder.h
//  apexisCam
//
//  Created by chenchao on 13-1-25.
//  Copyright (c) 2013年 apexis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#include <sys/time.h>

@interface FHVideoRecorder : NSObject
{
    volatile bool                                    isRecordingVideo;
    double                                     currentSeconds;
    
    AVAssetWriterInputPixelBufferAdaptor*   videoInputPixelBufAdaptor;
    AVAssetWriterInput*                     videoWriterInput;
    AVAssetWriterInput*                     audioWriterInput;
    
    AVAssetWriter *                         assetWriter;
    
    CFAbsoluteTime d_stream_time;
    BOOL isHaveVideoFrame;
}
@property (nonatomic,readwrite)bool                                    isRecordingVideo;

+ (FHVideoRecorder* )getInstance;

-(void)startVideoRecord:(NSString *)filePath;
-(BOOL)stopVideoRecord;

- (void)processPixelBuffer: (CVImageBufferRef)pixelBuffer;

- (void)writeVideoWithUIImage: (CGImageRef)frameImage;
- (void)writeVideoWithImageframe: (CVPixelBufferRef)frameImage;//modify
- (void)writeAudioFrame:(NSData *)data;


@end
