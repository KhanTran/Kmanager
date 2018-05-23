//
//  NhanVienViewController.h
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NhanVienViewController;

@protocol NhanVienDelegate <NSObject>
- (void)selectNhanVien:(NhanVienViewController*)nhanVien didChooseStaff:(NSDictionary*)dic;
@end

@interface NhanVienViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableviewNhanVien;
- (IBAction)btnBackPressed:(id)sender;
@property (strong, nonatomic) NSMutableArray *arrayStaff;
@property (strong, nonatomic) NSMutableDictionary *dicStaff;
@property (nonatomic) NSInteger viewMode;
@property(assign)id<NhanVienDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
- (IBAction)btnAddPressed:(id)sender;
@end
