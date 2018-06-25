//
//  GanQRViewController.m
//  Kmanager
//
//  Created by Khánh on 23/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "GanQRViewController.h"
#import "Server.h"
#import "Define.h"
@interface GanQRViewController ()
{
    NSInteger dateMode;
}
@end

@implementation GanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewDate.hidden = YES;
//    self.datePicker.locale = [NSLocale systemLocale];
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    dateFormat.locale = [NSLocale systemLocale];
    self.tfDateFrom.text = [dateFormat stringFromDate:[NSDate date]];
    self.tfDateTo.text = [dateFormat stringFromDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    self.lblMaQR.text = [NSString stringWithFormat:@"Mã QR: %@",self.strQRCode];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)btnHuyPressed:(id)sender {
    self.viewDate.hidden = YES;

}

- (IBAction)btnChonPressed:(id)sender {
    self.viewDate.hidden = YES;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    dateFormat.locale = [NSLocale systemLocale];
    if (dateMode == 1) {
        self.tfDateFrom.text = [dateFormat stringFromDate:self.datePicker.date];
    }
    else
    {
        self.tfDateTo.text = [dateFormat stringFromDate:self.datePicker.date];

    }

}
- (IBAction)btnDateToPressed:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    dateFormat.locale = [NSLocale systemLocale];
    
    dateMode = 2;
    self.datePicker.date = [dateFormat dateFromString:self.tfDateTo.text];
    self.viewDate.hidden = NO;

}

- (IBAction)btnDateFromPressed:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    dateFormat.locale = [NSLocale systemLocale];
    dateMode = 1;
    self.datePicker.date = [dateFormat dateFromString:self.tfDateFrom.text];
    self.viewDate.hidden = NO;

}

- (IBAction)btnGuiPressed:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    dateFormat.locale = [NSLocale systemLocale];
    NSDate *dateF = [dateFormat dateFromString:self.tfDateFrom.text];
    NSDate *dateT = [dateFormat dateFromString:self.tfDateTo.text];

    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];

    NSString *strDateF = [dateFormat stringFromDate:dateF];
    NSString *strDateT = [dateFormat stringFromDate:dateT];

//    self.idProduct = @"5a7d089efeb222491ae36f9a";
//    self.strQRCode =@"TB00003";
    NSDictionary * postDic = @{@"idlogin":[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]],
                               @"schemeProduct": self.idProduct,
                               @"qrCode": self.strQRCode,
                               @"serial": self.tfSeries.text,
                               @"dateFrom":strDateF,
                               @"dateTo":strDateT,
                               @"note":@""
                               };
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer] postData:[NSString stringWithFormat:@"%@schemeProductDetail",ServerApi] param:postDic completion:^(NSError *error, NSDictionary *data){
        [[Server sharedServer] hideAnimation:self.view];

         if (error == nil) {
             NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
             UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDataPlan" object:nil userInfo:nil];

                 [self dismissViewControllerAnimated:YES completion:nil];

             }];
             [c addAction:okAct];
             [self presentViewController:c animated:YES completion:nil];
         }
         else {
             if (error.code == 3840) {
                 NSLog(@"Username not exist.");
             }
             else {
                 UIAlertController* c = [UIAlertController alertControllerWithTitle:@"Lỗi chưa xác định!" message:@"Lỗi chưa xác định. Bạn có kiểm tra lại kết nối mạng và thử lại." preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                 [c addAction:okAct];
                 [self presentViewController:c animated:YES completion:nil];
                 NSLog(@"Error: %@.", error);
             }
         }
     }];
    
}
@end
