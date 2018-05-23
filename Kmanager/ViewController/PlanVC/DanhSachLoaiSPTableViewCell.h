//
//  DanhSachLoaiSPTableViewCell.h
//  Kmanager
//
//  Created by Khánh on 26/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DanhSachLoaiSPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblQRCode;
@property (weak, nonatomic) IBOutlet UILabel *lblProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblSerial;
@property (weak, nonatomic) IBOutlet UIButton *btnGanQRCode;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@end
