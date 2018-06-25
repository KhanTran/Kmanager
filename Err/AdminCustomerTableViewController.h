//
//  AdminCustomerTableViewController.h
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminCustomerTableViewController : UITableViewController
@property (nonatomic) NSInteger viewMode;
- (IBAction)btnAddCustomerPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
@end
