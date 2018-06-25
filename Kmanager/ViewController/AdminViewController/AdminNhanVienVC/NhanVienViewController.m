//
//  NhanVienViewController.m
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "NhanVienViewController.h"
#import "NhanVienTableViewCell.h"
#import "Server.h"
#import "Define.h"
#import "ThemNhanVienViewController.h"
@interface NhanVienViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arrNhanVien;
    NSMutableArray *arrNhanVienSearch;
    NSDictionary *dicKeHoach;

}

@end

@implementation NhanVienViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableviewNhanVien.delegate = self;
    _tableviewNhanVien.dataSource = self;
    arrNhanVien = [[NSMutableArray alloc] init];
    arrNhanVienSearch = [[NSMutableArray alloc] init];
//    if (_arrayStaff.count > 0) {
//        _btnAdd.title = @"Xong";
//    }
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    [self requestNhanVien];

    if (_viewMode == 2) {
        _btnAdd.title = @"Xong";
        [_btnAdd setEnabled:YES];

    }
    else if (_viewMode == 1)
    {
        _btnAdd.title = @"";
        [_btnAdd setEnabled:NO];
    }
    else
    {
        [_btnAdd setEnabled:YES];

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return arrNhanVienSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"NhanVienTableViewCellIdentifier";
    
    NhanVienTableViewCell *cell = (NhanVienTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NhanVienTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = [arrNhanVienSearch objectAtIndex:indexPath.row];
    cell.lblNameStore.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fullname"]];
//    cell.lblAddress.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"address"]];
    if (cell.lblAddress.text.length <= 0) {
        cell.lblAddress.text = @"Không xác định";
    }
    cell.lblPhone.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"phonenumber"]];
    cell.accessoryType = UITableViewCellAccessoryNone;

    for (int i = 0; i<_arrayStaff.count; i++) {
        NSDictionary *dicS = [_arrayStaff objectAtIndex:i];
        if ([[NSString stringWithFormat:@"%@",[dicS objectForKey:@"_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"_id"]]] ) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;

        }
        
        
    }
//    [cell.btnSuaKH addTarget:self action:@selector(btnSuaKHAction:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.btnXoaKH addTarget:self action:@selector(btnXoaKHAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    if (_viewMode == 1) {
//        cell.heightBtn.constant = 0;
//        cell.btnXoaKH.hidden = YES;
//        cell.btnSuaKH.hidden = YES;
//
//    }
//    else
//    {
//        cell.heightBtn.constant = 30;
//        cell.btnSuaKH.layer.cornerRadius = cell.btnSuaKH.bounds.size.height/4;
//        cell.btnXoaKH.layer.cornerRadius = cell.btnXoaKH.bounds.size.height/4;
//        cell.btnXoaKH.hidden = NO;
//        cell.btnSuaKH.hidden = NO;
//    }
    // Configure the cell...
    
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
//    return UITableViewAutomaticDimension;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return UITableViewAutomaticDimension;
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [arrNhanVienSearch objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];

//    dicDetailCustomer = [arrNhanVienSearch objectAtIndex:indexPath.row];
    if (_viewMode == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectNhanVien:didChooseStaff:)])
            {
                [self.delegate selectNhanVien:self didChooseStaff:dic];
                
            }
        }];

        
    }
    else if (_viewMode == 2)
    {
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            //        NSString *idCuaHang = dicSP.idSanPham;
            [_arrayStaff addObject:dic];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else
        {
            for (int i = 0; i< _arrayStaff.count; i++) {
                NSDictionary *dicS = [_arrayStaff objectAtIndex:i];
                
                if ([[NSString stringWithFormat:@"%@",[dicS objectForKey:@"_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"_id"]]] ) {
                    [_arrayStaff removeObjectAtIndex:i];
                }
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        dicKeHoach = [arrNhanVienSearch objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"AddStaffIdentifier" sender:nil];
    }
    
}
-(void)requestNhanVien
{
    NSString *url = [NSString stringWithFormat:@"%@user/all",ServerApi];
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        [[Server sharedServer] hideAnimation:self.view];

        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                
                NSArray *arr = data[@"data"];
                arrNhanVien = [arr mutableCopy];
                arrNhanVienSearch = [arr mutableCopy];
            }
            else
            {
                arrNhanVien = [[NSMutableArray alloc] init];
                arrNhanVienSearch = [arrNhanVien mutableCopy];
            }
            [self.tableviewNhanVien reloadData];
        }
        else
        {
            if (error.code == 3840) {
                NSLog(@"Username not exist.");
            }
            else {
                UIAlertController* c = [UIAlertController alertControllerWithTitle:@"Lỗi chưa xác định!" message:@"Lỗi chưa xác định. Bạn có kiểm tra lại kết nối mạng và thử lại." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [c addAction:okAct];
                [self presentViewController:c animated:YES completion:nil];
                NSLog(@"Error: %@.", error);
            }
        }
    } ];
    
}
- (IBAction)btnAddPressed:(id)sender {
    if (_viewMode == 2) {
        [_dicStaff removeObjectForKey:@"users"];
        NSMutableArray *arrIdStaff = [[NSMutableArray alloc] init];
        
        for (int i=0; i<_arrayStaff.count; i++) {
            NSDictionary *dic = [_arrayStaff objectAtIndex:i];
            NSString *strID = [dic objectForKey:@"_id"];
            [arrIdStaff addObject:strID];
        }
        [_dicStaff setValue:arrIdStaff forKey:@"users"];
        [[Server sharedServer] showAnimation:self.view];

        [[Server sharedServer] putData:[NSString stringWithFormat:@"%@customer", ServerApi] param:_dicStaff completion:^(NSError *error, NSDictionary *data){
            [[Server sharedServer] hideAnimation:self.view];

            if (error == nil) {
                NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
                NSInteger status = [[data objectForKey:@"status"] integerValue];
                
                if (status == true) {
                    UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:@"Sửa thông tin khách hàng thành công" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil userInfo:nil];
                        
                        [self.navigationController popViewControllerAnimated:true];
                        
                    }];
                    [c addAction:okAct];
                    [self presentViewController:c animated:YES completion:nil];
                }
                else
                {
                    UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }];
                    [c addAction:okAct];
                    [self presentViewController:c animated:YES completion:nil];
                }
                
            }
            else {
                if (error.code == 3840) {
                    NSLog(@"Username not exist.");
                }
                else {
                    UIAlertController* c = [UIAlertController alertControllerWithTitle:@"Lỗi chưa xác định!" message:@"Lỗi chưa xác định. Bạn có kiểm tra lại kết nối mạng và thử lại." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    [c addAction:okAct];
                    [self presentViewController:c animated:YES completion:nil];
                    NSLog(@"Error: %@.", error);
                }
            }
        }];
    }
    else
    {
        dicKeHoach = nil;
        [self performSegueWithIdentifier:@"AddStaffIdentifier" sender:nil];
    }

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddStaffIdentifier"]) {
        ThemNhanVienViewController *vc = [segue destinationViewController];
        vc.dicKehoach = dicKeHoach;
    }
}
@end
