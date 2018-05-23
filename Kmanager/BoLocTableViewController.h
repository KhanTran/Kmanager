//
//  BoLocTableViewController.h
//  Kmanager
//
//  Created by Khánh on 20/03/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BoLocTableViewController;

@protocol BoLocDelegate <NSObject>

- (void)boLocDidClose:(BoLocTableViewController*)boLocVC withListPlan:(NSDictionary*) arrayPlan;
//- (void)loadDanhSachDaiLy:(NSArray *)arrNhomKH;

@end
@interface BoLocTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *arrItem;
@property (assign) id <BoLocDelegate> delegate;
- (IBAction)btnBackPressed:(id)sender;

@end
