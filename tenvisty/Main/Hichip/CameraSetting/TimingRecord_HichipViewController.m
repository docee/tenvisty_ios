//
//  TimingRecord_HichipViewController.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/5.
//  Copyright © 2018年 Tenvis. All rights reserved.
//


#import "TimingRecord_HichipViewController.h"
#import "TimeScheduleViewController.h"
#import "RecAutoParam.h"
#import "QuantumTime.h"
#import "HichipCamera.h"
#import "TimingRecordSchedule_HichipViewController.h"

@interface TimingRecord_HichipViewController ()<CellModelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSArray *listItems;
@property (nonatomic, strong) __block RecAutoParam *recAutoParam;
@property (nonatomic, strong) __block QuantumTime *quantumTime;
@property (nonatomic,assign) NSInteger autoRecTimeMin;
@property (nonatomic,assign) NSInteger autoRecTimeMax;

@end

@implementation TimingRecord_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

-(void)setup{
    self.autoRecTimeMin = 15;
    self.autoRecTimeMax = [((HichipCamera*)self.camera.orginCamera) isGoke]?600:900;
    [self.tableview setBackgroundColor:Color_GrayLightless];
    [self.view setBackgroundColor:Color_GrayLightless];
    [self doGetAutoRecordPara];
    [self doGetAutoRecordSchedule];
}

-(void)doGetAutoRecordPara{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_REC_AUTO_PARAM Data:(char*)nil DataSize:0];
}

-(void)doGetAutoRecordSchedule{
      [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_REC_AUTO_SCHEDULE Data:(char*)nil DataSize:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickSave:(id)sender {
}

-(NSArray *)listItems{
    if(!_listItems){
        ListImgTableViewCellModel *videoTimeModel = [ListImgTableViewCellModel initObj:LOCALSTR(@"Video Time") value:nil placeHodler:nil maxLength:63 viewId:TableViewCell_Button_HyperLink];
        ListImgTableViewCellModel *durationModel = [ListImgTableViewCellModel initObj:LOCALSTR(@"Duration") value:@"" placeHodler: FORMAT(@"%ld - %ld",(long)self.autoRecTimeMin,self.autoRecTimeMax) maxLength:3 viewId:TableViewCell_TextField_Normal];
        durationModel.rightDesc = LOCALSTR(@"seconds");
        videoTimeModel.delegate = self;
        videoTimeModel.showValue = YES;
        durationModel.textAlignment = NSTextAlignmentRight;
        durationModel.textFilter = REGEX_NUMBER;
        NSArray *sec1 = [[NSArray alloc] initWithObjects: durationModel, videoTimeModel, nil];
       
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}

-(void)refreshTable{
    if(self.recAutoParam){
        [self setRowValue:FORMAT(@"%d",self.recAutoParam.u32FileLen)  row:0 section:0];
    }
    if(self.quantumTime){
        [self setRowValue:self.quantumTime.desc  row:1 section:0];
    }
    [self.tableview reloadData];
}


-(void)reloadParasFromTable{
    if(self.recAutoParam){
        self.recAutoParam.u32FileLen = [[self getRowValue:0 section:0] intValue];
    }
    if(self.quantumTime){
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}


- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didClickButton:(UIButton*)btn{
    if(_quantumTime){
        [self performSegueWithIdentifier:@"TimingRecord2TimingRecordSchedule" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"TimingRecord2TimingRecordSchedule"]){
        TimingRecordSchedule_HichipViewController *controller = segue.destinationViewController;
        controller.fromTime = [_quantumTime getFromTime];
        controller.toTime = [_quantumTime getToTime];
        controller.type = _quantumTime.recordTime;
    }
}

- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    switch (type) {
        case HI_P2P_GET_REC_AUTO_PARAM:{
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            if(size >= sizeof(HI_P2P_S_REC_AUTO_PARAM)){
                self.recAutoParam =[[RecAutoParam alloc] initWithData:(char*)data size:(int)size];
                if(self.recAutoParam.u32Enable == 0){
                    if(self.quantumTime){
                        self.quantumTime.recordTime = 0;
                    }
                }
                [self refreshTable];
            }
        }
            break;
        case HI_P2P_GET_REC_AUTO_SCHEDULE:{
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            if(size >= sizeof(HI_P2P_QUANTUM_TIME)){
                self.quantumTime =[[QuantumTime alloc] initWithData:(char*)data size:(int)size];
                if(self.recAutoParam){
                    if(self.recAutoParam.u32Enable == 0){
                        self.quantumTime.recordTime = 0;
                    }
                }
                [self refreshTable];
            }
        }
            break;
        default:
            break;
    }
}
//其他界面返回到此界面调用的方法
- (IBAction)TimingRecordViewController1UnwindSegue:(UIStoryboardSegue *)unwindSegue {
    TimingRecordSchedule_HichipViewController *controller = unwindSegue.sourceViewController;
    [_quantumTime setTime:controller.fromTime totime:controller.toTime type:controller.type];
    [self refreshTable];
}
- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{
    
    NSLog(@"canPerformUnwindSegueAction");
    return YES;
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
