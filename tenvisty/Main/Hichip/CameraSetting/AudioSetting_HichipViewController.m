//
//  AudioSetting_HichipViewController.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/6.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "AudioSetting_HichipViewController.h"
#import "HichipCamera.h"
#import "AudioAttr.h"

@interface AudioSetting_HichipViewController ()<CellModelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSArray *listItems;
@property (strong,nonatomic) HichipCamera *originCamera;
@property (nonatomic, strong) AudioAttr *audio;

@end

@implementation AudioSetting_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originCamera = (HichipCamera*)self.camera.orginCamera;
    [self.tableview setBackgroundColor:Color_GrayLightest];
    [self.view setBackgroundColor:Color_GrayLightest];
    [self setup];
    // Do any additional setup after loading the view.
}

-(void)setup{
    self.navigationController.title = LOCALSTR(@"Audio Setting");
    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
    [self doGetAudioSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTable{
    if(self.audio){
        [self setRowValue:FORMAT(@"%d",self.audio.u32InVol) row:0 section:0];
        [self setRowValue:FORMAT(@"%d",self.audio.u32OutVol) row:1 section:0];
        [self.tableview reloadData];
    }
}

-(NSArray *)listItems{
    if(!_listItems){
        ListImgTableViewCellModel *inputModel = [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Input Volume") showValue:YES value:nil viewId:TableViewCell_Slider];
        ListImgTableViewCellModel *outputModel = [ListImgTableViewCellModel initObj:nil title:LOCALSTR(@"Output Volume") showValue:YES value:nil viewId:TableViewCell_Slider];
        inputModel.maxValue = [self.originCamera isGoke] ? 16 : 100;
        inputModel.minValue = 1;
        inputModel.delegate = self;
        outputModel.maxValue = [self.originCamera isGoke] ? 13 : 100;
        outputModel.minValue = 1;
        outputModel.delegate = self;
        NSArray *sec1 = [[NSArray alloc] initWithObjects:
                         inputModel,
                         outputModel,nil];
        _listItems = [[NSArray alloc] initWithObjects:sec1, nil];
    }
    return _listItems;
}

- (void)ListImgTableViewCellModel:(ListImgTableViewCellModel *)cellModel didEndSliderChanging:(UISlider*)sender{
    if(self.audio){
        NSIndexPath *indexPath = [self getIndexPath:cellModel];
        
        //input volume
        if(indexPath.row == 0){
            self.audio.u32InVol = [cellModel.titleValue intValue];
        }
        //output volume
        else{
             self.audio.u32OutVol = [cellModel.titleValue intValue];
        }
        [self doSetAudioSetting];
    }
}
- (void)camera:(NSCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size{
    int needSize = 0;
    switch (type) {
        case HI_P2P_GET_AUDIO_ATTR:{
            needSize = sizeof(HI_P2P_S_AUDIO_ATTR);
            [MBProgressHUD hideAllHUDsForView:self.tableview animated:YES];
            if(size >= needSize){
                self.audio = [[AudioAttr alloc] initWithData:(char*)data size:(int)size];
                [self refreshTable];
            }
        }
            break;
        case HI_P2P_SET_AUDIO_ATTR:{
            if(size >=0){
                    [[iToast makeText:LOCALSTR(@"Setting Successfully")] show];
            }
            else{
                [[iToast makeText:LOCALSTR(@"setting failed, please try again later")] show];
            }
        }
            break;
        default:
            break;
    }
}

-(void)doGetAudioSetting{
    [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_GET_AUDIO_ATTR Data:(char*)nil DataSize:0];
}
-(void)doSetAudioSetting{
    if(self.audio){
        HI_P2P_S_AUDIO_ATTR *req = [self.audio model];
        [self.camera sendIOCtrlToChannel:0 Type:HI_P2P_SET_AUDIO_ATTR Data:(char*)req DataSize:sizeof(HI_P2P_S_AUDIO_ATTR)];
        free(req);
        req = nil;
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
