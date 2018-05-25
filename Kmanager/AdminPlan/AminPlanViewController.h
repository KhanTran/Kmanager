//
//  AminPlanViewController.h
//  Kmanager
//
//  Created by Khánh on 04/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AminPlanViewController : UIViewController
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnAddPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableviewKeHoach;
@end
