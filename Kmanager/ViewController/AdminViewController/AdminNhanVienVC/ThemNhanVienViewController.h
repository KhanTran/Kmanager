//
//  ThemNhanVienViewController.h
//  Kmanager
//
//  Created by Khánh on 23/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemNhanVienViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *taiKhoanTF;
@property (strong, nonatomic) IBOutlet UITextField *matKhauTF;
@property (strong, nonatomic) IBOutlet UITextField *tenTF;
@property (strong, nonatomic) IBOutlet UITextField *sdtTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *ngaySinhTF;
@property (strong, nonatomic) IBOutlet UIButton *btnChonNgay;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnLuuSua;
- (IBAction)btnLuuSuaPressed:(id)sender;
@property (strong, nonatomic) NSDictionary *dicKehoach;

@end
