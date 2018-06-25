//
//  GanQRViewController.h
//  Kmanager
//
//  Created by Khánh on 23/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GanQRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblMaQR;
@property (weak, nonatomic) IBOutlet UITextField *tfSeries;
@property (weak, nonatomic) IBOutlet UITextField *tfDateFrom;
@property (weak, nonatomic) IBOutlet UITextField *tfDateTo;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)btnHuyPressed:(id)sender;
- (IBAction)btnChonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewDate;
- (IBAction)btnDateToPressed:(id)sender;
- (IBAction)btnDateFromPressed:(id)sender;

- (IBAction)btnGuiPressed:(id)sender;
@property (strong,nonatomic) NSString *idProduct;
@property (strong,nonatomic) NSString *strQRCode;

@end
