//
//  ChangePasswordViewController.h
//  Kmanager
//
//  Created by Khánh on 25/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordOldTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordRenewTF;
- (IBAction)btnHuyPressed:(id)sender;
- (IBAction)btnGuiPressed:(id)sender;

@end
