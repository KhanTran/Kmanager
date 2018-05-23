//
//  ViewController.h
//  Kmanager
//
//  Created by Khánh on 10/02/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *maCongTyTF;
@property (weak, nonatomic) IBOutlet UITextField *taiKhoanTF;
@property (weak, nonatomic) IBOutlet UITextField *matKhauTF;
- (IBAction)dangNhapBtnPressed:(id)sender;
@property (strong, nonatomic) NSArray *arrChucNang;
@property (strong, nonatomic) NSDictionary *dicThongTinTaiKhoan;
- (IBAction)btnLuuPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLuu;


@end

