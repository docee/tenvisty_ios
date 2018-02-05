//
//  QuantumTime.h
//  CamHi
//
//  Created by HXjiang on 16/8/4.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuantumTime : NSObject


@property (nonatomic, assign) unsigned int u32QtType;
@property (nonatomic, assign) unsigned int recordTime;
@property (nonatomic, assign)  int startIndex;
@property (nonatomic, assign)  int endIndex;
@property (nonatomic,strong,readonly) NSString *desc;

- (id)initWithData:(char *)data size:(int)size;
- (id)initWithMode:(HI_P2P_QUANTUM_TIME *)model;
- (id)setTime:(NSDate *)fromTime totime:(NSDate *)toTime type:(NSInteger)type;
- (id)setIndex:(NSInteger)startIndex endindex:(NSInteger)endIndex type:(NSInteger)type;
- (HI_P2P_QUANTUM_TIME *)model;
-(NSDate *)getFromTime;
-(NSDate *)getToTime;

@end
