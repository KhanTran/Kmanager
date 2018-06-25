//
//  ViewController.m
//  Kmanager
//
//  Created by Khánh on 10/02/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "AdminHomeViewController.h"
@interface ViewController ()
{
    NSUserDefaults *userdefaults;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults boolForKey:@"IsSave"] == YES) {
        _taiKhoanTF.text = [userdefaults objectForKey:@"Username"];
        _matKhauTF.text = [userdefaults objectForKey:@"Password"];
        [self.btnLuu setImage:[UIImage imageNamed:@"tick_sau.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnLuu setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];

    }


    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dangNhapBtnPressed:(id)sender {
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer] loginWithUsername:_taiKhoanTF.text pass:_matKhauTF.text idcongty:_maCongTyTF.text completion:^(NSError *error, NSDictionary *data)
     {
         [[Server sharedServer] hideAnimation:self.view];

         if (error == nil) {
             NSLog(@"Login success! \n ----------------------------------\n %@", data);
             NSInteger status = [[data objectForKey:@"status"] integerValue];
             if (status != 0) {
                 [userdefaults setObject:_taiKhoanTF.text forKey:@"Username"];
                 [userdefaults setObject:_matKhauTF.text forKey:@"Password"];

                 _arrChucNang = [data objectForKey:@"menus"];
                 _dicThongTinTaiKhoan = [data objectForKey:@"data"];
                 NSDictionary *dic = [_dicThongTinTaiKhoan objectForKey:@"group"];
                 [[NSUserDefaults standardUserDefaults] setBool:[[dic objectForKey:@"isadmin"] boolValue] forKey:@"isadmin"];

                 [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"token"] forKey:@"token"];
                 [[NSUserDefaults standardUserDefaults] setObject:[_dicThongTinTaiKhoan objectForKey:@"_id"] forKey:@"idnhanvien"];
                 if ([[dic objectForKey:@"isadmin"] boolValue] == true) {
                     [self performSegueWithIdentifier:@"loginAdminIdentifier" sender:nil];
                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAdmin"];


                 }
                 else
                 {
                     [self performSegueWithIdentifier:@"loginIdentifier" sender:nil];
                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAdmin"];


                 }
             }
             else
             {
                 NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
                 UIAlertController* c = [UIAlertController alertControllerWithTitle:@"Lỗi!" message:msg preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"loginIdentifier"]) {
        HomeViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        vc.arrMenu = _arrChucNang;
        vc.dicThongTinTaiKhoan = _dicThongTinTaiKhoan;
    }
    if ([[segue identifier] isEqualToString:@"loginAdminIdentifier"]) {
        AdminHomeViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        vc.dicThongTinTaiKhoan = _dicThongTinTaiKhoan;
    }
}
- (IBAction)btnLuuPressed:(id)sender {
    if ([userdefaults boolForKey:@"IsSave"] == YES) {
        [userdefaults setBool:NO forKey:@"IsSave"];
        [self.btnLuu setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    }
    else
    {
        [userdefaults setBool:YES forKey:@"IsSave"];
        [self.btnLuu setImage:[UIImage imageNamed:@"tick_sau.png"] forState:UIControlStateNormal];

    }
}
@end
