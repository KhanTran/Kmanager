//
//  ThemKeHoachViewController.m
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "ThemKeHoachViewController.h"
#import "ChonSanPhamTableViewCell.h"
#import "SanPhamObj.h"
#import "TimePickerViewController.h"
#import "NhanVienViewController.h"
#import "CustomerTableViewController.h"
@interface ThemKeHoachViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrSP;
    NSMutableArray * arrSPS;
    NSMutableArray * arrSPG;
    BOOL isFromTo;
}
@end

@implementation ThemKeHoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableviewListProduct.dataSource = self;
    _tableviewListProduct.delegate = self;
    arrSPS = [[NSMutableArray alloc] init];
    arrSPG = [[NSMutableArray alloc] init];
    arrSP = @[
              @{
                @"_id" : @"5a7bbf5bfeb222491acd2b54",
                @"name" : @"Máy chiếu",
                @"model" : @"MC001",
                },
              @{
                  @"_id" : @"5ae1ee12feb222491ad76ec6",
                  @"name" : @"Máy chiếu",
                  @"model" : @"MC002",
                  }
              ];
    for (int i = 0; i<arrSP.count; i++) {
        NSDictionary *dic = [arrSP objectAtIndex:i];
        SanPhamObj * dicSP = [[SanPhamObj alloc] init];
        dicSP.soLuong = @"1";
        dicSP.tenSanPham = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        dicSP.modelSanPham = [NSString stringWithFormat:@"%@",[dic objectForKey:@"model"]];
        dicSP.idSanPham = [NSString stringWithFormat:@"%@",[dic objectForKey:@"_id"]];
        dicSP.isCheck = NO;
        [arrSPS addObject:dicSP];
    }
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    if (_viewMode == 1)
    {
        [self.btnStaff setEnabled:NO];
        [self.btnCustomer setEnabled:NO];
        [self.fromDate setEnabled:NO];
        [self.toDate setEnabled:NO];
        [self.iconKhachHang setHidden:YES];
        [self.iconNhanVien setHidden:YES];
        [self.iconBatDau setHidden:YES];
        [self.iconKetThuc setHidden:YES];
        
        
        [self.tfPlan setUserInteractionEnabled:NO];
        self.lblCustomer.text = [NSString stringWithFormat:@"%@", [_dicKehoach objectForKey:@"namestore"]];
        self.tfStaff.text = [NSString stringWithFormat:@"%@", [_dicKehoach objectForKey:@"nameuser"]];
        self.tfPlan.text = [NSString stringWithFormat:@"%@", [_dicKehoach objectForKey:@"nameplan"]];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.locale = [NSLocale systemLocale];
        df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        NSDate *dateF = [df dateFromString:[_dicKehoach objectForKey:@"fromdate"]];
        NSDate *dateT = [df dateFromString:[_dicKehoach objectForKey:@"todate"]];
        
        df.dateFormat = @"dd/MM/yyyy";
        
        self.tfFromDate.text = [NSString stringWithFormat:@"%@", [df stringFromDate:dateF]];
        self.tfToDate.text = [NSString stringWithFormat:@"%@", [df stringFromDate:dateT]];    }
    else
    {
        [self.iconKhachHang setHidden:NO];
        [self.iconNhanVien setHidden:NO];
        [self.iconBatDau setHidden:NO];
        [self.iconKetThuc setHidden:NO];
        [self.tfPlan setUserInteractionEnabled:YES];
        [self.btnStaff setEnabled:YES];
        [self.btnCustomer setEnabled:YES];
        [self.fromDate setEnabled:YES];
        [self.toDate setEnabled:YES];

    }
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ChonSanPhamTableViewCellIdentifier";
    
    ChonSanPhamTableViewCell *cell = (ChonSanPhamTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChonSanPhamTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    SanPhamObj *dicSP = [arrSPS objectAtIndex:indexPath.row];
    cell.tfSoLuong.text = dicSP.soLuong;
    cell.lblTitleSP.text = dicSP.tenSanPham;
    if (dicSP.isCheck == NO) {
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }

    cell.delegate = self;
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

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    SanPhamObj * dicSP = [arrSPS objectAtIndex:indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
//        NSString *idCuaHang = dicSP.idSanPham;
        dicSP.isCheck = YES;
        [arrSPG addObject:dicSP];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else
    {
        for (int i = 0; i< arrSPG.count; i++) {
            SanPhamObj * dicSPG = [arrSPS objectAtIndex:indexPath.row];
            if ([NSString stringWithFormat:@"%@",dicSP.idSanPham] == [NSString stringWithFormat:@"%@",dicSPG.idSanPham]) {
                [arrSPG removeObjectAtIndex:i];
            }
        }
        dicSP.isCheck = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}
- (void)matHangCellDidStartEditingSoLuong:(ChonSanPhamTableViewCell*)cell
{
    
}
- (void)matHangCellDidEndEditingSoLuong:(ChonSanPhamTableViewCell*)cell
{
    
}
- (void)matHangCell:(ChonSanPhamTableViewCell*)cell didUpdateSoLuong:(long)soluong
{
    NSIndexPath *cellIndexPath = [_tableviewListProduct indexPathForCell:cell];
    if (cellIndexPath == nil)
        return;
    SanPhamObj *dicSP = [arrSPS objectAtIndex:cellIndexPath.row];
    dicSP.soLuong = [NSString stringWithFormat:@"%ld",soluong];
    NSLog(@"Số lượng: %@",dicSP.soLuong);
}
- (void)matHangCellDidChonMatHang:(ChonSanPhamTableViewCell*)cell
{
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"adminTimeIdentifier"]) {
        TimePickerViewController *vc = [segue destinationViewController];
        vc.dateNow = [NSDate date];
        vc.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"SelectStaffIdentifier"]) {
        NhanVienViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        vc.viewMode = 1;
        vc.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"SelectCustomerIdentifier"]) {
        CustomerTableViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        vc.viewMode = 3;
        vc.delegate = self;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnDateFPressed:(id)sender {
    isFromTo = YES;
    [self performSegueWithIdentifier:@"adminTimeIdentifier" sender:nil];
}

- (IBAction)btnDateTPressed:(id)sender {
    isFromTo = NO;
    [self performSegueWithIdentifier:@"adminTimeIdentifier" sender:nil];

}
- (void)timePicker:(TimePickerViewController*)timePicker didChooseTime:(NSDate*)time
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];
    df.dateFormat = @"dd/MM/yyyy";
    if (isFromTo == YES) {
        _tfFromDate.text = [NSString stringWithFormat:@"%@", [df stringFromDate:time]];
    }
    else
    {
        _tfToDate.text = [NSString stringWithFormat:@"%@", [df stringFromDate:time]];

    }
}
- (IBAction)btnStaffPressed:(id)sender {
    [self performSegueWithIdentifier:@"SelectStaffIdentifier" sender:nil];

}
- (void)selectNhanVien:(NhanVienViewController*)nhanVien didChooseStaff:(NSDictionary*)dic
{
    _tfStaff.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fullname"]];
}
- (IBAction)btnCustomerPressed:(id)sender {
    [self performSegueWithIdentifier:@"SelectCustomerIdentifier" sender:nil];

}
- (void)selectKhachHang:(CustomerTableViewController*)khachHang didChooseCustomer:(NSDictionary*)dic
{
    _lblCustomer.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
}
- (IBAction)btnAddEditPressed:(id)sender {
}
@end
