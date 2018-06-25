//
//  TimePickerViewController.h
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimePickerViewController;

@protocol TimePickerDelegate <NSObject>

- (void)timePicker:(TimePickerViewController*)timePicker didChooseTime:(NSDate*)time;
//- (void)timePickerDidCancel:(TimePickerViewController*)timePicker;

@end
@interface TimePickerViewController : UIViewController
@property(assign)id<TimePickerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
- (IBAction)huyBtnPressed:(id)sender;
- (IBAction)xacNhanBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbTime;
@property (strong, nonatomic) NSDate *dateNow;
@end
