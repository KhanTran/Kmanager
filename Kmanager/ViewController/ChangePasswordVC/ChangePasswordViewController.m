//
//  ChangePasswordViewController.m
//  Kmanager
//
//  Created by Khánh on 25/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Server.h"
#import "Define.h"
@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (IBAction)btnGuiPressed:(id)sender {
    if (self.passwordNewTF.text.length <= 0 || self.passwordNewTF.text.length <= 0 || self.passwordOldTF.text.length <= 0) {
        UIAlertController* c = [UIAlertController alertControllerWithTitle:@"Lỗi!" message:@"Bạn phải nhập đầy đủ thông tin" preferredStyle:UIAlertControllerStyleAlert];
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
    if (![self.passwordNewTF.text isEqualToString:self.passwordRenewTF.text]) {
        UIAlertController* c = [UIAlertController alertControllerWithTitle:@"Lỗi!" message:@"Mật khẩu mới và mật khẩu nhập lại không trùng nhau" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [c addAction:okAct];
        [self presentViewController:c animated:YES completion:nil];
        return;

    }
    

    NSDictionary * postDic = @{@"idlogin":[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]],
                               @"username": [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]],
                               @"password": self.passwordOldTF.text,
                               @"newpassword": self.passwordRenewTF.text,
                               };
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer] postData:[NSString stringWithFormat:@"%@user/changepassword", ServerApi] param:postDic completion:^(NSError *error, NSDictionary *data){
        [[Server sharedServer] hideAnimation:self.view];

        if (error == nil) {
            NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
            UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:@"Đổi mật khẩu thành công" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:NO completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutApp" object:nil userInfo:nil];

                }];
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
