//
//  ThemSanPhamViewController.m
//  Kmanager
//
//  Created by Khánh on 23/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "ThemSanPhamViewController.h"
#import "Server.h"
@interface ThemSanPhamViewController ()

@end

@implementation ThemSanPhamViewController

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

- (IBAction)btnLuuPressed:(id)sender {
    [self sendData];
}
- (void)sendData
{
    NSDictionary * postDic = @{@"idlogin":[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]],
                               @"name": self.tenTF.text,
                               @"model": self.modelTF.text,
                               @"info": self.infoTV.text
                               };
    
    [[Server sharedServer] postData:@"http://svkmanager.herokuapp.com/api/product" param:postDic completion:^(NSError *error, NSDictionary *data){
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
@end
