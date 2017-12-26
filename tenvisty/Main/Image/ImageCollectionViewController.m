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

#define Offx        (5)
#define Offy        (5)
#define OffTop      (5)
#define OffBottom   (0)
#define OffLeft     (5)
#define OffRight    (5)

@interface ImageCollectionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labCurrentDate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_type;
@property (nonatomic,strong) NSMutableArray *sourceList;

@property (nonatomic,strong) LocalPictureInfo *selectPic;

@end

@implementation ImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        [_labCurrentDate setHidden:YES];
    }
    else{
         [_labCurrentDate setHidden:NO];
        [_labCurrentDate setText:((LocalPictureInfo*)(self.sourceList[0][0])).date];
    }
    [self.tableview reloadData];
}

-(NSMutableArray *)sourceList{
    if(_sourceList == nil){
        _sourceList = [[NSMutableArray alloc] init];
        //图片
        if(self.segment_type.selectedSegmentIndex == 0){
            NSMutableArray *pics = [GBase picturesForCamera:self.camera];
            for (int i =0; i<pics.count; i++) {
                LocalPictureInfo *pic = pics[i];
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
                [cellList addObject:pics[i]];
            }
        }
        //录像
        else{
            NSMutableArray *recordings = [GBase recordingsForCamera:self.camera];
            for (int i =0; i<recordings.count; i++) {
                LocalVideoInfo *recording = [recordings objectAtIndex:i];
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
                [cellList addObject:recordings[i]];
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
    cell.collectionImages.tag = indexPath.row;
    if(cell.collectionImages.delegate){
        [cell.collectionImages reloadData];
    }
    else{
        cell.collectionImages.delegate = self;
        cell.collectionImages.dataSource = self;
    }
    //[cell.labDate setHidden:indexPath.row %3!=0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *rowSouce = self.sourceList[indexPath.row];
    NSInteger column = 3;
    NSInteger row = ceil((float)rowSouce.count/column);
    CGFloat w = self.view.frame.size.width - 47;
    //itemw ＝ 总长度－缩进的宽度 － 列间距
    CGFloat itemw = (w - OffLeft - OffRight - Offx*(column-1))/column;
    CGFloat itemh = itemw*9/16;
    return Offy*row + OffBottom + OffTop + (row)*itemh + 80 + 10;
    //return indexPath.row%3 == 0?((indexPath.row+1)*160.0):(((indexPath.row+1)*160.0)+30);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([_tableview visibleCells].count>0&& [[[_tableview visibleCells] objectAtIndex:0] isKindOfClass:[ImageCollectionTableViewCell class]]){
        ImageCollectionTableViewCell* ec = (ImageCollectionTableViewCell*)[[_tableview visibleCells] objectAtIndex:0];
        //if(ec.labEventDate.text > _labCurrentEventDate.text){
        if([_labCurrentDate isHidden]){
            [_labCurrentDate setHidden:NO];
        }
        _labCurrentDate.text = ec.labDate.text;
        //        CGpoint contentPoint = tableView.contentOffset; //获取contentOffset的坐标(x,y)
        //        CGFloat x = tableView.contentOffset.x;  //获取contentOffset的x坐标
        //        CGFloat y = tableView.contentOffset.y;  //获取contentOffset的y坐标
        //[[tableView visibleCells] objectAtIndex:0]
        
        //}
    }
    else{
        [_labCurrentDate setHidden:YES];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_labCurrentDate isHidden]){
        if([tableView visibleCells].count>0&& [[[tableView visibleCells] objectAtIndex:0] isKindOfClass:[ImageCollectionTableViewCell class]]){
            ImageCollectionTableViewCell* ec = (ImageCollectionTableViewCell*)[[tableView visibleCells] objectAtIndex:0];
            [_labCurrentDate setHidden:NO];
            _labCurrentDate.text = ec.labDate.text;
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
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = 3;
    CGFloat w = collectionView.frame.size.width;
    //itemw ＝ 总长度－缩进的宽度 － 列间距
    CGFloat itemw = (w - OffLeft - OffRight - Offx*(row-1))/row;
    CGFloat itemh = itemw*9/16;
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
