//
//  CustomerTableViewController.h
//  Kmanager
//
//  Created by Khánh on 23/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerTableViewController;

@protocol CustomerDelegate <NSObject>
- (void)selectKhachHang:(CustomerTableViewController*)khachHang didChooseCustomer:(NSDictionary*)dic;
@end

@interface CustomerTableViewController : UITableViewController
@property(assign)id<CustomerDelegate>delegate;
@property (nonatomic) NSInteger viewMode;
- (IBAction)btnAddCustomerPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
@end
