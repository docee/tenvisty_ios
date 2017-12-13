//
//  TimeRecordViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/4.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "TimeScheduleViewController.h"
#import "SelectTime.h"

@interface TimeScheduleViewController ()
@property (nonatomic, strong) UILabel *labOffTitle;
@property (nonatomic, strong) UILabel *labOffDesc;
@property (nonatomic, strong) UILabel *labAllDayTitle;
@property (nonatomic, strong) UILabel *labAllDayDesc;
@property (nonatomic, strong) UILabel *labCustomTitle;
@property (nonatomic, strong) UILabel *labCustomDesc;
@property (nonatomic, strong) UILabel *labCustomTime;
@property (nonatomic, strong) UIView *viewSelectedBg;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *descs;
@end

@implementation TimeScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rbtnItem = [[UIBarButtonItem alloc] initWithTitle:LOCALSTR(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(rbtnItemAction:)];
    self.navigationItem.rightBarButtonItem = rbtnItem;
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rbtnItemAction:(id)sender {
    NSLog(@"Done");
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSetSchedule:fromTime:toTime:)]) {
        [self.delegate didSetSchedule:_type fromTime:_fromTime toTime:_toTime];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"TimeRecordCellID";
    TwsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TwsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger row = indexPath.row;
    
//    cell.textLabel.text = [self.descs objectAtIndex:row];
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (row == 0) {
        
        [cell.contentView addSubview:self.labOffTitle];
        self.labOffTitle.text = [self.titles objectAtIndex:row];
        [cell.contentView addSubview:self.labOffDesc];
        self.labOffDesc.text = [self.descs objectAtIndex:row];
    }
    
    if (row == 1) {
        
        [cell.contentView addSubview:self.labAllDayTitle];
        self.labAllDayTitle.text = [self.titles objectAtIndex:row];
        [cell.contentView addSubview:self.labAllDayDesc];
        self.labAllDayDesc.text = [self.descs objectAtIndex:row];
    }
    
    if (row == 2) {
        [cell.contentView addSubview:self.labCustomTitle];
        self.labCustomTitle.text = [self.titles objectAtIndex:row];
        [cell.contentView addSubview:self.labCustomDesc];
        self.labCustomDesc.text = [self.descs objectAtIndex:row];
        [cell.contentView addSubview:self.labCustomTime];
        [self setCustomTime];
        
    }
    if(row == _type){
        [self setSelect:cell];
        //[cell setBackgroundView:_viewSelectedBg];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.view.frame.size.height - 50 )/3 ;
}



- (UILabel *)labOffTitle {
    if (!_labOffTitle) {
        
        CGFloat tx = 15.0f;
        CGFloat tw = [UIScreen mainScreen].bounds.size.width-2*tx - 100;
        CGFloat th = 44.0f;
        CGFloat ty = 15.0f;
        
        _labOffTitle = [[UILabel alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
        [_labOffTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        _labOffTitle.numberOfLines = 0;
        _labOffTitle.lineBreakMode = NSLineBreakByTruncatingMiddle;
        //_labRedTime.adjustsFontSizeToFitWidth = YES;
    }
    return _labOffTitle;
}
- (UILabel *)labOffDesc {
    if (!_labOffDesc) {
        
        CGFloat tx = 15.0f;
        CGFloat tw = [UIScreen mainScreen].bounds.size.width-2*tx - 100;
        CGFloat th = 44.0f;
        CGFloat ty = 60.0f;
        
        _labOffDesc = [[UILabel alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
        _labOffDesc.font = [UIFont systemFontOfSize:14];
        _labOffDesc.numberOfLines = 0;
        _labOffDesc.lineBreakMode = NSLineBreakByTruncatingMiddle;
        //_labRedTime.adjustsFontSizeToFitWidth = YES;
    }
    return _labOffDesc;
}

- (UILabel *)labAllDayTitle {
    if (!_labAllDayTitle) {
        
        CGFloat tx = 15.0f;
        CGFloat tw = [UIScreen mainScreen].bounds.size.width-2*tx - 100;
        CGFloat th = 44.0f;
        CGFloat ty = 15.0f;
        
        _labAllDayTitle = [[UILabel alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
        [_labAllDayTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        _labAllDayTitle.numberOfLines = 0;
        _labAllDayTitle.lineBreakMode = NSLineBreakByTruncatingMiddle;
        //_labRedTime.adjustsFontSizeToFitWidth = YES;
    }
    return _labAllDayTitle;
}

- (UILabel *)labAllDayDesc {
    if (!_labAllDayDesc) {
        
        CGFloat tx = 15.0f;
        CGFloat tw = [UIScreen mainScreen].bounds.size.width-2*tx - 100;
        CGFloat th = 44.0f;
        CGFloat ty = 60.0f;

        
        _labAllDayDesc = [[UILabel alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
        _labAllDayDesc.font = [UIFont systemFontOfSize:14];
        _labAllDayDesc.numberOfLines = 0;
        _labAllDayDesc.lineBreakMode = NSLineBreakByTruncatingMiddle;
        //_labRedTime.adjustsFontSizeToFitWidth = YES;
    }
    return _labAllDayDesc;
}

- (UILabel *)labCustomTitle {
    if (!_labCustomTitle) {
        
        CGFloat tx = 15.0f;
        CGFloat tw = [UIScreen mainScreen].bounds.size.width-2*tx - 100;
        CGFloat th = 44.0f;
        CGFloat ty = 15.0f;
        
        _labCustomTitle = [[UILabel alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
        [_labCustomTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        //_labRedTime.adjustsFontSizeToFitWidth = YES;
    }
    return _labCustomTitle;
}

- (UILabel *)labCustomDesc {
    if (!_labCustomDesc) {
        
        CGFloat tx = 15.0f;
        CGFloat tw = [UIScreen mainScreen].bounds.size.width - 2*tx - 100;
        CGFloat th = 44.0f;
        CGFloat ty = 60.0f;
        
        _labCustomDesc = [[UILabel alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
        _labCustomDesc.font = [UIFont systemFontOfSize:14];
        _labCustomDesc.numberOfLines = 0;
        _labCustomDesc.lineBreakMode = NSLineBreakByTruncatingMiddle;
        //_labRedTime.adjustsFontSizeToFitWidth = YES;
    }
    return _labCustomDesc;
}
- (UILabel *)labCustomTime {
    if (!_labCustomTime) {
        
        CGFloat tw = 100;
        CGFloat th = 44.0f;
        CGFloat tx = [UIScreen mainScreen].bounds.size.width- 15 - tw;
        
        _labCustomTime = [[UILabel alloc] initWithFrame:CGRectMake(tx, 0, tw, th)];
        _labCustomTime.font = [UIFont systemFontOfSize:14];
        [_labCustomTime setTextColor:[UIColor lightGrayColor]];
        //_labRedTime.adjustsFontSizeToFitWidth = YES;
    }
    return _labCustomTime;
}
- (UIView *)viewSelectedBg {
    if (!_viewSelectedBg) {
        
        CGFloat tw = self.view.frame.size.width;
        CGFloat th = (self.view.frame.size.height - 50 )/3;
        CGFloat tx = 0;
        CGFloat ty = 0;
        UIImageView *imgViewSelected = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50 - 50/2, ((self.view.frame.size.height - 100 )/3 - 50)/2, 50, 50)];
        imgViewSelected.image = [UIImage imageNamed:@"tws_status_selected"];

        _viewSelectedBg = [[UIView alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
        [_viewSelectedBg setBackgroundColor:Color_Item_Selected_BG];
        [_viewSelectedBg addSubview:imgViewSelected];
        
    }
    return _viewSelectedBg;
}




- (NSArray *)titles {
    if (!_titles) {
        _titles = @[LOCALSTR(@"NONE"), LOCALSTR(@"ALL DAY"), LOCALSTR(@"CUSTOM SETTING")];
    }
    return _titles;
}
- (NSArray *)descs {
    if (!_descs) {
        _descs = @[LOCALSTR(@"Device will stop recording on SD Card"), LOCALSTR(@"24/7 Continous Record"), LOCALSTR(@"Set your own recording time")];
    }
    return _descs;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _type = indexPath.row;

    [self setSelect:tableView row:indexPath.row];
    if(indexPath.row == 2){
        __weak typeof(self) weakSelf = self;
        
        [SelectTime sharedInstance].okBlock = ^(NSDate *fromTime,NSDate * toTime){
            weakSelf.fromTime = fromTime;
            weakSelf.toTime = toTime;
            [weakSelf setCustomTime];
        };
        [SelectTime show:_fromTime toTime:_toTime];
    }
}

-(void)setSelect:(UITableView *)tableView row:(NSInteger)row{
    for(int i = 0; i < 3 ;i++){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        //        if(i == indexPath.row){
        //            [cell setBackgroundView:[self viewSelectedBg]];
        //        }
        //        else{
        [cell setBackgroundView:nil];
        //}
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell setBackgroundView:[self viewSelectedBg]];
}

-(void)setSelect:(TwsCell *)cell{
    [cell setBackgroundView:[self viewSelectedBg]];
}

-(void)setCustomTime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    self.labCustomTime.text = [NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:_fromTime],[dateFormatter stringFromDate:_toTime]];
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
