//
//  AddCustomerViewController.m
//  Kmanager
//
//  Created by Khánh on 26/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "AddCustomerViewController.h"
#import "Server.h"
#import "AddLocationViewController.h"
@interface AddCustomerViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    CLLocation * locationNew;
    UITextField *customTF;
    UITextView *customTV;
    BOOL isView;
    double kinhdoC;
    double vidoC;
}
@end

@implementation AddCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _txtTenKhachHang.delegate = self;
    _txtMaKhachHang.delegate = self;
    _txtSoDienThoai.delegate = self;
    _txtDiaChi.delegate = self;
    _txtNguoiLienHe.delegate = self;
    _txtGhiChu.delegate = self;
    if (_isEdit == 1) {
        _txtDiaChi.text = [NSString stringWithFormat:@"%@",[_dicCustomer objectForKey:@"address"]];
        _txtTenKhachHang.text = [NSString stringWithFormat:@"%@",[_dicCustomer objectForKey:@"name"]];
        _txtMaKhachHang.text = [NSString stringWithFormat:@"%@",[_dicCustomer objectForKey:@"code"]];
        _txtSoDienThoai.text = [NSString stringWithFormat:@"%@",[_dicCustomer objectForKey:@"phoneNumber"]];
        _txtNguoiLienHe.text = [NSString stringWithFormat:@"%@",[_dicCustomer objectForKey:@"contact"]];
        _txtGhiChu.text = [NSString stringWithFormat:@"%@",[_dicCustomer objectForKey:@"note"]];

    }
    else
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        //    [self.locationManager requestWhenInUseAuthorization];
        //    [self.locationManager requestAlwaysAuthorization];
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 10;
        [self.locationManager startUpdatingLocation];
    }
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.pausesLocationUpdatesAutomatically = NO;
//    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
//        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
//    }
//    //    [self.locationManager requestWhenInUseAuthorization];
//    //    [self.locationManager requestAlwaysAuthorization];
//    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.locationManager requestWhenInUseAuthorization];
//    }
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    self.locationManager.distanceFilter = 10;
//    [self.locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    if (_viewMode == 3 || _viewMode == 4) {
        [_btnMap setHidden:NO];
    }
    else
    {
        [_btnMap setHidden:YES];
    }
    if (_isEdit == 1)
    {
        kinhdoC = [[_dicCustomer objectForKey:@"latitude"] doubleValue];
        vidoC = [[_dicCustomer objectForKey:@"latitude"] doubleValue];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"SelectLocationCustomerIdentifier"]) {
        AddLocationViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}
