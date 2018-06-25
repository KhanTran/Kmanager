//
//  BaoCaoKhachHangViewController.h
//  Kmanager
//
//  Created by Khánh on 07/06/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoCaoKhachHangViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableviewKeHoach;
- (IBAction)btnDateFPressed:(id)sender;
- (IBAction)btnDateTPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *tfFromDate;
@property (strong, nonatomic) IBOutlet UITextField *tfToDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTongSo;
@property (strong, nonatomic) IBOutlet UILabel *lblHoanThanh;
@property (strong, nonatomic) IBOutlet UILabel *lblChuaHoanThanh;
@end
