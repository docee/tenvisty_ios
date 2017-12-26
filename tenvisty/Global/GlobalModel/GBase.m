//
//  GBase.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/13.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "GBase.h"
#import "FMDB.h"
#import "LocalVideoInfo.h"
#import "LocalPictureInfo.h"

#define SQLCMD_CREATE_TABLE_DEVICE @"CREATE TABLE IF NOT EXISTS device(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, dev_nickname TEXT, dev_name TEXT, dev_pwd TEXT, view_acc TEXT, view_pwd TEXT, ask_format_sdcard INTEGER, channel INTEGER, video_quality INTEGER, event_notification INTEGER)"

#define SQLCMD_CREATE_TABLE_SNAPSHOT @"CREATE TABLE IF NOT EXISTS snapshot(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, file_path TEXT, time REAL, snapshot_type INTEGER)"

#define SQLCMD_CREATE_TABLE_ALARM @"CREATE TABLE IF NOT EXISTS alarm(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, type INTEGER, time INTEGER)"


#define SQLCMD_CREATE_TABLE_VIDEO @"CREATE TABLE IF NOT EXISTS video(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, file_path TEXT,small_file_path TEXT, time REAL, recording_type INTEGER)"

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

+ (BOOL)savePictureForCamera:(MyCamera *)mycam image:(UIImage*)img {
    
    GBase *base = [GBase sharedInstance];
    
    NSString *imgName = [NSString stringWithFormat:@"%f.jpg", [[NSDate date] timeIntervalSince1970]];
    //NSString *imgPath = [base imgFilePathWithImgName:imgName];
    
    //NSLog(@"imgPath:%@", imgName);
    
    if (img == nil) {
        return NO;
    }
    NSString *imgPath = [base snapshotPathWithCamera:mycam imgName:imgName];
    [base saveImageToFileFullPath:img filePath:imgPath];
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"INSERT INTO snapshot(dev_uid, file_path,snapshot_type, time) VALUES(?,?,?,?)", mycam.uid, imgName,[NSNumber numberWithInteger:0], [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]) {
            NSLog(@"Fail to add snapshot to database.");
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)saveRemoteRecordPictureForCamera:(MyCamera *)mycam image:(UIImage*)img eventType:(NSInteger)evtType eventTime:(NSInteger)evtTime {
    
    GBase *base = [GBase sharedInstance];
    
    NSString *imgName =[mycam remoteRecordThumbName:evtTime type:evtType];
    //NSString *imgPath = [base imgFilePathWithImgName:imgName];
    
    //NSLog(@"imgPath:%@", imgName);
    
    if (img == nil) {
        return NO;
    }
    [base saveImageToFile:img imageName:imgName];
    
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"INSERT INTO video(dev_uid, file_path,small_file_path, recording_type, time) VALUES(?,?,?,?,?)", mycam.uid, FORMAT(@"%ld",(long)evtTime),imgName,  [NSNumber numberWithInteger:10+evtType], [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]) {
            NSLog(@"Fail to save recording to database.");
            return NO;
        }
    }
    
    return YES;
}

//删除照片
+ (void)deletePicture:(MyCamera*)camera name:(NSString *)pictureName {
    GBase *base = [GBase sharedInstance];
    if (base.db != NULL) {
        
        FMResultSet *rs = [base.db executeQuery:@"SELECT * FROM snapshot WHERE file_path=?", pictureName];
        
        
        while([rs next]) {
            
            NSString *filePath = [rs stringForColumn:@"file_path"];
            
            
            [base.gFileManager removeItemAtPath:[base snapshotPathWithCamera:camera imgName:pictureName] error:NULL];
            
            LOG(@"delete_pictureName : %@", pictureName);
            //NSLog(@"delete -> picturePath:%@", [base documentsWithFileName:filePath]);
            
        }
        
        [rs close];
        
        [base.db executeUpdate:@"DELETE FROM snapshot WHERE file_path=?", pictureName];
    }
}
+(NSString*)thumbPath:(MyCamera*)camera{
    NSString *path = nil;
    GBase *base = [GBase sharedInstance];
    if([self countSnapshot:camera.uid] > 0){
        if (base.db != NULL) {
            FMResultSet *rs = [base.db executeQuery:@"SELECT file_path FROM snapshot WHERE dev_uid=? and snapshot_type=0 order by id desc limit 1", camera.uid];
            while([rs next]) {
                path =  [rs stringForColumn:@"file_path"];
                break;
            }
            [rs close];
        }
        if(path != nil){
            if(![[base gFileManager] fileExistsAtPath: [base snapshotPathWithCamera:camera imgName:path]]){
                 if (![base.db executeUpdate:@"DELETE FROM snapshot where file_path=?", path]){
                 }
                path = nil;
            }
        }
    }
    if(path == nil){
        if([self countVideo:camera.uid] > 0){
            if (base.db != NULL) {
                FMResultSet *rs = [base.db executeQuery:@"SELECT file_path FROM video WHERE dev_uid=? and recording_type=0 order by id desc limit 1", camera.uid];
                while([rs next]) {
                    path =  [rs stringForColumn:@"file_path"];
                    break;
                }
                [rs close];
            }
            if(path != nil){
                if(![[base gFileManager] fileExistsAtPath:[base recordingPathWithCamera:camera recordingName:path]]){
                    if (![base.db executeUpdate:@"DELETE FROM video where file_path=?", path]){
                    }
                    path = nil;
                }
            }
        }
    }
    if(path != nil){
        path =  [base snapshotPathWithCamera:camera imgName:path];
    }
    return path;
}
+(NSInteger)countSnapshot:(NSString*)uid{
    int count = 0;
    GBase *base = [GBase sharedInstance];
    if (base.db != NULL) {
        FMResultSet *rs = [base.db executeQuery:@"SELECT count(*) FROM snapshot WHERE dev_uid=? and snapshot_type=0", uid];
        while([rs next]) {
            count =  [rs intForColumnIndex:0];
            LOG(@"uid:%@ snapshotCount:%d", uid,count);
        }
        [rs close];
    }
    return count;
}
+(NSInteger)countVideo:(NSString*)uid{
    int count = 0;
    GBase *base = [GBase sharedInstance];
    if (base.db != NULL) {
        
        FMResultSet *rs = [base.db executeQuery:@"SELECT count(*) FROM video WHERE dev_uid=? and recording_type=0", uid];
        while([rs next]) {
            count =  [rs intForColumnIndex:0];
            LOG(@"uid:%@ snapshotCount:%d", uid,count);
        }
        [rs close];
    }
    return count;
}

