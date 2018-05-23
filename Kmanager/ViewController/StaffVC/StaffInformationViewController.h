//
//  StaffInformationViewController.h
//  Kmanager
//
//  Created by Khánh on 01/03/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffInformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableviewInfor;
@property (strong, nonatomic) NSDictionary *dicThongTinTaiKhoan;
@property (strong, nonatomic) NSArray *arrMenuSetting;

@property (nonatomic) NSInteger viewMode;

@end
