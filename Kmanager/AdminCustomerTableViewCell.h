//
//  AdminCustomerTableViewCell.h
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminCustomerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblNameStore;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnXoaKH;
@property (weak, nonatomic) IBOutlet UIButton *btnSuaKH;
@property (weak, nonatomic) IBOutlet UILabel *lblStaff;
@property (weak, nonatomic) IBOutlet UIButton *btnThemNV;
@end
