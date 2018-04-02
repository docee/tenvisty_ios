//
//  EventSearchCustomViewController.m
//  tenvisty
//
//  Created by lu yi on 12/26/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "EventSearchCustomViewController.h"

@interface EventSearchCustomViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labFrom;
@property (weak, nonatomic) IBOutlet UILabel *labTo;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker_from;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker_to;
@property (nonatomic,strong)  NSDate *dateFrom;
@property (nonatomic,strong)  NSDate *dateTo;
@end

@implementation EventSearchCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.mode == UIDatePickerModeDate){
        _datepicker_from.datePickerMode = UIDatePickerModeDate;
        _datepicker_to.datePickerMode = UIDatePickerModeDate;
       // [_datepicker_to addTarget:self action:@selector(dateToChanged:) forControlEvents:UIControlEventValueChanged];
       // [_datepicker_from addTarget:self action:@selector(dateFromChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else{
        _datepicker_from.datePickerMode = UIDatePickerModeDateAndTime;
        _datepicker_to.datePickerMode = UIDatePickerModeDateAndTime;
    }
    // Do any additional setup after loading the view.
}

-(void)dateFromChanged:(UIDatePicker*)datePicker{
    _datepicker_to.minimumDate = [_datepicker_from.date dateByAddingTimeInterval:-7*24*60*60];
    _datepicker_to.maximumDate = [_datepicker_from.date dateByAddingTimeInterval:+7*24*60*60];
}
-(void)dateToChanged:(UIDatePicker*)datePicker{
    _datepicker_from.minimumDate = [_datepicker_from.date dateByAddingTimeInterval:-7*24*60*60];
    _datepicker_from.maximumDate = [_datepicker_from.date dateByAddingTimeInterval:+7*24*60*60];
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
