//
//  ThemNhanVienViewController.m
//  Kmanager
//
//  Created by Khánh on 23/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "ThemNhanVienViewController.h"
#import "Server.h"
#import "TimePickerViewController.h"
@interface ThemNhanVienViewController ()

@end

@implementation ThemNhanVienViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    if ([[segue identifier] isEqualToString:@"dateOfBirthIdentifier"]) {
        TimePickerViewController *vc = [segue destinationViewController];
        vc.dateNow = [NSDate date];
        vc.delegate = self;
    }
}

- (IBAction)btnChonNgayPressed:(id)sender {
    [self performSegueWithIdentifier:@"dateOfBirthIdentifier" sender:nil];
    
}
- (IBAction)btnLuuSuaPressed:(id)sender {
    [self sendData];
}
- (void)sendData
{
    NSDictionary * postDic = @{@"username":self.taiKhoanTF.text,
                               @"password": self.matKhauTF.text,
                               @"phonenumber": self.sdtTF.text,
                               @"email": self.emailTF.text,
                               @"fullname":self.tenTF.text,
                               @"dateofbirth":self.ngaySinhTF.text,
                               @"avartar":@"",
                               @"tokenfirebase":@""
                               };

    [[Server sharedServer] postData:@"http://svkmanager.herokuapp.com/api/user" param:postDic completion:^(NSError *error, NSDictionary *data){
        if (error == nil) {
            NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            
            if (status == true) {
                UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:@"Thêm mới tài khoản thành công" preferredStyle:UIAlertControllerStyleAlert];
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
- (void)timePicker:(TimePickerViewController*)timePicker didChooseTime:(NSDate*)time
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];
    df.dateFormat = @"dd/MM/yyyy";
    self.ngaySinhTF.text = [NSString stringWithFormat:@"%@", [df stringFromDate:time]];
}
@end
