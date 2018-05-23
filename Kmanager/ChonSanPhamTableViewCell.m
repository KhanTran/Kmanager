//
//  ChonSanPhamTableViewCell.m
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "ChonSanPhamTableViewCell.h"

@implementation ChonSanPhamTableViewCell{
    UITextField *curEditingTF;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnThemAction:(id)sender {
    NSInteger value = [_tfSoLuong.text integerValue] + 1;
    _tfSoLuong.text = [NSString stringWithFormat:@"%ld",(long)value];
    if (self.delegate && [self.delegate respondsToSelector:@selector(matHangCell:didUpdateSoLuong:)])
        [self.delegate matHangCell:self didUpdateSoLuong:(long)value];
}

- (IBAction)btnBotAction:(id)sender {
    NSInteger value = [_tfSoLuong.text integerValue] - 1;
    _tfSoLuong.text = [NSString stringWithFormat:@"%ld",(long)value];
    if (self.delegate && [self.delegate respondsToSelector:@selector(matHangCell:didUpdateSoLuong:)])
        [self.delegate matHangCell:self didUpdateSoLuong:(long)value];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    curEditingTF = textField;
    
    if (curEditingTF == _tfSoLuong) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(matHangCellDidStartEditingSoLuong:)])
            [self.delegate matHangCellDidStartEditingSoLuong:self];
    }
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Kết Thúc"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(textFieldDidEndEditingPressed:)];
    
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedItem, doneButton, nil]];
    
    textField.inputAccessoryView = keyboardDoneButtonView;
    return YES;
}

- (void)textFieldDidEndEditingPressed:(id)sender {
    
    [curEditingTF resignFirstResponder];
    
    if (curEditingTF == _tfSoLuong) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(matHangCellDidEndEditingSoLuong:)])
            [self.delegate matHangCellDidEndEditingSoLuong:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textFieldString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    NSInteger value = [textFieldString integerValue];
//    _tfSoLuong.text = [NSString stringWithFormat:@"%d",value];
    if (self.delegate && [self.delegate respondsToSelector:@selector(matHangCell:didUpdateSoLuong:)])
        [self.delegate matHangCell:self didUpdateSoLuong:(long)value];
    return YES;
}
@end
