//
//  EventListViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#define SEARCHEVENT_WAIT_TIMEOUT 18

#import "EventList_HichipViewController.h"
#import "EventItemTableViewCell.h"
#import "Event.h"
#import "EventCustomSearchSource.h"
#import "Playback_HichipViewController.h"
#import "EventSearchCustom_HichipViewController.h"
#import "ListReq.h"
#import "HichipCamera.h"
#import "TimeZoneModel.h"

@interface EventList_HichipViewController ()<EventCustomSearchDelegate>{
    BOOL isSearchingTimeout;
}
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture_outerView;
@property (weak, nonatomic) IBOutlet UILabel *labSearchTime;
@property (weak, nonatomic) IBOutlet UILabel *labCurrentEventDate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectSearchTime;
@property (weak, nonatomic) IBOutlet UISegmentedControl *swich_eventType;
@property (weak, nonatomic) IBOutlet UITableView *tableview_customSearchMenu;
@property (nonatomic,strong) NSMutableArray *event_list;
@property (nonatomic,strong) EventCustomSearchSource *searchMenu;
@property (nonatomic,copy) dispatch_block_t timeoutTask;
@property (nonatomic,strong) ListReq *listReq;
@property (nonatomic,strong) HichipCamera *originCamera;
@end

@implementation EventList_HichipViewController