#pragma mark - NSFileManager
- (NSFileManager *)gFileManager {
    return [NSFileManager defaultManager];
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

- (void)saveImageToFileFullPath:(UIImage *)image filePath:(NSString *)filePath {
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
    
    //NSLog(@"imgFullName:%@", imgFullName);
    
    [imgData writeToFile:filePath atomically:YES];
}

- (NSString *)documentsWithFileName:(NSString *)fileName {
    return [self.Documents stringByAppendingPathComponent:fileName];
}
+ (MyCamera*)getCamera:(NSInteger)index{
    GBase *base = [GBase sharedInstance];
    return [base.cameras objectAtIndex:index];
}

+(NSInteger)getCameraIndex:(MyCamera*)camera{
    for(int i = 0; i< [GBase sharedInstance].cameras.count; i++){
        if([[GBase sharedInstance].cameras objectAtIndex:i] == camera){
            return i;
        }
    }
    return -1;
}


//删除录像
+ (void)deleteRecording:(NSString *)recordingPath camera:(Camera *)mycam {
    
    GBase *base = [GBase sharedInstance];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:mycam.uid];
    
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath: strPath];
    //删除
    [fileManager removeItemAtPath:[ NSString stringWithFormat:@"%@.mp4", recordingPath] error:nil];
    
    
    
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"DELETE FROM video where file_path=?", recordingPath]){
            NSLog(@"Fail to remove device from database.");
        }
    }
    
}

//根据完整路径删除录像
+ (void)deleteRecord:(NSString *)fullFilePath  camera:(Camera *)mycam{
    GBase *base = [GBase sharedInstance];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:mycam.uid];
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath: strPath];
    //删除
    NSLog(@"删除的地址：%@",fullFilePath);
    [fileManager removeItemAtPath:fullFilePath error:nil];
    
    
    //输出掉数据库里边的录像！（数据库里边的录像是按照后半段的文件名存储的）
    NSRange range = [fullFilePath rangeOfString:@"Download/"];
    NSString *recordingName = [fullFilePath substringFromIndex:NSMaxRange(range)];
    NSLog(@"dddddeee %@ dddddeee",recordingName);
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"DELETE FROM video where file_path=?", recordingName]){
            NSLog(@"Fail to remove device from database.");
        }
    }
}

- (NSString *)recordingFileName:(Camera *)mycam {
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@.mp4", mycam.uid, strDateTime];
    
    LOG(@"recording_strFileName : %@",strFileName);
    
    return strFileName;
}

- (NSString *)recordingFilePath:(Camera *)mycam fileName:(NSString *)fileName {
    
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:mycam.uid];
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    strPath = [strPath stringByAppendingPathComponent:fileName];
    
    LOG(@"recording_strPath : %@",strPath);
    
    
    return strPath;
}


- (NSString *)recordingNameWithCamera:(Camera *)mycam {
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@.mp4", mycam.uid, strDateTime];
    
    LOG(@"recording_strFileName : %@",strFileName);
    return strFileName;
}

