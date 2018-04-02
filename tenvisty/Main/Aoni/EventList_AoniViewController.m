//
//  EventListViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#define SEARCHEVENT_WAIT_TIMEOUT 18

#import "EventList_AoniViewController.h"
#import "EventItemTableViewCell.h"
#import "Event.h"
#import "EventCustomSearchSource.h"
#import "PlaybackViewController.h"
#import "EventSearchCustomViewController.h"
#import "ListEventReqModel.h"


@interface EventList_AoniViewController ()<EventCustomSearchDelegate>{
    BOOL isSearchingEvent;
    BOOL isSearchingTimeout;
}
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture_outerView;
@property (weak, nonatomic) IBOutlet UILabel *labSearchTime;
@property (weak, nonatomic) IBOutlet UILabel *labCurrentEventDate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectSearchTime;
@property (weak, nonatomic) IBOutlet UITableView *tableview_customSearchMenu;
@property (nonatomic,strong) NSMutableArray *event_list;
@property (nonatomic,strong) EventCustomSearchSource *searchMenu;
@property (nonatomic,copy) dispatch_block_t timeoutTask;
@property (nonatomic,strong) NSDate *toDate;
@property (nonatomic,strong) NSDate *fromDate;
@property (nonatomic, strong) NSMutableArray *listReq;
@end

@implementation EventList_AoniViewController


-(EventCustomSearchSource*)searchMenu{
    if(!_searchMenu){
        _searchMenu = [[EventCustomSearchSource alloc] init];
        _searchMenu.type = 1;
    }
    return _searchMenu;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

-(NSMutableArray *)event_list{
    if(!_event_list){
        _event_list = [[NSMutableArray alloc] init];
    }
    return _event_list;
}
-(NSMutableArray *)listReq{
    if(!_listReq){
        _listReq = [[NSMutableArray alloc] init];
    }
    return _listReq;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_labCurrentEventDate.superview setHidden:YES];
    [self.btnSelectSearchTime setBackgroundImage:[UIImage imageWithColor:Color_Gray_alpha wihtSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    self.searchMenu.delegate = self;
    self.tableview_customSearchMenu.delegate = self.searchMenu;
    self.tableview_customSearchMenu.dataSource = self.searchMenu;
    [self beginSearch];
}

-(dispatch_block_t)timeoutTask{
    if(_timeoutTask == nil){
        _timeoutTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            if(isSearchingEvent){
                isSearchingEvent = NO;
                isSearchingTimeout = YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[[iToast makeText:LOCALSTR(@"Connection timeout, please try again.")] setDuration:1] show];
                [self.tableview reloadData];
            }
        });
    }
    return _timeoutTask;
}
-(dispatch_block_t)newTimeoutTask{
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
    }
    _timeoutTask = nil;
    return self.timeoutTask;
}

- (IBAction)clickSearchMenu:(id)sender {
    if(!isSearchingEvent){
        BOOL isShow = [self.searchMenu toggleShow];
        [_tapGesture_outerView setEnabled:isShow];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_timeoutTask != nil){
        dispatch_block_cancel(_timeoutTask);
        _timeoutTask = nil;
    }
    [self.searchMenu dismiss];
    [_tapGesture_outerView setEnabled:NO];
}

