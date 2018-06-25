//
//  ThemSanPhamViewController.h
//  Kmanager
//
//  Created by Khánh on 23/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemSanPhamViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *tenTF;
@property (strong, nonatomic) IBOutlet UITextField *modelTF;
@property (strong, nonatomic) IBOutlet UITextView *infoTV;
- (IBAction)btnLuuPressed:(id)sender;
@property (nonatomic) NSInteger *viewMode;
@property (strong, nonatomic) NSDictionary *dicSanPham;

@end
