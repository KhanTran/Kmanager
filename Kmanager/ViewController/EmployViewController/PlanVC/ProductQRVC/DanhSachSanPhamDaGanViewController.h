//
//  DanhSachSanPhamDaGanViewController.h
//  Kmanager
//
//  Created by Khánh on 26/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DanhSachSanPhamDaGanViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableviewListProductQR;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *strIDKeHach;
@property (strong, nonatomic) NSString *idProduct;

@end
