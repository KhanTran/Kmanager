//
//  TimePickerViewController.m
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "TimePickerViewController.h"

@interface TimePickerViewController ()
{
    NSDate *currentDate;
}

@end

@implementation TimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _timePicker.date = _dateNow;
    currentDate = _timePicker.date;
    [_timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)timeChanged:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    dateFormat.locale = [NSLocale systemLocale];
    _lbTime.text = [dateFormat stringFromDate:_timePicker.date];
    currentDate = _timePicker.date;
}

- (IBAction)huyBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)xacNhanBtnPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(timePicker:didChooseTime:)])
    {
        [self.delegate timePicker:self didChooseTime:currentDate];
        [self dismissViewControllerAnimated:true completion:nil];

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
