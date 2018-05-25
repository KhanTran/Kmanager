//
//  AddCustomerViewController.h
//  Kmanager
//
//  Created by Khánh on 26/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddCustomerViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtTenKhachHang;
@property (weak, nonatomic) IBOutlet UITextField *txtMaKhachHang;
@property (weak, nonatomic) IBOutlet UITextField *txtSoDienThoai;
@property (weak, nonatomic) IBOutlet UITextView *txtDiaChi;
@property (weak, nonatomic) IBOutlet UITextField *txtNguoiLienHe;
@property (weak, nonatomic) IBOutlet UITextView *txtGhiChu;
- (IBAction)btnguiPressed:(id)sender;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnGui;
@property (nonatomic) NSInteger isEdit;
@property (strong,nonatomic) NSDictionary *dicCustomer;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
- (IBAction)btnMapPressed:(id)sender;
@property (nonatomic) NSInteger viewMode;

@end
