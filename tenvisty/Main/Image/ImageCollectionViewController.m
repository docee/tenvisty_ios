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
#define Offx        (5)
#define Offy        (5)
#define OffTop      (5)
#define OffBottom   (0)
#define OffLeft     (5)
#define OffRight    (5)

@interface ImageCollectionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labCurrentDate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    NSString *vid = @"tableviewCellImageCollectionItem";
    ImageCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
    cell.collectionImages.delegate = self;
    cell.collectionImages.dataSource = self;
    cell.labDate.text = [NSString stringWithFormat:@"12-%ld-2017",(long)indexPath.row];
    cell.collectionImages.tag = indexPath.row;
    //[cell.labDate setHidden:indexPath.row %3!=0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = 3;
    CGFloat w = self.view.frame.size.width - 32;
    //itemw ＝ 总长度－缩进的宽度 － 列间距
    CGFloat itemw = (w - OffLeft - OffRight - Offx*(row-1))/row;
    CGFloat itemh = itemw*9/16;
    return Offy*(indexPath.row) + OffBottom + OffTop + (indexPath.row +1)*itemh +40;
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (collectionView.tag +1)* 3;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *vid = @"collectionviewCellImage";
    ImageCollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:vid forIndexPath:indexPath];
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
    [self performSegueWithIdentifier:@"ImageCollection2ShowImage" sender:self];
}

//其他界面返回到此界面调用的方法
- (IBAction)ImageCollectionViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
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
