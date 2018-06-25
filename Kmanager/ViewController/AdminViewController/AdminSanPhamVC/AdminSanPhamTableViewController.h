//
//  AdminSanPhamTableViewController.h
//  Kmanager
//
//  Created by Khánh on 23/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdminSanPhamTableViewController;

@protocol AdminSanPhamDelegate <NSObject>
- (void)selectSanPham:(AdminSanPhamTableViewController*)sanPham didChooseSanPham:(NSArray*)arr;
@end
@interface AdminSanPhamTableViewController : UITableViewController

- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnAddPressed:(id)sender;
@property (nonatomic) NSInteger viewMode;
@property(assign)id<AdminSanPhamDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *arrayProductID;
@property (strong, nonatomic) NSMutableArray *arrayProduct;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
@end
