//
//  DanhSachKeHoachBaoCaoViewController.h
//  Kmanager
//
//  Created by Khánh on 14/06/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DanhSachKeHoachBaoCaoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableviewKeHoach;
@property (strong, nonatomic) NSArray *arrayKeHoachBaoCao;

@end