-(void)click{
    NSLog(@"实现点击效果");
}
- (IBAction)tagOuterView:(id)sender {
    [self.searchMenu dismiss];
    [_tapGesture_outerView setEnabled:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    Event *model = [_event_list objectAtIndex:indexPath.row];
    NSString *vid = @"tableviewCellEventItem";
    EventItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:model.eventTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    cell.labEventDate.text = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    cell.labEventTime.text = [dateFormatter stringFromDate:date];
    [cell.labEventDate setHidden:!(indexPath.row == 0 || model.dateTimeInterval != ((Event*)[_event_list objectAtIndex:(indexPath.row-1)]).dateTimeInterval)];
    cell.labCameraName.text = self.camera.nickName;
    cell.labEventType.text = [Event getEventTypeName:model.eventType];
    if(![cell.labEventDate isHidden]){
        cell.constraint_centerY_img_eventTypeIcon.constant = 20;
    }
    else{
        cell.constraint_centerY_img_eventTypeIcon.constant = 0;
    }
    UIImage *thumb = [self.camera remoteRecordImage:model.eventTime type:model.eventType];
    //已读
    if(model.eventStatus == EVENT_READED || thumb != nil){
        //移动侦测
        if(model.eventType == AVIOCTRL_EVENT_MOTIONDECT){
            [cell.img_eventTypeIcon setImage: [UIImage imageNamed:@"ic_motion_detection_read"]];
        }
        else{
            [cell.img_eventTypeIcon setImage: [UIImage imageNamed:@"ic_time_record_read"]];
        }
    }
    else{
        if(model.eventType == AVIOCTRL_EVENT_MOTIONDECT){
            [cell.img_eventTypeIcon setImage: [UIImage imageNamed:@"ic_motion_detection_unread"]];
        }
        else{
            [cell.img_eventTypeIcon setImage: [UIImage imageNamed:@"ic_time_record_unread"]];
        }
    }
    
    if(thumb == nil){
        thumb = [UIImage imageNamed:@"view_event_record"];
    }
    [cell.imgEventThumb setImage:thumb];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.event_list.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_labCurrentEventDate.superview isHidden]){
        if([tableView visibleCells].count>0&& [[[tableView visibleCells] objectAtIndex:0] isKindOfClass:[EventItemTableViewCell class]]){
            EventItemTableViewCell* ec = (EventItemTableViewCell*)[[tableView visibleCells] objectAtIndex:0];
            [_labCurrentEventDate.superview setHidden:NO];
            _labCurrentEventDate.text = ec.labEventDate.text;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"EventList2Playback" sender:self];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//其他界面返回到此界面调用的方法
- (IBAction)EventListViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    if([unwindSegue.identifier isEqualToString:@"EventSearchCustomBack2EventList"]){
        EventSearchCustomViewController * controller = (EventSearchCustomViewController*) unwindSegue.sourceViewController;
        if(controller.dateTo&&controller.dateFrom){
            _fromDate = controller.dateFrom;
            _toDate = controller.dateTo;
            
            [self searchEventFrom:_fromDate To:_toDate];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([_tableview visibleCells].count>0&& [[[_tableview visibleCells] objectAtIndex:0] isKindOfClass:[EventItemTableViewCell class]]){
        EventItemTableViewCell* ec = (EventItemTableViewCell*)[[_tableview visibleCells] objectAtIndex:0];
        //if(ec.labEventDate.text > _labCurrentEventDate.text){
        if([_labCurrentEventDate.superview isHidden]){
            [_labCurrentEventDate.superview setHidden:NO];
        }
        _labCurrentEventDate.text = ec.labEventDate.text;
        //        CGpoint contentPoint = tableView.contentOffset; //获取contentOffset的坐标(x,y)
        //        CGFloat x = tableView.contentOffset.x;  //获取contentOffset的x坐标
        //        CGFloat y = tableView.contentOffset.y;  //获取contentOffset的y坐标
        //[[tableView visibleCells] objectAtIndex:0]
        
        //}
    }
    else{
        [_labCurrentEventDate.superview setHidden:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Event *model = [_event_list objectAtIndex:indexPath.row];
    if(!(indexPath.row == 0 || model.dateTimeInterval != ((Event*)[_event_list objectAtIndex:(indexPath.row-1)]).dateTimeInterval)){
        return 90.0;
    }
    else{
        return 130.0;
    }
}
- (IBAction)clickEventTypeChange:(UISegmentedControl *)sender {
    if(!isSearchingEvent){
        [self searchEventFrom:_fromDate To:_toDate];
    }
    else{
        [sender setSelectedSegmentIndex:abs((int)sender.selectedSegmentIndex - 1)];
    }
}
//首次打开搜索当天录像
-(void)beginSearch{
    NSDate *now = [NSDate date];
    NSDate *from = [TwsTools zeroOfDateTime:[NSDate date]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger intervalFrom = [zone secondsFromGMTForDate: from];
    from = [from  dateByAddingTimeInterval: intervalFrom];
    NSInteger intervalTo = [zone secondsFromGMTForDate: now];
    now = [now  dateByAddingTimeInterval: intervalTo];
    [self searchEventFrom:from To:now];
}

- (void)searchEventFrom:(NSDate*)from  To:(NSDate*) to {
    if(isSearchingEvent){
        return;
    }
    if(self.camera.cameraConnectState != CONNECTION_STATE_CONNECTED){
        [[iToast makeText:LOCALSTR(@"connection dropped")] show];
        return;
    }
    isSearchingEvent = true;
    isSearchingTimeout = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SEARCHEVENT_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    [_labCurrentEventDate.superview setHidden:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].userInteractionEnabled = YES;
    //[MBProgressHUD showMessag:LOCALSTR(@"loading...") toView:self.tableview].userInteractionEnabled = YES;
    [self.event_list removeAllObjects];
    [self.tableview reloadData];
   
    _fromDate = from;
    _toDate = to;
  
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    if([[formatter stringFromDate:_fromDate] isEqualToString:[formatter stringFromDate:_toDate]]){
        _labSearchTime.text = [formatter stringFromDate:_fromDate];
    }
    else{
        _labSearchTime.text = FORMAT(@"%@ - %@",[formatter stringFromDate:_fromDate],[formatter stringFromDate:_toDate]);
    }
    //dropboxVideo.delegate = self;
    [self doCreateSearchEventList:from To:to];
    [self doSearchEventList];
}

-(void)doCreateSearchEventList:(NSDate*)from  To:(NSDate*) to{
    [self.listReq removeAllObjects];

    while ([to timeIntervalSince1970] >= [from timeIntervalSince1970]) {
        NSCalendar *myCal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponentsFrom = [myCal componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:from];
        [dateComponentsFrom setHour:0];
        [dateComponentsFrom setMinute:0];
        [dateComponentsFrom setSecond:0];
        
        NSDateComponents *dateComponentsTo = [myCal componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:to];
        [dateComponentsTo setHour:0];
        [dateComponentsTo setMinute:0];
        [dateComponentsTo setSecond:0];
        
        ListEventReqModel *model = [[ListEventReqModel alloc] init];
        model.year = (int)[dateComponentsFrom year];
        model.month = (int)[dateComponentsFrom month];
        model.day = (int)[dateComponentsFrom day];
        model.type = 2;
        [self.listReq addObject:model];
        from = [NSDate dateWithTimeIntervalSince1970:[from timeIntervalSince1970] + 24*60*60];
    }
}

-(void)doSearchEventList{
    if([self.listReq count]>0){
        ListEventReqModel *model = (ListEventReqModel*)[self.listReq objectAtIndex:0];
        SMsgAVIoctrlListEventReq_Ausdom *req = [model model];
        [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_LISTEVENT_REQ Data:(char*)req DataSize:sizeof(SMsgAVIoctrlListEventReq_Ausdom)];
        free(req);
        req = nil;
        [self.listReq removeObject:model];
    }
}


#pragma mark - MyCameraDelegate Methods
- (void)camera:(BaseCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char *)data DataSize:(NSInteger)size
{
    if (type == IOTYPE_USER_IPCAM_LISTEVENT_RESP) {
        
        SMsgAVIoctrlListEventResp_Ausdom *s = (SMsgAVIoctrlListEventResp_Ausdom *)data ;
        
        if (s->count > 0) {
            for (int i = 0; i < s->count; i++) {
                SAvEvent_Ausdom saEvt = s->stEvent[i];
                //double timeInMillis = [self getTimeInMillis:saEvt.stTime];
                //NSLog(@"<<< Get Event(%d): %d/%d/%d %d:%2d:%2d (%f)", saEvt.status, saEvt.stTime.year, saEvt.stTime.month, saEvt.stTime.day, (int)saEvt.stTime.hour, (int)saEvt.stTime.minute, (int)saEvt.stTime.second, timeInMillis);
                Event *evt = [[Event alloc] initWithEventType:saEvt.event EventTime:[self getTimeInMillis:saEvt.stTime] EventStatus:1];
                [self.event_list addObject:evt];
            }
        }
        
        if(s -> endflag == 1){
            if(self.listReq.count > 0){
                [self doSearchEventList];
            }
            else{
                    [self.event_list sortUsingComparator:^NSComparisonResult(Event *obj1, Event  *obj2) {
                        return obj1.eventTime > obj2.eventTime?-1:(obj1.eventTime == obj2.eventTime?0:1);
                    }];
        //            for(int i=0;i<self.event_list.count;i++){
        //                Event* e1 = self.event_list[i];
        //                if(i==0 ||  e1.dateTimeInterval != ((Event*)self.event_list[i-1]).dateTimeInterval){
        //                    e1.isDateFirstItem = YES;
        //                }
        //                else{
        //                    e1.isDateFirstItem = NO;
        //                }
        //            }
                    isSearchingEvent = false;
                    [self.tableview reloadData];
                    if(_timeoutTask != nil){
                        dispatch_block_cancel(_timeoutTask);
                        _timeoutTask = nil;
                    }
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }
    }
}

- (double)getTimeInMillis:(TUTK_STimeDay)time {
    double result;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:time.year];
    [comps setMonth:time.month];
    [comps setDay:time.day];
    [comps setHour:time.hour];
    [comps setMinute:time.minute];
    [comps setSecond:time.second];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [cal setLocale:[NSLocale currentLocale]];
    NSDate *date = [cal dateFromComponents:comps];
    result = [date timeIntervalSince1970];
    return result;
}

-(void)didSelect:(NSInteger)index{
    if(index == 4){
        [self showCustomSearchView];
        return;
    }
    NSDate *now = [NSDate date];
    NSDate *from;
    
    if (index == 0) {
        from = [TwsTools zeroOfDateTime:[NSDate date]];
    }
    else if (index == 1) {
        from = [NSDate dateWithTimeIntervalSinceNow:- (24 * 60 * 60)];
       
    }
    else if (index == 2) {
         from = [NSDate dateWithTimeIntervalSinceNow:- (2 * 24 * 60 * 60)];
       
    }
    else if (index == 3) {
        from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60 * 24 * 6)];
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger intervalFrom = [zone secondsFromGMTForDate: from];
    from = [from  dateByAddingTimeInterval: intervalFrom];
    NSInteger intervalTo = [zone secondsFromGMTForDate: now];
    now = [now  dateByAddingTimeInterval: intervalTo];
    [self searchEventFrom:from To:now];
    [self.searchMenu toggleShow];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.event_list.count == 0){
        return 50.0f;
    }
    else{
        return 0.1f;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.event_list.count == 0){
        NSString *vid = @"tableviewCellSearchEventProcess";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid];
            for(UIView *view in cell.contentView.subviews){
                if([view isKindOfClass:[UILabel class]]){
                    UILabel *labDesc = (UILabel*)view;
                    if(self.camera.cameraConnectState == CONNECTION_STATE_CONNECTED){
                         if(isSearchingEvent){
                             labDesc.text = LOCALSTR(@"loading...");
                         }
                         else if(isSearchingTimeout){
                             labDesc.text = LOCALSTR(@"Connection timeout");
                         }
                        else{
                             labDesc.text = LOCALSTR(@"No result found.");
                         }
                    }
                    else{
                        labDesc.text = LOCALSTR(@"Camera offline");
                    }
            }
        }
        return cell.contentView;
    }
    else{
        return nil;
    }
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EventList2Playback"]){
        PlaybackViewController *controller = (PlaybackViewController*)segue.destinationViewController;
        controller.camera = self.camera;
        controller.evt = [self.event_list objectAtIndex:[self.tableview indexPathForSelectedRow].row];
        controller.needCreateSnapshot = [self.camera remoteRecordImage: controller.evt.eventTime type:controller.evt.eventType] == nil;
    }
    else if([segue.identifier isEqualToString:@"EventList2EventSearchCustom"]){
        EventSearchCustomViewController *controller = (EventSearchCustomViewController*)segue.destinationViewController;
        controller.mode = UIDatePickerModeDate;
    }
}

-(void)showCustomSearchView{
    //UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboard_view_eventsearchcustom"];
//    controller.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:controller animated:YES completion:nil];

    
    [self performSegueWithIdentifier:@"EventList2EventSearchCustom" sender:self];
    [self.searchMenu dismiss];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Search Event\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UILabel *labFrom = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, alert.view.frame.size.width -10, 20)];
//    labFrom.text = LOCALSTR(@"From");
//    labFrom.textAlignment = NSTextAlignmentLeft;
//    labFrom.numberOfLines = 1;
//    labFrom.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
//
//    UIDatePicker *datePickerFrom = [[UIDatePicker alloc] init];
//    datePickerFrom.datePickerMode = UIDatePickerModeDateAndTime;
//    datePickerFrom.frame = CGRectMake(0, 55, 250, 150);
//    [alert.view addSubview:labFrom];
//    [alert.view addSubview:datePickerFrom];
//
//    //[[[NSBundle mainBundle] loadNibNamed:@"EventSearchCustom" owner:self options:nil] lastObject]
//    //datePicker.frame = CGRectMake(0, 50, Screen_Main.width*0.6, 120);
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//        //实例化一个NSDateFormatter对象
//        //[dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
//       // NSString *dateString = [dateFormat stringFromDate:datePicker.date];
//        //求出当天的时间字符串
//        NSLog(@"%@",@"11");
//    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { }];
//    [alert addAction:ok];
//    [alert addAction:cancel];
//    [self presentViewController:alert animated:YES completion:^{ }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

*/

@end
