//
//  DanhSachLoaiSPViewController.h
//  Kmanager
//
//  Created by Khánh on 26/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DanhSachLoaiSPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableviewPlan;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *arrLoaiSP;
@property (strong, nonatomic) NSString *strIDKeHoach;

@end
