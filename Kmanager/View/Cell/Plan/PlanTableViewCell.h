//
//  PlanTableViewCell.h
//  Kmanager
//
//  Created by Khánh on 03/03/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblKh;
@property (weak, nonatomic) IBOutlet UILabel *lblKeHoach;
@property (weak, nonatomic) IBOutlet UILabel *lblMatHang;
@property (weak, nonatomic) IBOutlet UILabel *lblTrangThai;
@property (weak, nonatomic) IBOutlet UILabel *lblTienDo;
@property (weak, nonatomic) IBOutlet UIButton *btnGanQR;

@end
