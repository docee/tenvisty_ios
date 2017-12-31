//
//  ImageCollectionViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/7.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "ImageCollectionTableViewCell.h"
#import "ImageCollectionViewCell.h"
#import "LocalPictureInfo.h"
#import "LocalVideoInfo.h"
#import "ShowImageViewController.h"
#import "MediaPlayer/MediaPlayer.h"
#import <MessageUI/MessageUI.h>

#define Offx        (5)
#define Offy        (5)
#define OffTop      (5)
#define OffBottom   (5)
#define OffLeft     (5)
#define OffRight    (5)

@interface ImageCollectionViewController ()<MFMailComposeViewControllerDelegate>{
    BOOL isEdit;
    NSInteger longPressIndex;
}
@property (weak, nonatomic) IBOutlet UIView *viewToolbarBottom;
@property (weak, nonatomic) IBOutlet UILabel *labCurrentDate;
@property (weak, nonatomic) IBOutlet UILabel *labCurrentDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnCurrentSelectAll;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_type;
@property (nonatomic,strong) NSMutableArray *sourceList;
@property (nonatomic,strong) NSMutableArray *originSourceList;
@property (nonatomic,strong) LocalPictureInfo *selectPic;
@property (nonatomic, strong)MPMoviePlayerViewController *movieController;
@property (nonatomic, strong) NSString *directoryPath;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnEmail;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSave;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnDelete;


@end

