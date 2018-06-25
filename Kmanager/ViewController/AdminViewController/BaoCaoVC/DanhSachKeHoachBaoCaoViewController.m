//
//  DanhSachKeHoachBaoCaoViewController.m
//  Kmanager
//
//  Created by Khánh on 14/06/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "DanhSachKeHoachBaoCaoViewController.h"
#import "AdminPlanTableViewCell.h"
#import "XemChiTietKeHoachViewController.h"
@interface DanhSachKeHoachBaoCaoViewController ()
{
    NSMutableArray *arrKeHoach;
    NSMutableArray *arrKeHoachSearch;
    NSInteger viewMode;
    NSDictionary *dicKeHoach;
}
@end

@implementation DanhSachKeHoachBaoCaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableviewKeHoach.delegate = self;
    _tableviewKeHoach.dataSource = self;
    arrKeHoach = [[NSMutableArray alloc] init];
    arrKeHoachSearch = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    arrKeHoach = [_arrayKeHoachBaoCao mutableCopy];
    arrKeHoachSearch = [arrKeHoach mutableCopy];
    [self.tableviewKeHoach reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"XemChiTietKeHoachIdentifier"]) {
        XemChiTietKeHoachViewController *vc = [segue destinationViewController];
        vc.dicKehoach = dicKeHoach;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return arrKeHoachSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"AdminPlanTableViewCellIdentifier";
    
    AdminPlanTableViewCell *cell = (AdminPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminPlanTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = [arrKeHoachSearch objectAtIndex:indexPath.row];
    cell.lblKhachHang.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"namestore"]];
    cell.lblNhanVien.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"nameuser"]];
    cell.lblKeHoach.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"nameplan"]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate *dateF = [df dateFromString:[dic objectForKey:@"fromdate"]];
    NSDate *dateT = [df dateFromString:[dic objectForKey:@"todate"]];
    
    df.dateFormat = @"dd/MM/yyyy";
    
    cell.lblBatDau.text = [NSString stringWithFormat:@"%@", [df stringFromDate:dateF]];
    cell.lblKetThuc.text = [NSString stringWithFormat:@"%@", [df stringFromDate:dateT]];
    cell.lblTrangThai.text = @"Đang triển khai";
    NSArray *arrSP =[dic objectForKey:@"arrProduct"];
    NSInteger tongSoSP = 0;
    NSInteger tongSoSPQR = 0;
    for (int j = 0; j<arrSP.count; j++) {
        NSDictionary *dicSP = [arrSP objectAtIndex:j];
        NSInteger soSP = [[dicSP objectForKey:@"soluongproduct"] integerValue];
        NSInteger soSPQR = [[dicSP objectForKey:@"soluongproductqr"] integerValue];
        tongSoSP = tongSoSP + soSP;
        tongSoSPQR = tongSoSPQR + soSPQR;
    }
    NSComparisonResult result = [dateF compare:[NSDate date]];
    
    if (tongSoSP == tongSoSPQR) {
        cell.lblTrangThai.text = @"Hoàn thành";
    }
    else if (tongSoSPQR == 0)
    {
        if (result == NSOrderedAscending) {
            cell.lblTrangThai.text = @"Quá hạn";
        }
        else
            cell.lblTrangThai.text = @"Mới";
    }
    else
    {
        if (result == NSOrderedAscending) {
            cell.lblTrangThai.text = [NSString stringWithFormat:@"Đang triển khai chậm: %d/%d", tongSoSPQR,tongSoSP];
        }
        else
            cell.lblTrangThai.text = [NSString stringWithFormat:@"Đang triển khai: %d/%d", tongSoSPQR,tongSoSP];
        
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    dicKeHoach = [arrKeHoachSearch objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"XemChiTietKeHoachIdentifier" sender:nil];
    
}

//- (IBAction)btnBackPressed:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)btnAddPressed:(id)sender {
//    [self performSegueWithIdentifier:@"adminAddPlanIdentifier" sender:nil];
//}

@end
