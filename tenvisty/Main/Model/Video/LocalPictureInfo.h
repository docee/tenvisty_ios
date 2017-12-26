//
//  LocalPictureInfo.h
//  tenvisty
//
//  Created by Tenvis on 2017/12/26.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalPictureInfo : NSObject
//- (id)initWithID:(NSString*)path Time:(NSInteger)time;
- (id)initWithName:(NSString *)name path:(NSString*)path time:(NSInteger)time;

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *thumbPath; // 对应recordingName
@property (nonatomic, assign) NSInteger time;
@property (nonatomic,strong,readonly) NSString *date;
@end
