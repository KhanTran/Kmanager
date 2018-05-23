//
//  ThemKeHoachViewController.h
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemKeHoachViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableviewListProduct;
- (IBAction)btnBackPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *fromDate;
@property (strong, nonatomic) IBOutlet UIButton *toDate;
- (IBAction)btnDateFPressed:(id)sender;
- (IBAction)btnDateTPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *tfFromDate;
@property (strong, nonatomic) IBOutlet UITextField *tfToDate;
@property (strong, nonatomic) IBOutlet UIButton *btnCustomer;
@property (strong, nonatomic) IBOutlet UITextField *lblCustomer;
@property (strong, nonatomic) IBOutlet UITextField *tfStaff;
@property (strong, nonatomic) IBOutlet UIButton *btnStaff;
- (IBAction)btnStaffPressed:(id)sender;
- (IBAction)btnCustomerPressed:(id)sender;
@property (nonatomic) NSInteger *viewMode;
@property (strong, nonatomic) NSDictionary *dicKehoach;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnAddEdit;
- (IBAction)btnAddEditPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *tfPlan;
@property (strong, nonatomic) IBOutlet UIImageView *iconKhachHang;
@property (strong, nonatomic) IBOutlet UIImageView *iconNhanVien;
@property (strong, nonatomic) IBOutlet UIImageView *iconBatDau;
@property (strong, nonatomic) IBOutlet UIImageView *iconKetThuc;


@end
