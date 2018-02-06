//
//  QuantumTime.m
//  CamHi
//
//  Created by HXjiang on 16/8/4.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "QuantumTime.h"

@interface QuantumTime(){
    
}
@property (nonatomic,strong) NSString *desc;
@end

@implementation QuantumTime

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_QUANTUM_TIME *model = (HI_P2P_QUANTUM_TIME *)malloc(sizeof(HI_P2P_QUANTUM_TIME));
        memset(model, 0, sizeof(HI_P2P_QUANTUM_TIME));
        memcpy(model, data, size);
        
        _u32QtType     = model->u32QtType;
        
        _recordTime = 1;
        _startIndex = -1;
        _endIndex = -1;
        for (int i=0; i<1; i++) {
            for (int j=0; j<48; j++) {
                
                if(model->sDayData[i][j] == 'P') {
                    if(model->sDayData[i][(48+j-1)%48] == 'P' && (_endIndex == -1 || _endIndex == j-1)){
                        _endIndex = j;
                    }
                    if(model->sDayData[i][(48+j-1)%48] != 'P'){
                        _startIndex = j;
                    }
                }
                
            }
        }
        if(_startIndex != -1 && _endIndex == -1){
            _endIndex = _startIndex;
        }
        if(_startIndex == -1 && _endIndex != -1){
            _recordTime = 1;
        }
        else if(_startIndex != -1 && _endIndex != -1){
            _recordTime = 2;
        }
        else{
            _recordTime = 0;
        }
//        if(_startIndex == -1){
//            _recordTime = 0;
//        }
//        else if(_endIndex - _startIndex == 47){
//            _recordTime = 1;
//        }
//        else{
//            _recordTime = 2;
//        }
        
        free(model);
    }
    return self;
}

- (id)initWithMode:(HI_P2P_QUANTUM_TIME *)model {
    if (self = [super init]) {
        
        _u32QtType     = model->u32QtType;
        
        _recordTime = 1;
        _startIndex = -1;
        _endIndex = -1;
        
//        for (int i=0; i<1; i++) {
//            for (int j=0; j<48; j++) {
//                
//                if(model->sDayData[i][j] == 'P') {
//                    if(_startIndex  == -1){
//                        _startIndex = j;
//                        _endIndex = j;
//                    }
//                    else{
//                        _endIndex = j;
//                    }
//                }
//                if(model->sDayData[i][j] == 'N') {
//                    if(_startIndex != -1){
//                        break;
//                    }
//                }
//                
//            }
//        }
        
        _startIndex = -1;
        _endIndex = -1;
        for (int i=0; i<1; i++) {
            for (int j=0; j<48; j++) {
                
                if(model->sDayData[i][j] == 'P') {
                    if(model->sDayData[i][(48+j-1)%48] == 'P' && (_endIndex == -1 || _endIndex == j-1)){
                        _endIndex = j;
                    }
                    if(model->sDayData[i][(48+j-1)%48] != 'P'){
                        _startIndex = j;
                    }
                }
                
            }
        }
        if(_startIndex != -1 && _endIndex == -1){
            _endIndex = _startIndex;
        }
        if(_startIndex == -1 && _endIndex != -1){
            _recordTime = 1;
        }
        else if(_startIndex != -1 && _endIndex != -1){
            _recordTime = 2;
        }
        else{
            _recordTime = 0;
        }

        
    }
    return self;
}

- (HI_P2P_QUANTUM_TIME *)model {
    
    HI_P2P_QUANTUM_TIME *t_model = (HI_P2P_QUANTUM_TIME *)malloc(sizeof(HI_P2P_QUANTUM_TIME));
    memset(t_model, 0, sizeof(HI_P2P_QUANTUM_TIME));
    
    t_model->u32QtType  = _u32QtType;

    for (int i=0; i<7; i++) {
        for (int j=0; j<48; j++) {
            if (_recordTime == 0) {
                t_model->sDayData[i][j] = 'N';
            }
            else if(_recordTime == 1){
                t_model->sDayData[i][j] = 'P';
            }
            else{
                if((_endIndex >= _startIndex && j >= _startIndex && j<= _endIndex )||(_endIndex < _startIndex && j>=_startIndex)||(_endIndex < _startIndex && j <= _endIndex)){
                    t_model->sDayData[i][j] = 'P';
                }
                else{
                    t_model->sDayData[i][j] = 'N';
                }
            }
        }
    }
    
    return t_model;
}



- (id)setTime:(NSDate *)fromTime totime:(NSDate *)toTime type:(NSInteger)type{
    _recordTime = (unsigned int)type;
    _startIndex = -1;
    _endIndex = -1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *fromDateComponent = [calendar components:unitFlags fromDate:fromTime];
    NSDateComponents *toDateComponent = [calendar components:unitFlags fromDate:toTime];
    if(type == 1){
        _startIndex = 0;
        _endIndex = 47;
    }
    else{
        _startIndex = [fromDateComponent hour]*2 + floor([fromDateComponent minute]/30);
        _endIndex = [toDateComponent hour]*2 + floor([toDateComponent minute]/30) - 1;
//        if(_endIndex < 0){
//            _endIndex = 0;
//        }
    }
    
    return self;
}

- (id)setIndex:(NSInteger)startIndex endindex:(NSInteger)endIndex type:(NSInteger)type{
    _startIndex = (int)startIndex;
    _endIndex = (int)endIndex;
    _recordTime = (int)type;
    return self;
}

+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

-(NSDate *)getFromTime{
    int h = floor(_startIndex/2);
    int m = _startIndex%2 * 30;
    long senconds = h * 60 * 60 + m * 60;
    if(_recordTime != 2){
        senconds = 0;
    }
    NSDate *fromTime = [[NSDate alloc]initWithTimeIntervalSince1970:senconds];

    return fromTime;
}

-(NSDate *)getToTime{
    int h = floor((_endIndex + 1)/2);
    int m = (_endIndex + 1)%2 * 30;
    long senconds = h * 60 * 60 + m * 60;
    if(_recordTime != 2){
        senconds = 0;
    }
    NSDate *toTime = [[NSDate alloc]initWithTimeIntervalSince1970:senconds];
    return toTime;
}

-(NSString*)desc{
    NSString *result = LOCALSTR(@"NONE");
    if(_recordTime == 0){
        result = LOCALSTR(@"NONE");
    }
    else if(_recordTime == 1){
        result = LOCALSTR(@"ALL DAY");
    }
    else {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *strToTime = [dateFormatter stringFromDate:[self getToTime]];
//        if([strToTime isEqualToString:@"00:00"]){
//            strToTime = @"24:00";
//        }
        result = [NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:[self getFromTime]],strToTime];
    }
    return result;
}

@end
