//
//  TImingRecordSchedule_HichipViewController.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/5.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "TimingRecordSchedule_HichipViewController.h"
#import "TwsTableViewCell.h"
#import "SelectTime.h"

@interface TimingRecordSchedule_HichipViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSArray *listItems;
@end

@implementation TimingRecordSchedule_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.type == 2){
        [self setCustomTime];
    }
    [self.view setBackgroundColor:Color_GrayLightest];
    [self.tableview setBackgroundColor:Color_GrayLightest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)listItems{
    if(!_listItems){
        ListImgTableViewCellModel *noneMode = [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"OFF") showValue:NO value:nil];
        noneMode.viewId = TableViewCell_SelectItem_Detail;
        noneMode.desc = LOCALSTR(@"Device will stop recording on SD Card");
        noneMode.descDetail = @"OFF";
        ListImgTableViewCellModel *fulldayMode = [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"ALL DAY") showValue:NO value:nil];
        fulldayMode.viewId = TableViewCell_SelectItem_Detail;
        fulldayMode.desc = LOCALSTR(@"24/7 Continous Record");
        fulldayMode.descDetail = @"00:00 - 24:00";
        ListImgTableViewCellModel *customMode = [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"CUSTOM SETTING") showValue:NO value:nil];
        customMode.viewId = TableViewCell_SelectItem_Detail;
        customMode.desc = LOCALSTR(@"Set your own recording time");
        customMode.descDetail = @"00:00 - 00:00";
        
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         noneMode,
                         fulldayMode,
                         customMode, nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
        ((ListImgTableViewCellModel*)_listItems[0][self.type]).titleValue = @"1";
    }
    return _listItems;
}

-(void)setSelect:(NSInteger)index{
    for(int i=0;i< ((NSArray*)self.listItems[0]).count;i++){
        ListImgTableViewCellModel *m = self.listItems[0][i];
        if(index == i){
            m.titleValue = @"1";
        }
        else{
            m.titleValue = nil;
        }
    }
    [self.tableview reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.type = indexPath.row;
    [self setSelect:indexPath.row];
    if(indexPath.row == 2){
        [SelectTime sharedInstance].okBlock = ^(NSDate *fromTime,NSDate * toTime){
            self.fromTime = fromTime;
            self.toTime = toTime;
            [self setCustomTime];
            [self.tableview reloadData];
            [self performSegueWithIdentifier:@"unwind_TimingRecordSchedule2TimingRecord" sender:self];
        };
        [SelectTime show:_fromTime toTime:_toTime];
    }
    else{
        [self performSegueWithIdentifier:@"unwind_TimingRecordSchedule2TimingRecord" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)setCustomTime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strToTime = [dateFormatter stringFromDate:_toTime];
//    if([strToTime isEqualToString:@"00:00"]){
//        strToTime = @"24:00";
//    }
    ((ListImgTableViewCellModel*)self.listItems[0][2]).descDetail = [NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:_fromTime],strToTime];
}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
//{
//    TwsTableViewCell *cell = (TwsTableViewCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
//
//    return cell;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
