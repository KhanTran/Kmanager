//
//  HomeViewController.h
//  Kmanager
//
//  Created by Khánh on 12/02/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Server.h"

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *homeCollectionView;
@property (strong, nonatomic) NSArray *arrMenu;
@property (strong, nonatomic) NSDictionary *dicThongTinTaiKhoan;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)logoutAction:(id)sender;

@end