// 本地录像存储路径 Documents/uid/recordingName.mp4
- (NSString *)recordingPathWithCamera:(Camera *)mycam recordingName:(NSString *)recordingName {
    
    NSString *document_uid = [self.Documents stringByAppendingPathComponent:mycam.uid];
    [[NSFileManager defaultManager] createDirectoryAtPath:document_uid withIntermediateDirectories:YES attributes:nil error:nil];
    
    return [document_uid stringByAppendingPathComponent:recordingName];
}

// 本地抓拍存储路径 Documents/uid/
- (NSString *)snapshotPathWithCamera:(Camera *)mycam imgName:(NSString *)imgName {
    
    NSString *document_uid = [self.Documents stringByAppendingPathComponent:mycam.uid];
    [[NSFileManager defaultManager] createDirectoryAtPath:document_uid withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *document_uid_snapshot = [document_uid stringByAppendingPathComponent:@"snapshot"];
    [[NSFileManager defaultManager] createDirectoryAtPath:document_uid_snapshot withIntermediateDirectories:YES attributes:nil error:nil];
    
    return [document_uid_snapshot stringByAppendingPathComponent:imgName];
}

+ (NSMutableArray *)recordingsForCamera:(Camera *)mycam {
    
    GBase *base = [GBase sharedInstance];
    
    NSMutableArray *recordings = [[NSMutableArray alloc] initWithCapacity:0];
    
    FMResultSet *rs = [base.db executeQuery:@"SELECT * FROM video WHERE dev_uid=? and recording_type=0", mycam.uid];
    
    while([rs next]) {
        
        NSString *filePath = [rs stringForColumn:@"file_path"];
        NSInteger time = [rs doubleForColumn:@"time"];
        NSInteger type = [rs intForColumn:@"recording_type"];
        NSString *thumbFilePath = [rs stringForColumn:@"small_file_path"];
        
        LOG(@"FMResultSet_filePath : %@ type:%d", filePath, (int)type);
        LocalVideoInfo* vi = [[LocalVideoInfo alloc] initWithRecordingName:filePath path:[base recordingPathWithCamera:mycam recordingName:filePath] time:time type:type thumbPath:[base recordingPathWithCamera:mycam recordingName:thumbFilePath] ];
        
        [recordings addObject:vi];
    }
    
    [rs close];
    [recordings sortUsingComparator:^NSComparisonResult(LocalVideoInfo *obj1, LocalVideoInfo *obj2) {
        if(obj1.time > obj2.time){
            return 1;
        }
        else if(obj1.time < obj2.time){
            return -1;
        }
        else{
            return 0;
        }
    }];
    return recordings;
}

//保存录像
+ (NSString*)saveRecordingForCamera:(Camera *)mycam thumb:(UIImage *)img {
    
    GBase *base = [GBase sharedInstance];
    
    NSString *imgName = [NSString stringWithFormat:@"%f.jpg", [[NSDate date] timeIntervalSince1970]];
    //NSString *imgPath = [base imgFilePathWithImgName:imgName];
    
    //NSLog(@"imgPath:%@", imgName);
    
    if (img == nil) {
        return nil;
    }
    NSString *thumbPath = [base recordingPathWithCamera:mycam recordingName:imgName];
    [base saveImageToFileFullPath:img filePath:thumbPath];
    NSString *recordFileName = [base recordingNameWithCamera:mycam];
    
    NSString *recordFilePath = [base recordingPathWithCamera:mycam recordingName:recordFileName];
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"INSERT INTO video(dev_uid, file_path,small_file_path,recording_type, time) VALUES(?,?,?,?,?)", mycam.uid, recordFileName,imgName, [NSNumber numberWithInteger:0], [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]) {
            NSLog(@"Fail to save recording to database.");
            return nil;
        }
    }
    else{
        return nil;
    }
    
    return recordFilePath;
}

+ (NSMutableArray *)picturesForCamera:(MyCamera *)mycam {
    
    GBase *base = [GBase sharedInstance];
    
    NSMutableArray *pictures = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    FMResultSet *rs = [base.db executeQuery:@"SELECT * FROM snapshot WHERE dev_uid=? and snapshot_type=0", mycam.uid];
    
    while([rs next]) {
        
        NSString *imageName = [rs stringForColumn:@"file_path"];
        NSInteger time = [rs doubleForColumn:@"time"];
        LocalPictureInfo* vi = [[LocalPictureInfo alloc] initWithName:imageName path:[base snapshotPathWithCamera:mycam imgName:imageName]  time:time];
        [pictures addObject:vi];
        
        //NSLog(@"imagePath :%@", imageName);
    }
    [rs close];
    [pictures sortUsingComparator:^NSComparisonResult(LocalPictureInfo *obj1, LocalPictureInfo *obj2) {
        if(obj1.time > obj2.time){
            return 1;
        }
        else if(obj1.time < obj2.time){
            return -1;
        }
        else{
            return 0;
        }
    }];
    return pictures;
}

@end
