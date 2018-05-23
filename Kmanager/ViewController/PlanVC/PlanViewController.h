//
//  PlanViewController.h
//  Kmanager
//
//  Created by Khánh on 03/03/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
@interface PlanViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableviewPlan;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *strKhachHang;
@end
