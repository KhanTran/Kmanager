//
//  BaoCaoKeHoachViewController.m
//  Kmanager
//
//  Created by Khánh on 01/06/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "BaoCaoKeHoachViewController.h"
#import "Server.h"
#import "Define.h"
#import "AdminPlanTableViewCell.h"
#import "TimePickerViewController.h"
#import "XemChiTietKeHoachViewController.h"
@interface BaoCaoKeHoachViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *arrKeHoach;
    NSMutableArray *arrKeHoachSearch;
    NSMutableArray *arrKeHoachFiller;

    NSInteger viewMode;
    NSDictionary *dicKeHoach;
    BOOL isFromTo;

}

@end

@implementation BaoCaoKeHoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableviewKeHoach.delegate = self;
    _tableviewKeHoach.dataSource = self;
    _searchBar.delegate = self;
    [_searchBar setValue:@"Hủy" forKey:@"_cancelButtonText"];

    arrKeHoach = [[NSMutableArray alloc] init];
    arrKeHoachSearch = [[NSMutableArray alloc] init];
    arrKeHoachFiller = [[NSMutableArray alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];

    df.dateFormat = @"dd/MM/yyyy";
    
    self.tfFromDate.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
    self.tfToDate.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
    [self requestKeHoach];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    viewMode = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestKeHoach
{
    NSString *url = [NSString stringWithFormat:@"%@scheme/all", ServerApi];
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        [[Server sharedServer] hideAnimation:self.view];

        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                
                NSArray *arr = data[@"data"];
                NSMutableArray *arrFull = [[NSMutableArray alloc] init];
                for (int i =0; i<arr.count; i++) {
                    NSMutableDictionary *setDic = [[NSMutableDictionary alloc] init];
                    
                    NSMutableArray *arrProduct = [[NSMutableArray alloc] init];
                    NSDictionary *dic = [arr objectAtIndex:i];
                    NSArray *array = [dic objectForKey:@"schemeProducts"];
                    NSDictionary *dicCustomer = [dic objectForKey:@"customer"];
                    NSDictionary *dicUser = [dic objectForKey:@"user"];
                    if (dicUser != [NSNull null] && dicUser != nil) {
                        [setDic setValue:[dicUser objectForKey:@"fullname"] forKey:@"nameuser"];
                        [setDic setValue:[dicUser objectForKey:@"_id"] forKey:@"iduser"];
                    }
                    NSDictionary *dicStatus = [dic objectForKey:@"status"];
                    
                    if (dicCustomer != [NSNull null] && dicCustomer != nil) {
                        [setDic setValue:[dicCustomer objectForKey:@"name"] forKey:@"namestore"];
                        [setDic setValue:[dicCustomer objectForKey:@"_id"] forKey:@"idstore"];
                    }
                    else
                    {
                        [setDic setValue:@"Không xác định" forKey:@"namestore"];
                        [setDic setValue:@"0" forKey:@"idstore"];
                    }
                    
                    [setDic setValue:[dic objectForKey:@"name"] forKey:@"nameplan"];
                    [setDic setValue:[dic objectForKey:@"_id"] forKey:@"idplan"];
                    
                    [setDic setValue:[dicStatus objectForKey:@"statusName"] forKey:@"status"];
                    [setDic setValue:[dic objectForKey:@"updatedAt"] forKey:@"date"];
                    [setDic setValue:[dic objectForKey:@"fromDate"] forKey:@"fromdate"];
                    [setDic setValue:[dic objectForKey:@"toDate"] forKey:@"todate"];
                    
                    for (int j =0 ; j <array.count; j++) {
                        NSDictionary *dicScheme = [array objectAtIndex:j];
                        NSMutableDictionary *setDicP = [[NSMutableDictionary alloc] init];
                        
                        [setDicP setValue:[dicScheme objectForKey:@"_id"] forKey:@"idscheme"];
                        [setDicP setValue:[NSString stringWithFormat:@"%@/%@", [dicScheme objectForKey:@"quantityDeployed"],[dicScheme objectForKey:@"quantityDeploy"]] forKey:@"tiendo"];
                        [setDicP setValue:[NSString stringWithFormat:@"%@",[dicScheme objectForKey:@"quantityDeploy"]] forKey:@"soluongproduct"];
                        [setDicP setValue:[NSString stringWithFormat:@"%@",[dicScheme objectForKey:@"quantityDeployed"]] forKey:@"soluongproductqr"];
                        [setDicP setValue:[NSString stringWithFormat:@"%@",[dicScheme objectForKey:@"quantityRemaining"]] forKey:@"soluongproductok"];

                        NSDictionary *dicProduct = [dicScheme objectForKey:@"product"];
                        [setDicP setValue:[dicProduct objectForKey:@"_id"] forKey:@"idproduct"];
                        [setDicP setValue:[dicProduct objectForKey:@"name"] forKey:@"nameproduct"];
                        [setDicP setValue:[dicProduct objectForKey:@"model"] forKey:@"modelproduct"];
                        [arrProduct addObject:setDicP];
                    }
                    
                    [setDic setValue:arrProduct forKeyPath:@"arrProduct"];
                    
                    [arrFull addObject:setDic];
                }
                arrKeHoach = [arrFull mutableCopy];
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isAdmin"] == NO) {
                    NSString *strNhanVien = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]];
                    NSPredicate *tenKHPredicate = [NSPredicate
                                                   predicateWithFormat:@"%K contains[cd] %@",@"iduser",
                                                   strNhanVien];

                    arrKeHoach = [[arrFull filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:@[tenKHPredicate]]] mutableCopy];
                }
                arrKeHoachSearch = [arrKeHoach mutableCopy];
                [self checkDate];
            }
            else
            {
                NSString *msg = [NSString stringWithFormat:@"%@", @"Không tải được dữ liệu"];
                UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [c addAction:okAct];
                [self presentViewController:c animated:YES completion:nil];
                arrKeHoach = [[NSMutableArray alloc] init];
                arrKeHoachSearch = [arrKeHoach mutableCopy];

                arrKeHoachFiller = [arrKeHoach mutableCopy];
            }
            [self.tableviewKeHoach reloadData];
        }
        else
        {
            
        }
    } ];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return arrKeHoachFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"AdminPlanTableViewCellIdentifier";
    
    AdminPlanTableViewCell *cell = (AdminPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminPlanTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = [arrKeHoachFiller objectAtIndex:indexPath.row];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    dicKeHoach = [arrKeHoachSearch objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"XemChiTietKeHoachIdentifier" sender:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return UITableViewAutomaticDimension;
    return 180;
}
-(void)checkDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];
    
    df.dateFormat = @"dd/MM/yyyy";
    NSDate *dateFS = [df dateFromString:self.tfFromDate.text];
    NSDate *dateTS = [df dateFromString:self.tfToDate.text];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    df2.locale = [NSLocale systemLocale];
    df2.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSMutableArray *arrFull = [[NSMutableArray alloc] init];

    for (int i =0; i<arrKeHoachSearch.count; i++) {
        NSDictionary *dic = [arrKeHoachSearch objectAtIndex:i];

        NSDate *dateF = [df2 dateFromString:[dic objectForKey:@"fromdate"]];
        NSComparisonResult result = [dateF compare:dateFS];
        NSComparisonResult result2 = [dateF compare:dateTS];

//        NSDate *dateT = [df2 dateFromString:[dic objectForKey:@"todate"]];
        if (result!=NSOrderedAscending && result2!=NSOrderedDescending) {
            [arrFull addObject:dic];
        }
    }
    arrKeHoachFiller = [arrFull mutableCopy];
    [self updateLableText];
}
- (void)updateLableText
{
    self.lblTongSo.text = [NSString stringWithFormat:@"Tổng số kế hoạch: %d", arrKeHoachFiller.count];
    NSMutableArray *arrKH = [[NSMutableArray alloc] init];
    for (int i =0; i<arrKeHoachFiller.count; i++) {
        NSDictionary *dic = [arrKeHoachFiller objectAtIndex:i];
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
        if (tongSoSP == tongSoSPQR) {
            [arrKH addObject:dic];
        }

    }
    self.lblHoanThanh.text = [NSString stringWithFormat:@"Hoàn thành: %d", arrKH.count];
    self.lblChuaHoanThanh.text = [NSString stringWithFormat:@"Chưa hoàn thành: %d", (arrKeHoachFiller.count - arrKH.count)];

    
}
- (IBAction)btnDateFPressed:(id)sender {
    isFromTo = YES;
    [self performSegueWithIdentifier:@"TimeBaoCaoKeHoach2Identifier" sender:nil];
}

