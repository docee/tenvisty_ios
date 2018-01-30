//
//  WifiAp.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "WifiAp.h"

@implementation WifiAp

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_SWifiAp *model = (HI_SWifiAp *)malloc(sizeof(SWifiAp));
        memset(model, 0, sizeof(HI_SWifiAp));
        memcpy(model, data, size);
        
        _Mode           = [NSNumber numberWithChar:model->Mode];
        _EncType        = [NSNumber numberWithChar:model->EncType];
        _Signal         = [NSNumber numberWithChar:model->Signal];
        _Status         = [NSNumber numberWithChar:model->Status];
        //_strSSID        = [NSString stringWithUTF8String:model->strSSID];
     
        NSData *nsDataSsid=  [self replaceNoUtf8:model->strSSID length:[self getLength:model->strSSID maxLength:32]];
        _strSSID        = [[NSString alloc] initWithData:nsDataSsid encoding:NSUTF8StringEncoding ];
        
//        switch (_EncType.intValue) {
//                
//            case HI_P2P_WIFIAPENC_INVALID:
//                _strEncType = @"INVALID";
//                break;
//                
//            case HI_P2P_WIFIAPENC_WEP:
//                _strEncType = @"WEP";
//                //WEP, for no password
//                break;
//                
//            case HI_P2P_WIFIAPENC_WPA_TKIP:
//                _strEncType = @"WPA_TKIP";
//                break;
//                
//            case HI_P2P_WIFIAPENC_WPA_AES:
//                _strEncType = @"WPA_AES";
//                break;
//                
//            case HI_P2P_WIFIAPENC_WPA2_TKIP:
//                _strEncType = @"WPA2_TKIP";
//                break;
//                
//            case HI_P2P_WIFIAPENC_WPA2_AES:
//                _strEncType = @"WPA2_AES";
//                break;
//                
//            default:
//                _strEncType = @"Unknown";
//                break;
//                
//        }//@switch
//
        
        free(model);
    }
    return self;
}

- (id)initWithSWifiAp:(HI_SWifiAp)swifiap {
    if (self = [super init]) {
        _Mode           = [NSNumber numberWithChar:swifiap.Mode];
        _EncType        = [NSNumber numberWithChar:swifiap.EncType];
        _Signal         = [NSNumber numberWithChar:swifiap.Signal];
        _Status         = [NSNumber numberWithChar:swifiap.Status];
        NSData *nsDataSsid=  [self replaceNoUtf8:swifiap.strSSID length:[self getLength:swifiap.strSSID maxLength:32]];
        _strSSID        = [[NSString alloc] initWithData:nsDataSsid encoding:NSUTF8StringEncoding ];
    }
    return self;
}
-(int)getLength:(HI_CHAR[])data maxLength:(int)maxLength{
    for(int i = 0; i < maxLength; i++){
        if(data[i] == 0){
            return i;
        }
    }
    return 0;
}
//替换非utf8字符
//注意：如果是三字节utf-8，第二字节错误，则先替换第一字节内容(认为此字节误码为三字节utf8的头)，然后判断剩下的两个字节是否非法；
- (NSData *)replaceNoUtf8:(Byte *)data length:(int)length
{
    char aa[] = {'*','*','*','*','*','*'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithBytes:data length:length];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}

- (NSString *)strEncType {
    
    NSString *_strEncType = @"Unknown";
    switch (_EncType.charValue) {
            
        case HI_P2P_WIFIAPENC_INVALID:
            _strEncType = @"INVALID";
            break;
            
        case HI_P2P_WIFIAPENC_WEP:
            _strEncType = @"WEP";
            //WEP, for no password
            break;
            
        case HI_P2P_WIFIAPENC_WPA_TKIP:
            _strEncType = @"WPA_TKIP";
            break;
            
        case HI_P2P_WIFIAPENC_WPA_AES:
            _strEncType = @"WPA_AES";
            break;
            
        case HI_P2P_WIFIAPENC_WPA2_TKIP:
            _strEncType = @"WPA2_TKIP";
            break;
            
        case HI_P2P_WIFIAPENC_WPA2_AES:
            _strEncType = @"WPA2_AES";
            break;
            
        default:
            break;
            
    }//@switch

    return _strEncType;
}

@end
