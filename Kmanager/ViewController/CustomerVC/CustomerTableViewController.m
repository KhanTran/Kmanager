//
//  CustomerTableViewController.m
//  Kmanager
//
//  Created by Khánh on 23/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "CustomerTableViewController.h"
#import "CustomerTableViewCell.h"
#import "PlanViewController.h"
#import "DetailCustomerTableViewController.h"
#import "DetaiCustomer2ViewController.h"
#import "AddCustomerViewController.h"
#import "AdminCustomerTableViewCell.h"
#import "NhanVienViewController.h"
@interface CustomerTableViewController ()
{
    NSMutableArray *arrCustomer;
    NSMutableArray *arrCustomerSearch;
    NSDictionary *dicDetailCustomer;
    NSString *idKhachHang;
    NSInteger isEdit;
    NSArray * arrayStaff;
}

@end

@implementation CustomerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrCustomer = [[NSMutableArray alloc] init];
    arrCustomerSearch = [[NSMutableArray alloc] init];
    if (_viewMode == 1 || _viewMode == 3) {
        self.navigationItem.title = @"Chọn khách hàng";
        self.btnAdd.tintColor = [UIColor greenColor];
        self.btnAdd.enabled = NO;
    }
    else
    {
        self.navigationItem.title = @"Danh sách khách hàng";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCustomer) name:@"ReloadData" object:nil];
    isEdit = 0;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    [self requestCustomer];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return arrCustomerSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CustomerTableViewCellIdentifier";
    if (_viewMode == 3 || _viewMode ==4) {
        AdminCustomerTableViewCell *cell = (AdminCustomerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AdminCustomerTableViewCellIdentifier"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminCustomerTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSDictionary *dic = [arrCustomerSearch objectAtIndex:indexPath.row];
        cell.lblNameStore.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        cell.lblAddress.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"address"]];
        if (cell.lblAddress.text.length <= 0) {
            cell.lblAddress.text = @"Không xác định";
        }
        cell.lblPhone.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"phoneNumber"]];
        [cell.btnSuaKH addTarget:self action:@selector(btnSuaKHAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnXoaKH addTarget:self action:@selector(btnXoaKHAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnThemNV addTarget:self action:@selector(btnThemNVAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([dic objectForKey:@"users"] != [NSNull null]) {
            NSArray *arrNV = [dic objectForKey:@"users"];
            if (arrNV.count > 0) {
                if (arrNV.count > 3) {
                    cell.lblStaff.text = [NSString stringWithFormat:@"%ld nhân viên quản lý",arrNV.count];
                }
                else
                {
                    
                    for (int i = 0; i<arrNV.count; i++) {
                        NSDictionary *dicNV = [arrNV objectAtIndex:i];
                        if (i==0) {
                            cell.lblStaff.text = [NSString stringWithFormat:@"%@",[dicNV objectForKey:@"fullname"]];
                        }
                        else
                        {
                            cell.lblStaff.text = [NSString stringWithFormat:@"%@, %@",cell.lblStaff.text,[dicNV objectForKey:@"fullname"]];
                            
                        }
                    }
                }
            }
            else
            {
                cell.lblStaff.text = @"Chưa có nhân viên quản lý";
            }
        }
        else
        {
            cell.lblStaff.text = @"Chưa có nhân viên quản lý";
        }
        if (_viewMode == 3) {
            cell.heightBtn.constant = 0;
            cell.btnXoaKH.hidden = YES;
            cell.btnSuaKH.hidden = YES;
            
        }
        else
        {
            cell.heightBtn.constant = 30;
            cell.btnSuaKH.layer.cornerRadius = cell.btnSuaKH.bounds.size.height/4;
            cell.btnXoaKH.layer.cornerRadius = cell.btnXoaKH.bounds.size.height/4;
            cell.btnXoaKH.hidden = NO;
            cell.btnSuaKH.hidden = NO;
        }
        // Configure the cell...
        
        return cell;
    }
    CustomerTableViewCell *cell = (CustomerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomerTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = [arrCustomerSearch objectAtIndex:indexPath.row];
    cell.lblNameStore.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.lblAddress.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"address"]];
    if (cell.lblAddress.text.length <= 0) {
        cell.lblAddress.text = @"Không xác định";
    }
    cell.lblPhone.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"phoneNumber"]];
    [cell.btnSuaKH addTarget:self action:@selector(btnSuaKHAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnXoaKH addTarget:self action:@selector(btnXoaKHAction:) forControlEvents:UIControlEventTouchUpInside];

    if (_viewMode == 1) {
        cell.heightBtn.constant = 0;
        cell.btnXoaKH.hidden = YES;
        cell.btnSuaKH.hidden = YES;

    }
    else
    {
        cell.heightBtn.constant = 30;
        cell.btnSuaKH.layer.cornerRadius = cell.btnSuaKH.bounds.size.height/4;
        cell.btnXoaKH.layer.cornerRadius = cell.btnXoaKH.bounds.size.height/4;
        cell.btnXoaKH.hidden = NO;
        cell.btnSuaKH.hidden = NO;
    }
    // Configure the cell...
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [arrCustomerSearch objectAtIndex:indexPath.row];

    dicDetailCustomer = [arrCustomerSearch objectAtIndex:indexPath.row];
    if (_viewMode == 1) {
        [self performSegueWithIdentifier:@"planIdentifier" sender:nil];
    }
    else if (_viewMode == 3) {
        [self dismissViewControllerAnimated:true completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectKhachHang:didChooseCustomer:)])
            {
                [self.delegate selectKhachHang:self didChooseCustomer:dic];
                
            }
        }];

    }
    else
    {
        [self performSegueWithIdentifier:@"detailCustomer2Identifier" sender:nil];
    }


}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"detailCustomerIdentifier"]) {
        DetailCustomerTableViewController *vc = [segue destinationViewController];
        vc.dicDetail = dicDetailCustomer;
    }
    else if ([[segue identifier] isEqualToString:@"detailCustomer2Identifier"]) {
        DetaiCustomer2ViewController *vc = [segue destinationViewController];
        vc.dicDetail = dicDetailCustomer;
    }
    else if ([[segue identifier] isEqualToString:@"addCustomerIdentifier"]) {
        AddCustomerViewController *vc = [segue destinationViewController];
        vc.dicCustomer = dicDetailCustomer;
        vc.isEdit = isEdit;
        vc.viewMode = _viewMode;
    }
    else if ([[segue identifier] isEqualToString:@"planIdentifier"])
    {
        PlanViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        vc.strKhachHang = [NSString stringWithFormat:@"%@", [dicDetailCustomer objectForKey:@"_id"]];
    }
    else if ([[segue identifier] isEqualToString:@"ChonNVIdentifier"])
    {
        NhanVienViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        vc.arrayStaff = [[NSMutableArray alloc] init];
        vc.arrayStaff = [arrayStaff mutableCopy];
        vc.dicStaff = [[NSMutableDictionary alloc] init];
        vc.dicStaff = [dicDetailCustomer mutableCopy];
        vc.viewMode = 2;
//        vc.strKhachHang = [NSString stringWithFormat:@"%@", [dicDetailCustomer objectForKey:@"_id"]];
    }
}
-(void)requestCustomer
{
    NSString *url = [NSString stringWithFormat:@"http://svkmanager.herokuapp.com/api/customer?idlogin=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]];
    if (_viewMode == 3 || _viewMode == 4) {
        url = [NSString stringWithFormat:@"http://svkmanager.herokuapp.com/api/customer/all?idlogin=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]];

    }
    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                
                NSArray *arr = data[@"data"];
                arrCustomer = [arr mutableCopy];
                arrCustomerSearch = [arr mutableCopy];
            }
            else
            {
                arrCustomer = [[NSMutableArray alloc] init];
                arrCustomerSearch = [arrCustomer mutableCopy];
            }
            [self.tableView reloadData];
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
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)btnAddCustomerPressed:(id)sender {
    isEdit = 0;
    [self performSegueWithIdentifier:@"addCustomerIdentifier" sender:nil];

}
-(void)btnSuaKHAction:(id)sender {
    UIButton *button = sender;
    CGPoint correctedPoint = [button convertPoint:button.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:correctedPoint];
    dicDetailCustomer = [arrCustomerSearch objectAtIndex:indexPath.row];
    isEdit = 1;
    [self performSegueWithIdentifier:@"addCustomerIdentifier" sender:nil];

}
-(void)btnXoaKHAction:(id)sender {
    UIButton *button = sender;
    CGPoint correctedPoint = [button convertPoint:button.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:correctedPoint];
    
    NSDictionary * dic = [arrCustomerSearch objectAtIndex:indexPath.row];
    idKhachHang = [NSString stringWithFormat:@"%@",[dic objectForKey:@"_id"]];
    NSString *url = [NSString stringWithFormat:@"http://svkmanager.herokuapp.com/api/customer?idlogin=%@&id=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"],idKhachHang];
    [[Server sharedServer] deleteData:url completion:^(NSError *error, NSDictionary *data) {
        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
                UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self requestCustomer];
                }];
                [c addAction:okAct];
                [self presentViewController:c animated:YES completion:nil];
            }
            else
            {
                NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
                UIAlertController* c = [UIAlertController alertControllerWithTitle:@"Lỗi!" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [c addAction:okAct];
                [self presentViewController:c animated:YES completion:nil];
            }
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
-(void)btnThemNVAction:(id)sender {
    UIButton *button = sender;
    CGPoint correctedPoint = [button convertPoint:button.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:correctedPoint];
    
    NSDictionary * dic = [arrCustomerSearch objectAtIndex:indexPath.row];
    idKhachHang = [NSString stringWithFormat:@"%@",[dic objectForKey:@"_id"]];
    if ([dic objectForKey:@"users"] != [NSNull null]) {
        arrayStaff = [dic objectForKey:@"users"];

    }
    else
    {
        arrayStaff = @[];
    }
    dicDetailCustomer = [arrCustomerSearch objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:@"ChonNVIdentifier" sender:nil];

}
@end