- (IBAction)btnDateTPressed:(id)sender {
    isFromTo = NO;
    [self performSegueWithIdentifier:@"TimeBaoCaoKeHoach2Identifier" sender:nil];
    
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
    [self checkDate];
    [self.tableviewKeHoach reloadData];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"TimeBaoCaoKeHoach2Identifier"]) {
        TimePickerViewController *vc = [segue destinationViewController];
        vc.dateNow = [NSDate date];
        vc.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"XemChiTietKeHoachIdentifier"]) {
        XemChiTietKeHoachViewController *vc = [segue destinationViewController];
        vc.dicKehoach = dicKeHoach;
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        arrKeHoachSearch = arrKeHoach;
    }
    else
    {
        NSPredicate *tenKHPredicate = [NSPredicate
                                       predicateWithFormat:@"%K contains[cd] %@",@"namestore",
                                       searchText];
        
        NSPredicate *tenkehoachPredicate = [NSPredicate
                                            predicateWithFormat:@"%K contains[cd] %@",@"nameplan",
                                            searchText];
        
        NSPredicate *tensnphamPredicate = [NSPredicate
                                           predicateWithFormat:@"%K contains[cd] %@",@"nameuser",
                                           searchText];
//        NSPredicate *modelPredicate = [NSPredicate
//                                       predicateWithFormat:@"%K contains[cd] %@",@"model",
//                                       searchText];
        
        arrKeHoachSearch = [[arrKeHoach filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:@[tenKHPredicate, tenkehoachPredicate, tensnphamPredicate]]] mutableCopy];
        
        
    }
    [self checkDate];
    [self.tableviewKeHoach reloadData];

    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = true;
    return true;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = false;
    return true;
}

@end
