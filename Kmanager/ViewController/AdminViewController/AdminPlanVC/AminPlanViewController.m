//
//  AminPlanViewController.m
//  Kmanager
//
//  Created by Khánh on 04/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "AminPlanViewController.h"
#import "Server.h"
#import "Define.h"
#import "AdminPlanTableViewCell.h"
#import "ThemKeHoachViewController.h"
@interface AminPlanViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrKeHoach;
    NSMutableArray *arrKeHoachSearch;
    NSInteger viewMode;
    NSDictionary *dicKeHoach;
}

@end

@implementation AminPlanViewController

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
    [self requestKeHoach];

    viewMode = 0;
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
    if ([[segue identifier] isEqualToString:@"adminAddPlanIdentifier"]) {
        ThemKeHoachViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        if (viewMode != 0) {
            vc.dicKehoach = dicKeHoach;
        }
        vc.viewMode = viewMode;
    }
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
                arrKeHoachSearch = [arrKeHoach mutableCopy];
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
    return 180;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    dicKeHoach = [arrKeHoachSearch objectAtIndex:indexPath.row];
    viewMode = 1;
    [self performSegueWithIdentifier:@"adminAddPlanIdentifier" sender:nil];

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [arrKeHoachSearch objectAtIndex:indexPath.row];

    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:@"Bạn có chắc muốn xoá sản phẩm này" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"Có" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *url = [NSString stringWithFormat:@"%@scheme",ServerApi];
            NSDictionary * postDic = @{@"_id": [NSString stringWithFormat:@"%@",[dic objectForKey:@"idplan"]]};
            [[Server sharedServer] showAnimation:self.view];

            [[Server sharedServer] deleteData:url param:postDic completion:^(NSError *error, NSDictionary *data) {
                [[Server sharedServer] hideAnimation:self.view];

                if (error == nil) {
                    NSInteger status = [[data objectForKey:@"status"] integerValue];
                    if (status == true) {
                        NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
                        UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self requestKeHoach];
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
            }];
        }];
        UIAlertAction* cancelAct = [UIAlertAction actionWithTitle:@"Không" style:UIAlertActionStyleCancel handler:nil];
        
        [c addAction:cancelAct];
        [c addAction:okAct];
        
        [self presentViewController:c animated:YES completion:nil];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Xoá";
}
-(void)deleteSanPham
{
    
}
- (IBAction)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddPressed:(id)sender {
    [self performSegueWithIdentifier:@"adminAddPlanIdentifier" sender:nil];
}
@end
