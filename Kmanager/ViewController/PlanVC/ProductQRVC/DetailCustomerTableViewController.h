//
//  DetailCustomerTableViewController.h
//  Kmanager
//
//  Created by Khánh on 23/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCustomerTableViewController : UITableViewController
@property (strong, nonatomic) NSDictionary* dicDetail;
@property (strong, nonatomic) NSString* qrcode;
@property (strong, nonatomic) NSString* idProduct;

@end