#pragma mark - location delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    locationNew =[locations lastObject];
    kinhdoC = locationNew.coordinate.longitude;
    vidoC = locationNew.coordinate.latitude;
    if(locationNew.coordinate.latitude>1.0 && locationNew.coordinate.longitude >1.0)
    {
        [self.locationManager stopUpdatingLocation];
        

        
        CLGeocoder* geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:locationNew completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if(!error){
                CLPlacemark *placemark = [placemarks lastObject];
                NSString *diaChi = [self getAddressFromPlacemark:placemark];
                _txtDiaChi.text = diaChi;
            }
            else{
                _txtDiaChi.text = @"Không xác định";
            }
            
        }];
    }

}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    _txtDiaChi.text = @"Không xác định";

}
- (IBAction)btnguiPressed:(id)sender {
    if (self.txtTenKhachHang.text.length <= 0 || self.txtSoDienThoai.text.length <= 0) {
        UIAlertController* c = [UIAlertController alertControllerWithTitle:@"Lỗi!" message:@"Bạn phải nhập đầy đủ thông tin cần thiết" preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self dismissViewControllerAnimated:NO completion:^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutApp" object:nil userInfo:nil];
//                
//            }];
        }];
        [c addAction:okAct];
        [self presentViewController:c animated:YES completion:nil];
        return;
    }
    if (_isEdit == 1) {

        NSDictionary * postDic = @{@"idlogin":[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]],
                                   @"_id":[NSString stringWithFormat:@"%@",[_dicCustomer objectForKey:@"_id"]],
                                   @"name": self.txtTenKhachHang.text,
                                   @"phoneNumber": self.txtSoDienThoai.text,
                                   @"address": self.txtDiaChi.text,
                                   @"note":self.txtGhiChu.text,
                                   @"longitude":[NSString stringWithFormat:@"%f",kinhdoC],
                                   @"latitude":[NSString stringWithFormat:@"%f",vidoC],
                                   @"contact":self.txtNguoiLienHe.text,
                                   @"code":self.txtMaKhachHang.text
                                   };
        NSMutableDictionary *dicStaff = [[NSMutableDictionary alloc] init];
        dicStaff = [postDic mutableCopy];
        NSArray *arrIdStaff = [_dicCustomer objectForKey:@"users"];
        [dicStaff setValue:arrIdStaff forKey:@"users"];
        postDic = dicStaff;
        [[Server sharedServer] putData:@"http://svkmanager.herokuapp.com/api/customer" param:postDic completion:^(NSError *error, NSDictionary *data){
            if (error == nil) {
                NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
                NSInteger status = [[data objectForKey:@"status"] integerValue];
                
                if (status == true) {
                    UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:@"Sửa thông tin khách hàng thành công" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil userInfo:nil];
                        
                        [self.navigationController popViewControllerAnimated:true];
                        
                    }];
                    [c addAction:okAct];
                    [self presentViewController:c animated:YES completion:nil];
                }
                else
                {
                    UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }];
                    [c addAction:okAct];
                    [self presentViewController:c animated:YES completion:nil];
                }
                
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
    else
    {

        
        NSDictionary * postDic = @{@"idlogin":[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]],
                                   @"name": self.txtTenKhachHang.text,
                                   @"phoneNumber": self.txtSoDienThoai.text,
                                   @"address": self.txtDiaChi.text,
                                   @"note":self.txtGhiChu.text,
                                   @"longitude":[NSString stringWithFormat:@"%f",kinhdoC],
                                   @"latitude":[NSString stringWithFormat:@"%f",vidoC],
                                   @"contact":self.txtNguoiLienHe.text,
                                   @"code":self.txtMaKhachHang.text
                                   };
        if (_viewMode == 2) {
            NSMutableDictionary *dicStaff = [[NSMutableDictionary alloc] init];
            dicStaff = [postDic mutableCopy];
            NSArray *arrIdStaff = @[[[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]];
            [dicStaff setValue:arrIdStaff forKey:@"users"];
            postDic = dicStaff;
        }
        [[Server sharedServer] postData:@"http://svkmanager.herokuapp.com/api/customer" param:postDic completion:^(NSError *error, NSDictionary *data){
            if (error == nil) {
                NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
                NSInteger status = [[data objectForKey:@"status"] integerValue];
                
                if (status == true) {
                    UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:@"Thêm mới khách hàng thành công" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil userInfo:nil];
                        
                        [self dismissViewControllerAnimated:true completion:nil];

                    }];
                    [c addAction:okAct];
                    [self presentViewController:c animated:YES completion:nil];
                }
                else
                {
                    UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }];
                    [c addAction:okAct];
                    [self presentViewController:c animated:YES completion:nil];
                }
                
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
    

    
}
- (NSString*)getAddressFromPlacemark:(CLPlacemark*)placemark {
    NSMutableString *address = [[NSMutableString alloc] init];
    
    NSString *soNha = placemark.subThoroughfare;
    NSString *pho = placemark.thoroughfare;
    NSString *phuong = placemark.subLocality;
    NSString *quan = placemark.subAdministrativeArea;
    NSString *tp = placemark.administrativeArea;
    
    if (soNha != nil && ![soNha isEqualToString:@""])
        [address appendString:[NSString stringWithFormat:@"%@ ", soNha]];
    if (pho != nil && ![pho isEqualToString:@""])
        [address appendString:[NSString stringWithFormat:@"%@, ", pho]];
    if (phuong != nil && ![phuong isEqualToString:@""])
        [address appendString:[NSString stringWithFormat:@"%@, ", phuong]];
    if (quan != nil && ![quan isEqualToString:@""])
        [address appendString:[NSString stringWithFormat:@"%@, ", quan]];
    if (tp != nil && ![tp isEqualToString:@""])
        [address appendString:[NSString stringWithFormat:@"%@", tp]];
    
    return address;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    customTF = textField;
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Kết Thúc"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(doneEditingText)];
        
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedItem, doneButton, nil]];
        
        textField.inputAccessoryView = keyboardDoneButtonView;
        //        currentEditingField = textView;
    if (textField == _txtNguoiLienHe) {
        isView =YES;
    }
    else
    {
        isView =NO;

    }
        return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    customTV = textView;


    //        currentEditingField = textView;
    
    //[Utilities alertFromServer:@"Không thể sửa"];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    isView =YES;

    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Kết Thúc"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneEditingText)];
    
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedItem, doneButton, nil]];
    
    textView.inputAccessoryView = keyboardDoneButtonView;
    //        currentEditingField = textView;
    
    return YES;
}
- (void)doneEditingText{
    _topView.constant = 0;
    _bottomBtnGui.constant = 10;
    [customTV resignFirstResponder];
    [customTF resignFirstResponder];
    [self.view layoutIfNeeded];

}
- (void)keyboardOnScreen:(NSNotification*)notification {
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    if (isView == YES) {
        _topView.constant = - keyboardFrame.size.height;
        _bottomBtnGui.constant = 10 + keyboardFrame.size.height;
    }

    [self.view layoutIfNeeded];

    
}
- (IBAction)btnMapPressed:(id)sender {
}
-(void)didSelectLocation :(AddLocationViewController*)homevc withAddress :(NSString*)address withLocation :(CLLocation*)locationSend
{
    _txtDiaChi.text= address;
    kinhdoC = locationSend.coordinate.longitude;
    vidoC = locationSend.coordinate.latitude;
}
@end