-(EventCustomSearchSource*)searchMenu{
    if(!_searchMenu){
        _searchMenu = [[EventCustomSearchSource alloc] init];
    }
    return _searchMenu;
}
- (ListReq *)listReq {
    if (!_listReq) {
        _listReq = [[ListReq alloc] init];
    }
    return _listReq;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.originCamera = (HichipCamera*)self.camera.orginCamera;
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
            if(self.listReq.isSerach){
                self.listReq.isSerach = NO;
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
    if(!self.listReq.isSerach){
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
    cell.labEventType.text = [Event getHiEventTypeName:model.eventType];
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
        [cell.imgPlay setHidden:YES];
    }
    else{
        [cell.imgPlay setHidden:NO];
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
        EventSearchCustom_HichipViewController * controller = (EventSearchCustom_HichipViewController*) unwindSegue.sourceViewController;
        if(controller.dateTo&&controller.dateFrom){
            [self searchEventFrom:[controller.dateFrom timeIntervalSince1970] To:[controller.dateTo timeIntervalSince1970]];
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
    if(!self.listReq.isSerach){
        self.listReq.eventType =  sender.selectedSegmentIndex == 0 ? EVENT_ALARM : EVENT_PLAN;
        [self searchEventFrom:self.listReq.startTime To:self.listReq.stopTime];
    }
    else{
        [sender setSelectedSegmentIndex:abs((int)sender.selectedSegmentIndex - 1)];
    }
}
//首次打开搜索当天录像
-(void)beginSearch{
    NSDate *now = [NSDate date];
    NSDate *from = [TwsTools zeroOfDateTime:[NSDate date]];
    [self searchEventFrom:[from timeIntervalSince1970] To:[now timeIntervalSince1970]];
}

- (void)searchEventFrom:(NSTimeInterval)from  To:(NSTimeInterval) to {
    if(self.listReq.isSerach){
        return;
    }
    if(!self.camera.isAuthConnected){
        [[iToast makeText:LOCALSTR(@"connection dropped")] show];
        return;
    }
    int cmd = HI_P2P_PB_QUERY_START_NODST;
    // 能力集判断
    if ([self.camera getCommandFunction:cmd]) {
        NSLog(@"support_HI_P2P_PB_QUERY_START_NODST");
    } else {
        cmd = HI_P2P_PB_QUERY_START;
        if ([self.camera getCommandFunction:cmd]) {
            NSLog(@"support_HI_P2P_PB_QUERY_START");
        } else {
            NSLog(@"unsupport_HI_P2P_PB_QUERY_START");
            return;
        }
    }
    
    self.listReq.isSerach = true;
    isSearchingTimeout = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SEARCHEVENT_WAIT_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), [self newTimeoutTask]);
    [_labCurrentEventDate.superview setHidden:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].userInteractionEnabled = YES;
    //[MBProgressHUD showMessag:LOCALSTR(@"loading...") toView:self.tableview].userInteractionEnabled = YES;
    [self.event_list removeAllObjects];
    [self.tableview reloadData];
    
    self.listReq.startTime = from;
    self.listReq.stopTime = to;
    self.listReq.isSerach = YES;
    
    HI_P2P_S_PB_LIST_REQ *list_req = [self.listReq model];
    //判断摄像机是否在夏令时，在夏令时需调整搜索时间+1个小时
    long offset = 0;
    if(self.originCamera.zkGmTimeZone){
        for (int i = 0; i < [TimeZoneModel getAll].count; i++) {
            TimeZoneModel *model = [TimeZoneModel getAll][i];
            if([model.area isEqualToString:self.originCamera.zkGmTimeZone.timeName]){
                offset = model.timezone * 60 * 60;
                break;
            }
        }
    }
    else if(self.originCamera.gmTimeZone){
        offset = self.originCamera.gmTimeZone.model->s32TimeZone * 60 *60;
    }
    Boolean isInDaylight = NO;
    NSDate *dates = [NSDate date];
    if((self.originCamera.zkGmTimeZone && self.originCamera.zkGmTimeZone.dst == 1) || (self.originCamera.gmTimeZone && self.originCamera.gmTimeZone.u32DstMode == 1))
    {
        NSArray *names= [NSTimeZone knownTimeZoneNames];
        for (int i = 0; i < [names count]; i++) {
            
            NSTimeZone *nsTzTmp = [NSTimeZone timeZoneWithName:[names objectAtIndex:i]];
            if([nsTzTmp isDaylightSavingTime]){
                if([nsTzTmp secondsFromGMT] - [nsTzTmp daylightSavingTimeOffsetForDate:dates] == offset){
                    offset += 60*60;
                    isInDaylight = YES;
                    break;
                }
            }
        }
    }
    
    
    if(isInDaylight){
        list_req->sStartTime = [self.listReq getTimeDay:self.listReq.startTime + 60*60];
        list_req->sEndtime = [self.listReq getTimeDay:self.listReq.stopTime+60*60];
    }
    [self.camera sendIOCtrlToChannel:0 Type:cmd Data:(char*)list_req DataSize:sizeof(HI_P2P_S_PB_LIST_REQ)];
    NSLog(@"load TF card video list...%d/%d/%d -> %d/%d/%d",list_req->sStartTime.year, list_req->sStartTime.month, list_req->sStartTime.day,list_req->sEndtime.year, list_req->sEndtime.month, list_req->sEndtime.day);
    free(list_req);
    list_req = nil;
  
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    _labSearchTime.text = FORMAT(@"%@ - %@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.listReq.startTime]],[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.listReq.stopTime]]);
    //dropboxVideo.delegate = self;
}


#pragma mark - MyCameraDelegate Methods
- (void)camera:(BaseCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char *)data DataSize:(NSInteger)size
{
    if (type == HI_P2P_PB_QUERY_START_NODST || type == HI_P2P_PB_QUERY_START) {
        HI_P2P_S_PB_LIST_RESP* s = (HI_P2P_S_PB_LIST_RESP*)data;;
        
        if (s->count > 0) {
            for (int i = 0; i < s->count; i++) {
                HI_P2P_FILE_INFO saEvt = s->sFileInfo[i];
                double timeInMillis = [self getTimeInMillis:saEvt.sStartTime];
                NSLog(@"<<< Get Event(%d): %d/%d/%d %d:%2d:%2d (%f)", 0, saEvt.sStartTime.year, saEvt.sStartTime.month, saEvt.sStartTime.day, (int)saEvt.sStartTime.hour, (int)saEvt.sStartTime.minute, (int)saEvt.sStartTime.second, timeInMillis);
                Event *evt = [[Event alloc] initWithEventType:saEvt.EventType EventStartTime:[self getTimeInMillis:saEvt.sStartTime] EventEndTime:[self getTimeInMillis:saEvt.sEndTime] EventStatus:0];
                [self.event_list addObject:evt];
            }
        }
        
        if(s -> endflag == 1){
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
            self.listReq.isSerach = false;
            [self.tableview reloadData];
            if(_timeoutTask != nil){
                dispatch_block_cancel(_timeoutTask);
                _timeoutTask = nil;
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }
}

- (double)getTimeInMillis:(STimeDay)time {
    double result;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:time.year];
    [comps setMonth:time.month];
    [comps setWeekday:time.wday];
    [comps setDay:time.day];
    [comps setHour:time.hour];
    [comps setMinute:time.minute];
    [comps setSecond:time.second];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    [cal setLocale:[NSLocale currentLocale]];
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
        from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60)];
    }
    else if (index == 1) {
        from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60 * 12)];
        
    }
    else if (index == 2) {
        from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60 * 24)];
    }
    else if (index == 3) {
        from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60 * 24 * 7)];
    }
    [self searchEventFrom:[from timeIntervalSince1970] To:[now timeIntervalSince1970]];
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
                    if(self.camera.isAuthConnected){
                         if(self.listReq.isSerach){
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
        Playback_HichipViewController *controller = (Playback_HichipViewController*)segue.destinationViewController;
        controller.camera = self.camera;
        controller.evt = [self.event_list objectAtIndex:[self.tableview indexPathForSelectedRow].row];
        controller.needCreateSnapshot = [self.camera remoteRecordImage: controller.evt.eventTime type:controller.evt.eventType] == nil;
    }
}

-(void)showCustomSearchView{
    
    [self performSegueWithIdentifier:@"EventList2EventSearchCustom" sender:self];
    [self.searchMenu dismiss];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

*/

@end