@implementation ImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    longPressIndex = -1;
    self.title = self.camera.nickName;
    [self.btnEmail setBackgroundImage:[UIImage imageWithColor:Color_Primary wihtSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [self.btnSave setBackgroundImage:[UIImage imageWithColor:Color_Primary wihtSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [self.btnDelete setBackgroundImage:[UIImage imageWithColor:Color_Primary wihtSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [self.btnEmail setBackgroundImage:[UIImage imageWithColor:Color_GrayLight wihtSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.btnSave setBackgroundImage:[UIImage imageWithColor:Color_GrayLight wihtSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.btnDelete setBackgroundImage:[UIImage imageWithColor:Color_GrayLight wihtSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
- (IBAction)clickSelectAll:(UIButton*)sender {
    sender.selected = !sender.selected;
    for(LocalPictureInfo *pic in self.sourceList[sender.tag]){
        pic.isChecked = sender.selected;
    }
    [self.tableview reloadData];
}
- (IBAction)clickEdit:(UIBarButtonItem *)sender {
    [self toggleEditMode:YES];
}
- (IBAction)clickEmail:(id)sender {
    NSMutableArray *checkedSource = [[NSMutableArray alloc] init];
    for (LocalPictureInfo *pic in self.originSourceList) {
        if(pic.isChecked){
            [checkedSource addObject:pic];
        }
    }
    if(checkedSource.count>0){
        [self emailPhoto:checkedSource];
        [self refresh];
    }
    else{
        if(_segment_type.selectedSegmentIndex == 0){
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"Please select the picture")];
        }
        else{
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"Please select the video")];
        }
    }
}
- (IBAction)clickSave:(id)sender {
    NSMutableArray *checkedSource = [[NSMutableArray alloc] init];
    for (LocalPictureInfo *pic in self.originSourceList) {
        if(pic.isChecked){
            [checkedSource addObject:pic];
        }
    }
    if(checkedSource.count>0){
        [self savePhotoToCameraRoll:checkedSource];
        [self refresh];
    }
    else{
        if(_segment_type.selectedSegmentIndex == 0){
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"Please select the picture")];
        }
        else{
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"Please select the video")];
        }
    }
    
    
}
- (void)savePhotoToCameraRoll:(NSMutableArray*)sources {
    if(_segment_type.selectedSegmentIndex == 0){
        for(LocalPictureInfo *model in sources){
            UIImage *image = [UIImage imageWithContentsOfFile:model.path];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    else{
        for(LocalPictureInfo *model in sources){
            [self saveVideo:model.path];
        }
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
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
//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    if (videoPath) {
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath)) {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }
    
}
//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [TwsTools presentAlertTitle:self title:nil message:[NSString stringWithFormat:LOCALSTR(@"Please enable \"%@\" in Mobile \"Set-Privacy-Photos\""),[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]] alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            [TwsTools goPhoneSettingPage:@"prefs:root=NOTIFICATIONS_ID"];
            
        } actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:^{
            
        }];
    }
    else {
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
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)emailPhoto:(NSMutableArray*)souces {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    if(_segment_type.selectedSegmentIndex == 0){
        [mailer setSubject:[NSString stringWithFormat:@"%@ - Photos",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]]];
    }
    else{
        [mailer setSubject:[NSString stringWithFormat:@"%@ - Videos",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]]];
    }
   for(LocalPictureInfo *model in souces){
        if ([MFMailComposeViewController canSendMail]) {
            NSString *extension = [[[model.path componentsSeparatedByString:@"."] lastObject] lowercaseString];
            mailer.mailComposeDelegate = self;
            NSData *attachmentData = nil;
            if([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"]){
                if ([extension isEqualToString:@"png"]) {
                    attachmentData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:model.path]);
                }else if ([extension isEqualToString:@"jpg"]) {
                    attachmentData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:model.path], 0.5);
                }
                [mailer addAttachmentData:attachmentData mimeType:[NSString stringWithFormat:@"image/%@",[extension isEqualToString:@"jpg"]?@"jpeg":extension] fileName: model.name];
                [mailer setMessageBody:[NSString stringWithString:[NSString stringWithFormat:@"Photo - %@", model.path]] isHTML:NO];
            }
            else{
                //添加一个视频
                NSData *video = [NSData dataWithContentsOfFile:model.path];
                [mailer addAttachmentData:video mimeType: @"video/mp4" fileName:model.name];
                [mailer setMessageBody:[NSString stringWithString:[NSString stringWithFormat:@"Video - %@", model.path]] isHTML:NO];
            }
            
            
        }else {
            
        }
   }
    
    [self presentViewController:mailer animated:YES completion:^{
        
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *msg = nil;
        if (error != NULL) {
            [TwsProgress showText:FORMAT(@"%d",(int)error.code)];
        }
        else{
            switch (result) {
                case MFMailComposeResultCancelled:
                    msg = @"用户取消编辑邮件";
                    break;
                case MFMailComposeResultSaved:
                    msg = @"用户成功保存邮件";
                    break;
                case MFMailComposeResultSent:
                    msg = @"Send success";
                    [TwsProgress showText:msg];
                    break;
                case MFMailComposeResultFailed:
                    msg = @"用户试图保存或者发送邮件失败";
                    break;
                default:
                    msg = @"";
                    break;
            }
        }
        LOG(@"%@",msg);
        
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.tableview.translatesAutoresizingMaskIntoConstraints = YES;
    self.viewToolbarBottom.translatesAutoresizingMaskIntoConstraints = YES;
    if(((UIView*)self.bottomLayoutGuide).frame.size.height > 0){
        self.viewToolbarBottom.frame = CGRectMake(self.viewToolbarBottom.frame.origin.x, self.viewToolbarBottom.frame.origin.y, self.viewToolbarBottom.frame.size.width, 94);
    }
}

-(void)toggleEditMode:(BOOL)reloadData{
    isEdit = !isEdit;
    self.navigationItem.rightBarButtonItem.title = isEdit?LOCALSTR(@"Done"):LOCALSTR(@"Edit");
    if(!isEdit){
        for(LocalPictureInfo *pic in self.originSourceList){
            pic.isChecked = NO;
        }
    }
    else{
//        self.tableview.translatesAutoresizingMaskIntoConstraints = YES;
//        self.viewToolbarBottom.translatesAutoresizingMaskIntoConstraints = YES;
    }
    if([self.viewToolbarBottom isHidden]){
        [self.viewToolbarBottom setHidden:NO];
    }
    if(isEdit){
        __block CGRect currentToolbarFrame = self.viewToolbarBottom.frame;
        __block CGRect currentTableFrame = self.tableview.frame;
        __weak typeof(self) weakSelf = self;
    
        [UIView animateWithDuration:0.5 animations:^{
            currentToolbarFrame.origin.y = self.view.frame.size.height - currentToolbarFrame.size.height;
            weakSelf.viewToolbarBottom.frame = currentToolbarFrame;
            currentTableFrame.size.height -= currentToolbarFrame.size.height;
            weakSelf.tableview.frame = currentTableFrame;
        }];
    }
    else{
        __block CGRect currentToolbarFrame = self.viewToolbarBottom.frame;
        __block CGRect currentTableFrame = self.tableview.frame;
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^{
             currentToolbarFrame.origin.y += 2*currentToolbarFrame.size.height;
            weakSelf.viewToolbarBottom.frame = currentToolbarFrame;
            currentTableFrame.size.height += currentToolbarFrame.size.height;
            weakSelf.tableview.frame = currentTableFrame;
        }];
    }
    if(reloadData){
        [self.tableview reloadData];
    }
}

