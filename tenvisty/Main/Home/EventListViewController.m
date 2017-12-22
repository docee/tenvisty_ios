//
//  EventListViewController.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "EventListViewController.h"
#import "EventItemTableViewCell.h"
#import "Event.h"

@interface EventListViewController (){
    BOOL isSearchingEvent;
    NSDate *nowDate;
    NSDate *pastDate;
}
@property (weak, nonatomic) IBOutlet UILabel *labSearchTime;
@property (weak, nonatomic) IBOutlet UILabel *labCurrentEventDate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectSearchTime;
@property (weak, nonatomic) IBOutlet UISegmentedControl *swich_eventType;
@property (nonatomic,strong) NSMutableArray *event_list;
@end

@implementation EventListViewController

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
    
    [_labCurrentEventDate setHidden:YES];
    [self.btnSelectSearchTime setBackgroundImage:[EventListViewController imageWithColor:Color_Gray_alpha] forState:UIControlStateHighlighted];
}
#pragma mark - ActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDate *now = [NSDate date];
    NSDate *from;
    
    if (buttonIndex == 0) {
        
        from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60)];
        
        [self searchEventFrom:now To:from];
    }
    else if (buttonIndex == 1) {
        
        from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60 * 12)];
        [self searchEventFrom:now To:from];    }
    else if (buttonIndex == 2) {
        
        from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60 * 24)];
        [self searchEventFrom:now To:from];
    }
    else if (buttonIndex == 3) {
        
        from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60 * 24 * 7)];
        [self searchEventFrom:now To:from];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)click{
    NSLog(@"实现点击效果");
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath*)indexPath
{
    Event *model = [_event_list objectAtIndex:indexPath.row];
    NSString *vid = @"tableviewCellEventItem";
    EventItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vid forIndexPath:indexPath];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:model.eventTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    cell.labEventDate.text = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    cell.labEventTime.text = [dateFormatter stringFromDate:date];
    [cell.labEventDate setHidden:!model.isDateFirstItem];
    cell.labCameraName.text = self.camera.nickName;
    cell.labEventType.text = [Event getEventTypeName:model.eventType];
    if(model.isDateFirstItem){
        cell.constraint_centerY_img_eventTypeIcon.constant = 20;
    }
    else{
        cell.constraint_centerY_img_eventTypeIcon.constant = 0;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.event_list.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_labCurrentEventDate isHidden]){
        if([tableView visibleCells].count>0&& [[[tableView visibleCells] objectAtIndex:0] isKindOfClass:[EventItemTableViewCell class]]){
            EventItemTableViewCell* ec = (EventItemTableViewCell*)[[tableView visibleCells] objectAtIndex:0];
            [_labCurrentEventDate setHidden:NO];
            _labCurrentEventDate.text = ec.labEventDate.text;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSegueWithIdentifier:@"EventList2Playback" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//其他界面返回到此界面调用的方法
- (IBAction)EventListViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([_tableview visibleCells].count>0&& [[[_tableview visibleCells] objectAtIndex:0] isKindOfClass:[EventItemTableViewCell class]]){
        EventItemTableViewCell* ec = (EventItemTableViewCell*)[[_tableview visibleCells] objectAtIndex:0];
        //if(ec.labEventDate.text > _labCurrentEventDate.text){
        if([_labCurrentEventDate isHidden]){
            [_labCurrentEventDate setHidden:NO];
        }
        _labCurrentEventDate.text = ec.labEventDate.text;
        //        CGpoint contentPoint = tableView.contentOffset; //获取contentOffset的坐标(x,y)
        //        CGFloat x = tableView.contentOffset.x;  //获取contentOffset的x坐标
        //        CGFloat y = tableView.contentOffset.y;  //获取contentOffset的y坐标
        //[[tableView visibleCells] objectAtIndex:0]
        
        //}
    }
    else{
        [_labCurrentEventDate setHidden:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row%3 == 0?130.0:90.0;
}
- (IBAction)clickEventTypeChange:(UISegmentedControl *)sender {
    [self beginSearch];
}

-(void)beginSearch{
    NSDate *now = [NSDate date];
    NSDate *from = [NSDate dateWithTimeIntervalSinceNow:- (60 * 60 * 24)];
    [self searchEventFrom:[now timeIntervalSince1970] To:[from timeIntervalSince1970]];
}

- (void)searchEventFrom:(long) now To:(long) past {
    if(isSearchingEvent){
        return;
    }
    [MBProgressHUD showMessag:LOCALSTR(@"loading...") toView:self.tableview];
    [self.event_list removeAllObjects];
    [self.tableview reloadData];
    STimeDay start, stop;
    start = [Event getTimeDay:past];
    stop = [Event getTimeDay:now];
    
    isSearchingEvent = true;
    
    SMsgAVIoctrlListEventReq *req = (SMsgAVIoctrlListEventReq *) malloc(sizeof(SMsgAVIoctrlListEventReq));
    memset(req, 0, sizeof(SMsgAVIoctrlListEventReq));
    
    req->channel = 0;
    req->event = _swich_eventType.selectedSegmentIndex == 0?1:0;
    req->stStartTime = start;
    req->stEndTime = stop;
    
    //[searchButton setEnabled:NO];
    [self.camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_LISTEVENT_REQ Data:(char *)req DataSize:sizeof(SMsgAVIoctrlListEventReq)];
    
    free(req);
    NSLog(@"load TF card video list...%d/%d/%d -> %d/%d/%d", start.year, start.month, start.day,stop.year, stop.month, stop.day);
    nowDate = [[NSDate alloc] initWithTimeIntervalSince1970:now];
    pastDate = [[NSDate alloc] initWithTimeIntervalSince1970:past];
    //dropboxVideo.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        if (isSearchingEvent) {
            
        }
    });
}


#pragma mark - MyCameraDelegate Methods
- (void)camera:(MyCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char *)data DataSize:(NSInteger)size
{
    if (type == IOTYPE_USER_IPCAM_LISTEVENT_RESP) {
        
        SMsgAVIoctrlListEventResp *s = (SMsgAVIoctrlListEventResp *)data ;
        
        if (s->count > 0) {
            for (int i = 0; i < s->count; i++) {
                SAvEvent saEvt = s->stEvent[i];
                double timeInMillis = [self getTimeInMillis:saEvt.stTime];
                NSLog(@"<<< Get Event(%d): %d/%d/%d %d:%2d:%2d (%f)", saEvt.status, saEvt.stTime.year, saEvt.stTime.month, saEvt.stTime.day, (int)saEvt.stTime.hour, (int)saEvt.stTime.minute, (int)saEvt.stTime.second, timeInMillis);
                Event *evt = [[Event alloc] initWithEventType:saEvt.event EventTime:[self getTimeInMillis:saEvt.stTime] EventStatus:saEvt.status];
                if(self.event_list.count == 0){
                    evt.isDateFirstItem = YES;
                }
                else{
                    Event *lastEvt =[self.event_list objectAtIndex:self.event_list.count-1];
                    evt.isDateFirstItem = lastEvt.dateTimeInterval != evt.dateTimeInterval;
                }
                [self.event_list addObject:evt];
            }
        }
        
        if(s -> endflag == 1){
            isSearchingEvent = false;
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            [self.tableview reloadData];
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
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [cal setLocale:[NSLocale currentLocale]];
    NSDate *date = [cal dateFromComponents:comps];
    result = [date timeIntervalSince1970];
    return result;
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
