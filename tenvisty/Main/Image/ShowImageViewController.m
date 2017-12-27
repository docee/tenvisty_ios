//
//  ShowImageViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/7.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ShowImageViewController.h"
#import "PicturesLoop.h"
#import <MessageUI/MessageUI.h>

@interface ShowImageViewController ()<MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) PicturesLoop *loop;
@property (nonatomic, assign) __block NSInteger cIndex;
@property (nonatomic, strong) NSString *directoryPath;
@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAction:(id)sender {
     [self showActionSheet];
}


-(void)setup{
    NSMutableArray *imagePaths = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *imageNames = [[NSMutableArray alloc] initWithCapacity:0];
    for (LocalPictureInfo *model in self.images) {
        [imagePaths addObject:model.path];
        [imageNames addObject:model.name];
        
        NSLog(@"indexOfObject:%d", (int)[self.images indexOfObject:model]);
    }
    _cIndex = [self.images indexOfObject:self.selectPic];
    _loop = [[PicturesLoop alloc] initWithFrame:self.view.bounds WithImages:imagePaths WithTitle:imageNames currentIndex:_cIndex];
    [self.view addSubview:_loop];
    self.title = FORMAT(@"%@(%d/%d)",@"Local Snapshot", (int)_cIndex + 1,self.images.count);
    
    __weak typeof(self) weakSelf = self;
    _loop.tapBlock = ^(NSInteger currentIndex, NSInteger type) {
        _cIndex = currentIndex;
        if(weakSelf){
            //((LocalPictureInfo*)self.images[currentIndex]).name
            weakSelf.title = FORMAT(@"%@(%d/%d)",@"Local Snapshot", (int)currentIndex + 1,weakSelf.images.count);
        }
    };
}

- (void)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showActionSheet {
    [self presentAlertControllerAfterIOS8];
    
}

- (void)deletePicture {
    
    [self.loop nextIfDeleted:YES];
    
    NSInteger deleteIndex = 0;
    BOOL isDelete = NO;
    LocalPictureInfo *deleteModel = nil;
    for (LocalPictureInfo *model in self.images) {
        
        if ([model.path isEqualToString:self.loop.deleteName]) {
            
            NSLog(@"model.imgPath:%@", model.path);
            [GBase deletePicture:self.camera name:model.name];
            
            deleteIndex = [self.images indexOfObject:model];
            isDelete = YES;
            deleteModel = model;
        }
    }
    
    if (isDelete) {
        
        [self.images removeObject:deleteModel];
        
    }
    
    if (self.images.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else if(isDelete){
        if(_cIndex + 1 > self.images.count){
            _cIndex = 0;
        }
        self.title = FORMAT(@"%@(%d/%d)",@"Local Snapshot", (int)_cIndex + 1,(int)self.images.count);
    }
    
}


- (void)emailPhoto {
    
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        LocalPictureInfo *model = [self.images objectAtIndex:_cIndex];
        
        NSString *extension = [[[self.directoryPath componentsSeparatedByString:@"."] lastObject] lowercaseString];
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSData *attachmentData = nil;
        
        [mailer setSubject:[NSString stringWithFormat:@"Photo - %@", model.path]];
        if ([extension isEqualToString:@"png"]) {
            attachmentData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:model.path]);
        }else {
            attachmentData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:model.path], 1.0);
        }
        
        [mailer addAttachmentData:attachmentData mimeType:[NSString stringWithFormat:@"image/%@",extension] fileName: model.path];
        [mailer setMessageBody:[NSString stringWithString:[NSString stringWithFormat:@"Photo - %@", model.path]] isHTML:NO];
        
        
        [self presentViewController:mailer animated:YES completion:^{
            
        }];
        
    }else {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your email account is disabled or removed, please check your email account.",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        //        alert.tag = 1;
        //        alert.delegate = self;
        //        [alert show];
        //        [alert release];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (result == MFMailComposeResultSent) {
            
            // Was there an error?
            if (error != NULL) {
                
                [TwsProgress showText:FORMAT(@"%d",(int)error.code)];
            }
            else {// No errors
                [TwsProgress showText:LOCALSTR(@"Send success")];
            }
            
        }
        
    }];
}


- (void)savePhotoToCameraRoll {
    
    LocalPictureInfo *model = [self.images objectAtIndex:_cIndex];
    
    UIImage *image = [UIImage imageWithContentsOfFile:model.path];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    __weak typeof(self) weakSelf = self;
    // Was there an error?
    if (error != NULL) {
        [TwsTools presentAlertTitle:self title:nil message:[NSString stringWithFormat:LOCALSTR(@"Please enable \"%@\" in Mobile \"Set-Privacy-Photos\""),[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]] alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            [TwsTools goPhoneSettingPage:@"prefs:root=NOTIFICATIONS_ID"];
            
        } actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:^{
            
        }];
        //[HXProgress showText:error.domain];
    }
    else {// No errors
        [TwsProgress showText:LOCALSTR(@"Save success")];
    }
}


- (NSString *)directoryPath {
    
    if (!_directoryPath) {
        
        //directoryPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Library"];
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _directoryPath = [dirs objectAtIndex:0];
    }
    return _directoryPath;
}



#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self deletePicture];
    }
    
    if (buttonIndex == 1) {
        [self emailPhoto];
    }
    
    if (buttonIndex == 2) {
        [self savePhotoToCameraRoll];
    }
}



- (void)presentAlertControllerAfterIOS8 {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:LOCALSTR(@"Delete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Are you sure to delete?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            [self deletePicture];
        } defaultActionStyle:UIAlertActionStyleDestructive actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
    }];
    
    UIAlertAction *actionEmail = [UIAlertAction actionWithTitle:LOCALSTR(@"Email Photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self emailPhoto];
    }];
    
    UIAlertAction *actionSave = [UIAlertAction actionWithTitle:LOCALSTR(@"Save") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self savePhotoToCameraRoll];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:LOCALSTR(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alert addAction:actionDelete];
    [alert addAction:actionEmail];
    [alert addAction:actionSave];
    [alert addAction:actionCancel];
    
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
