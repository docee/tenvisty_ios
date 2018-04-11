//
//  EventSearchCustomViewController.m
//  tenvisty
//
//  Created by lu yi on 12/26/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "EventSearchCustom_HichipViewController.h"

@interface EventSearchCustom_HichipViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labFrom;
@property (weak, nonatomic) IBOutlet UILabel *labTo;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker_from;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker_to;
@property (nonatomic,strong)  NSDate *dateFrom;
@property (nonatomic,strong)  NSDate *dateTo;
@end

@implementation EventSearchCustom_HichipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = LOCALSTR(@"Search Event");
    self.labFrom.text = LOCALSTR(@"From");
    self.labTo.text = LOCALSTR(@"To");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickSearch:(id)sender {
    self.dateFrom = _datepicker_from.date;
    self.dateTo = _datepicker_to.date;
    [self performSegueWithIdentifier:@"EventSearchCustomBack2EventList" sender:self];
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
