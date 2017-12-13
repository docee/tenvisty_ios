//
//  GBase.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/13.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "GBase.h"
#import "FMDB.h"

#define SQLCMD_CREATE_TABLE_DEVICE @"CREATE TABLE IF NOT EXISTS device(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, dev_nickname TEXT, dev_name TEXT, dev_pwd TEXT, view_acc TEXT, view_pwd TEXT, ask_format_sdcard INTEGER, channel INTEGER, video_quality INTEGER, event_notification INTEGER)"

#define SQLCMD_CREATE_TABLE_SNAPSHOT @"CREATE TABLE IF NOT EXISTS snapshot(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, file_path TEXT, time REAL)"

#define SQLCMD_CREATE_TABLE_ALARM @"CREATE TABLE IF NOT EXISTS alarm(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, type INTEGER, time INTEGER)"


#define SQLCMD_CREATE_TABLE_VIDEO @"CREATE TABLE IF NOT EXISTS video(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, file_path TEXT, time REAL, recording_type INTEGER)"

//#define SQLCMD_CREATE_TABLE_DEVICE_FUNCTION @"CREATE TABLE IF NOT EXISTS device_function(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, dev_function TEXT)"
//
//#define SQLCMD_CREATE_TABLE_DEVICE_DICTION @"CREATE TABLE IF NOT EXISTS device_diction(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, dev_key TEXT, dev_value TEXT)"
@interface GBase()
@property (atomic,strong) FMDatabase *db;
@end

@implementation GBase

- (NSMutableArray *)cameras {
    if (!_cameras) {
        _cameras = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cameras;
}

static GBase *base = nil;
+ (GBase *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        base = [[GBase alloc] init];
    });
    return base;
}


- (instancetype)init {
    
    if (self = [super init]) {
        
        //        self.cameras = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *databaseFilePath = [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"databasehx.sqlite"];
        
        //
        self.db = [[FMDatabase alloc] initWithPath:databaseFilePath];
        
        //open database
        if (![self.db open]) {
            LOG(@">>> open sqlite db failed.")
            return nil;
        }
        
        //create table
        if (self.db != NULL) {
            if (![self.db executeUpdate:SQLCMD_CREATE_TABLE_DEVICE]) LOG(@"Can not create table device");
            if (![self.db executeUpdate:SQLCMD_CREATE_TABLE_SNAPSHOT]) LOG(@"Can not create table snapshot");
            if (![self.db executeUpdate:SQLCMD_CREATE_TABLE_VIDEO]) LOG(@"Can not create table video");
        }
        
    }
    return self;
}

+ (void)initCameras {
    
    GBase *base = [GBase sharedInstance];
    
    //    if (base.cameras.count != 0) {
    [base.cameras removeAllObjects];
    //    }
    
    if (base.db != NULL) {
        
        FMResultSet *rs = [base.db executeQuery:@"SELECT * FROM device"];
        int cnt = 0;
        
        while([rs next] && cnt++ < MAX_CAMERA_LIMIT) {
            NSString *tuid  = [rs stringForColumn:@"dev_uid"];
            NSString *tname = [rs stringForColumn:@"dev_nickname"];
            NSString *tuser = [rs stringForColumn:@"view_acc"];
            NSString *tpwd  = [rs stringForColumn:@"view_pwd"];
            //NSInteger tchannel = [rs intForColumn:@"channel"];
            NSInteger tvideoQuality = [rs intForColumn:@"video_quality"];
            NSInteger eventNotification = [rs intForColumn:@"event_notification"];
            MyCamera *mycam = [[MyCamera alloc] initWithUid:tuid Name:tname UserName:tuser Password:tpwd];
            mycam.videoQuality = tvideoQuality;
            mycam.eventNotification = eventNotification;
            [base.cameras addObject:mycam];
            
            LOG(@">>>Load_Camera (%@)", mycam);
        }
        
        LOG(@"load_total_camera_count : %d", (int)base.cameras.count)
        
        [rs close];
    }
}

+ (void)addCamera:(MyCamera *)mycam {
    GBase *base = [GBase sharedInstance];
    
    [base.cameras addObject:mycam];
    
    if (base.db != NULL) {
        [base.db executeUpdate:@"INSERT INTO device(dev_uid, dev_nickname, dev_name, dev_pwd, view_acc, view_pwd, channel, video_quality) VALUES(?,?,?,?,?,?,?,?)",
         mycam.uid, mycam.nickName, mycam.user, mycam.pwd, mycam.user, mycam.pwd, [NSNumber numberWithInt:0], [NSNumber numberWithInteger:mycam.videoQuality]];
    }
}

+ (void)deleteCamera:(Camera *)mycam {
    GBase *base = [GBase sharedInstance];
    
    [base.cameras removeObject:mycam];
    NSLog(@"delete_camera : %@", mycam.uid);
    
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"DELETE FROM device where dev_uid=?", mycam.uid]) {
            NSLog(@"Fail to remove device from database : %@", mycam.uid);
        }
    }
}

+ (void)editCamera:(MyCamera *)mycam {
    GBase *base = [GBase sharedInstance];
    
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"UPDATE device SET dev_nickname=?, view_pwd=? ,view_acc=? ,video_quality=? ,event_notification=? WHERE dev_uid=?", mycam.nickName, mycam.pwd, mycam.user , [NSNumber numberWithInteger:mycam.videoQuality],[NSNumber numberWithInteger:mycam.eventNotification], mycam.uid]) {
            NSLog(@"Fail_to_update_device_to_database.");
        }
    }
}

+ (BOOL)savePictureForCamera:(MyCamera *)mycam {
    
    GBase *base = [GBase sharedInstance];
    
    NSString *imgName = [NSString stringWithFormat:@"%f.jpg", [[NSDate date] timeIntervalSince1970]];
    //NSString *imgPath = [base imgFilePathWithImgName:imgName];
    
    UIImage *image = nil;//[mycam ];
    //NSLog(@"imgPath:%@", imgName);
    
    if (image == nil) {
        return NO;
    }
    [base saveImageToFile:image imageName:imgName];
    
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"INSERT INTO snapshot(dev_uid, file_path, time) VALUES(?,?,?)", mycam.uid, imgName, [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]) {
            NSLog(@"Fail to add snapshot to database.");
            return NO;
        }
    }
    
    return YES;
    
}

- (NSString *)Documents {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (void)saveImageToFile:(UIImage *)image imageName:(NSString *)fileName {
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
    
    //NSString *imgFullName = [self pathForDocumentsResource:fileName];
    NSString *imgFullName = [self documentsWithFileName:fileName];
    
    //NSLog(@"imgFullName:%@", imgFullName);
    
    [imgData writeToFile:imgFullName atomically:YES];
}

- (NSString *)documentsWithFileName:(NSString *)fileName {
    return [self.Documents stringByAppendingPathComponent:fileName];
}


@end