-(void)setup{
//   NSMutableArray *pics = [GBase picturesForCamera:self.camera];
//   NSMutableArray *recordings = [GBase recordingsForCamera:self.camera];
    [self refresh];
 
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
    
}

-(void)refresh{
    _sourceList = nil;
    if(self.sourceList.count == 0){
        [_labCurrentDate.superview setHidden:YES];
    }
    else{
         [_labCurrentDate.superview setHidden:NO];
        [_labCurrentDate setText:((LocalPictureInfo*)(self.sourceList[0][0])).date];
        [_labCurrentDesc setText:((LocalPictureInfo*)(self.sourceList[0][0])).desc];
        _btnCurrentSelectAll.selected =((LocalPictureInfo*)(self.sourceList[0][0])).isChecked;
    }
    [self.tableview reloadData];
}

-(NSMutableArray *)sourceList{
    if(_sourceList == nil){
        _sourceList = [[NSMutableArray alloc] init];
        //图片
        if(self.segment_type.selectedSegmentIndex == 0){
            _originSourceList = [GBase picturesForCamera:self.camera];
            for (int i =0; i<_originSourceList.count; i++) {
                LocalPictureInfo *pic = _originSourceList[i];
                NSMutableArray *cellList = nil;
                if(_sourceList.count > 0){
                    cellList = _sourceList[_sourceList.count-1];
                    if(cellList.count == 0 || ![((LocalPictureInfo*)cellList[0]).date isEqualToString:pic.date]){
                        cellList = nil;
                    }
                }
                if(cellList == nil){
                   cellList =  [[NSMutableArray alloc] init];
                    [_sourceList addObject:cellList];
                }
                [cellList addObject:_originSourceList[i]];
            }
        }
        //录像
        else{
            _originSourceList = [GBase recordingsForCamera:self.camera];
            for (int i =0; i<_originSourceList.count; i++) {
                LocalVideoInfo *recording = _originSourceList[i];
                NSMutableArray *cellList = nil;
                if(_sourceList.count > 0){
                    cellList = _sourceList[_sourceList.count-1];
                    if(cellList.count == 0 || ![((LocalPictureInfo*)cellList[0]).date isEqualToString:recording.date]){
                        cellList = nil;
                    }
                }
                if(cellList == nil){
                    cellList =  [[NSMutableArray alloc] init];
                    [_sourceList addObject:cellList];
                }
                [cellList addObject:_originSourceList[i]];
            }
        }
    }
    return _sourceList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceList.count;
}
- (IBAction)clickTypeChange:(id)sender {
    if(isEdit){
        [self toggleEditMode:NO];
    }
    [self refresh];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSMutableArray *rowSouce = self.sourceList[indexPath.row];
    NSString *vid = @"tableviewCellImageCollectionItem";
    ImageCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
    LocalPictureInfo* model = rowSouce[0];
    cell.labDate.text = model.date;
    cell.labDesc.text = model.desc;
    cell.collectionImages.tag = indexPath.row;
    if(cell.collectionImages.delegate){
        [cell.collectionImages reloadData];
    }
    else{
        cell.collectionImages.delegate = self;
        cell.collectionImages.dataSource = self;
    }
    cell.btnSelectAll.tag = indexPath.row;
    [cell.btnSelectAll removeTarget:self action:@selector(clickSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnSelectAll addTarget:self action:@selector(clickSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnSelectAll setHidden:!isEdit];
    [_btnCurrentSelectAll setHidden:!isEdit];
    //[cell.labDate setHidden:indexPath.row %3!=0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *rowSouce = self.sourceList[indexPath.row];
    NSInteger column = 3;
    NSInteger row = ceil((float)rowSouce.count/column);
    CGFloat w = tableView.frame.size.width - 67;
    //itemw ＝ 总长度－缩进的宽度 － 列间距
    CGFloat itemw = ceil((w - OffLeft - OffRight - Offx*(column-1))/column);
    CGFloat itemh = itemw/self.camera.videoRatio;
    CGFloat height = Offy+( OffBottom + OffTop)*row + (row)*itemh +30;
    return height;
    //return indexPath.row%3 == 0?((indexPath.row+1)*160.0):(((indexPath.row+1)*160.0)+30);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([_tableview visibleCells].count>0&& [[[_tableview visibleCells] objectAtIndex:0] isKindOfClass:[ImageCollectionTableViewCell class]]){
        ImageCollectionTableViewCell* ec = (ImageCollectionTableViewCell*)[[_tableview visibleCells] objectAtIndex:0];
        //if(ec.labEventDate.text > _labCurrentEventDate.text){
        if([_labCurrentDate.superview isHidden]){
            [_labCurrentDate.superview setHidden:NO];
        }
        _labCurrentDate.text = ec.labDate.text;
        _labCurrentDesc.text = ec.labDesc.text;
        _btnCurrentSelectAll.selected = ec.btnSelectAll.selected;
        //        CGpoint contentPoint = tableView.contentOffset; //获取contentOffset的坐标(x,y)
        //        CGFloat x = tableView.contentOffset.x;  //获取contentOffset的x坐标
        //        CGFloat y = tableView.contentOffset.y;  //获取contentOffset的y坐标
        //[[tableView visibleCells] objectAtIndex:0]
        
        //}
    }
    else{
        [_labCurrentDate.superview setHidden:YES];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_labCurrentDate.superview isHidden]){
        if([tableView visibleCells].count>0&& [[[tableView visibleCells] objectAtIndex:0] isKindOfClass:[ImageCollectionTableViewCell class]]){
            ImageCollectionTableViewCell* ec = (ImageCollectionTableViewCell*)[[tableView visibleCells] objectAtIndex:0];
            [_labCurrentDate.superview setHidden:NO];
            _labCurrentDate.text = ec.labDate.text;
            _labCurrentDesc.text = ec.labDesc.text;
            _btnCurrentSelectAll.selected = ec.btnSelectAll.selected;
        }
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((NSMutableArray*)self.sourceList[collectionView.tag]).count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *rowSouce = self.sourceList[collectionView.tag];
    LocalPictureInfo* model = rowSouce[indexPath.row];
    NSString *vid = @"collectionviewCellImage";
    ImageCollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:vid forIndexPath:indexPath];
    [cell.imgThumb setImage:[UIImage imageWithContentsOfFile:model.thumbPath]];
    
    cell.btnMask.tag = [self.originSourceList indexOfObject:model];// collectionView.tag * 1000 + indexPath.row;
    cell.btnMask.selected = NO;
    if(isEdit){
        [cell.btnMask setBackgroundImage:[UIImage imageWithColor:Color_Primary_alpha_3 wihtSize:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [cell.btnMask setBackgroundImage:[UIImage imageWithColor:Color_Black_alpha_2 wihtSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [cell.btnMask setBackgroundImage:nil forState:UIControlStateHighlighted];
        [cell.btnMask setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
        [cell.btnMask setImage:[UIImage imageNamed:@"ic_selected"] forState:UIControlStateSelected];
        [cell.btnMask setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [cell.btnMask setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        for(UILongPressGestureRecognizer *ges  in cell.btnMask.gestureRecognizers){
            [cell.btnMask removeGestureRecognizer:ges];
        }
        cell.btnMask.selected = model.isChecked;
        //[cell.btnMask setContentMode:UIViewContentModeCenter];
    }
    else{
        [cell.btnMask setBackgroundImage:nil  forState:UIControlStateSelected];
        [cell.btnMask setBackgroundImage:nil forState:UIControlStateNormal];
        [cell.btnMask setBackgroundImage:[UIImage imageWithColor:Color_Black_alpha_3 wihtSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        [cell.btnMask setImage:nil forState:UIControlStateSelected];
        //图片
        if([model.path isEqualToString:model.thumbPath]){
            [cell.btnMask setImage:nil forState:UIControlStateNormal];
        }
        //视频
        else{
            [cell.btnMask setImage:[UIImage imageNamed:@"ic_menu_play"] forState:UIControlStateNormal];
        }
        [cell.btnMask setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [cell.btnMask setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        UILongPressGestureRecognizer *gestureLongpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        [cell.btnMask addGestureRecognizer:gestureLongpress];
    }
    [cell.btnMask removeTarget:self action:@selector(clickMask:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMask addTarget:self action:@selector(clickMask:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
      if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
          if(!isEdit){
              if([gestureRecognizer.view isKindOfClass:[UIButton class]]){
                  UIButton *btn = (UIButton *)gestureRecognizer.view;
                  ((LocalPictureInfo*)self.originSourceList[btn.tag]).isChecked = YES;
              }
              [self clickEdit:nil];
        }
    }
}
- (IBAction)clickMask:(UIButton*)sender {
    if(isEdit){
        sender.selected = !sender.selected;
        ((LocalPictureInfo*)(self.originSourceList[sender.tag])).isChecked = sender.selected;
    }
    else{
        self.selectPic = self.originSourceList[sender.tag];
        //点击图片
        if([self.selectPic isKindOfClass:[LocalVideoInfo class]]){
            _movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:self.selectPic.path]];
            [self presentMoviePlayerViewControllerAnimated:_movieController];
            [_movieController.moviePlayer play];
        }
        //点击视频
        else{
            [self performSegueWithIdentifier:@"ImageCollection2ShowImage" sender:self];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = 3;
    CGFloat w = collectionView.frame.size.width;
    //itemw ＝ 总长度－缩进的宽度 － 列间距
    CGFloat itemw =ceil((w - OffLeft - OffRight - Offx*(row-1))/row);
    CGFloat itemh = itemw/self.camera.videoRatio;
    return CGSizeMake(itemw, itemh);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectPic = self.sourceList[collectionView.tag][indexPath.row];
    [self performSegueWithIdentifier:@"ImageCollection2ShowImage" sender:self];
}

//其他界面返回到此界面调用的方法
- (IBAction)ImageCollectionViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[BaseViewController class]]){
        ShowImageViewController *controller= segue.destinationViewController;
        controller.camera = self.camera;
        controller.selectPic = self.selectPic;
        controller.images = _originSourceList;
    }
}
- (IBAction)clickShare:(id)sender {
}
- (IBAction)clickDelete:(id)sender {
    NSMutableArray *checkedSource = [[NSMutableArray alloc] init];
    for (LocalPictureInfo *pic in self.originSourceList) {
        if(pic.isChecked){
            [checkedSource addObject:pic];
        }
    }
    if(checkedSource.count>0){
        [TwsTools presentAlertTitle:self title:LOCALSTR(@"Warning") message:LOCALSTR(@"Are you sure to delete?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:LOCALSTR(@"OK") actionDefaultBlock:^{
            [self deletePicture:checkedSource];
            [self refresh];
        } defaultActionStyle:UIAlertActionStyleDestructive actionCancelTitle:LOCALSTR(@"Cancel") actionCancelBlock:nil];
    }
    else{
        if(_segment_type.selectedSegmentIndex == 0){
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"Please select the picture")];
        }
        else{
            [TwsTools presentAlertMsg:self message:LOCALSTR(@"Please select the video")];
        }
    }

}


- (void)deletePicture:(NSMutableArray*)sources {
    for (LocalPictureInfo *model in sources) {
        if (model.isChecked) {
            NSLog(@"model.imgPath:%@", model.path);
            if(_segment_type.selectedSegmentIndex == 0){
                [GBase deletePicture:self.camera name:model.name];
            }
            else{
                [GBase deleteRecording:model.name thumbPath:model.thumbName camera:self.camera];
            }
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.sourceList.count == 0){
        return 200.0;
    }
    else{
        return 0.1f;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     if(self.sourceList.count == 0){
         NSString *vid = @"tableviewcell_noimage";
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid];
         if([[cell.contentView.subviews objectAtIndex:0] isKindOfClass:[UIImageView class]]){
             UIImageView *imgV = [cell.contentView.subviews objectAtIndex:0];
             [imgV setImage:[UIImage imageNamed:(_segment_type.selectedSegmentIndex == 0? @"ic_photos" :@"ic_videos")] ];
         }
         if([[cell.contentView.subviews objectAtIndex:1] isKindOfClass:[UILabel class]]){
             UILabel *ilabV = [cell.contentView.subviews objectAtIndex:1];
             [ilabV setText:(_segment_type.selectedSegmentIndex == 0?LOCALSTR(@"No Photos") : LOCALSTR(@"No Videos"))];
         }
         return cell.contentView;
     }
     else{
         return nil;
     }
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
