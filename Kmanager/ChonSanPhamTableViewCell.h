//
//  ChonSanPhamTableViewCell.h
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChonSanPhamTableViewCell;

@protocol ChonSanPhamTableViewCellDelegate <NSObject>

- (void)matHangCellDidStartEditingSoLuong:(ChonSanPhamTableViewCell*)cell;
- (void)matHangCellDidEndEditingSoLuong:(ChonSanPhamTableViewCell*)cell;
- (void)matHangCell:(ChonSanPhamTableViewCell*)cell didUpdateSoLuong:(long)soluong;
- (void)matHangCellDidChonMatHang:(ChonSanPhamTableViewCell*)cell;

@end
@interface ChonSanPhamTableViewCell : UITableViewCell<UITextFieldDelegate, UITextViewDelegate>
@property(assign)id<ChonSanPhamTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleSP;
@property (weak, nonatomic) IBOutlet UITextField *tfSoLuong;
- (IBAction)btnThemAction:(id)sender;
- (IBAction)btnBotAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBot;
@property (weak, nonatomic) IBOutlet UIButton *btnThem;

@end
