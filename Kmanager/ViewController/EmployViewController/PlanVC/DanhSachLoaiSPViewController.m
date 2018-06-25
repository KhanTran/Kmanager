//
//  DanhSachLoaiSPViewController.m
//  Kmanager
//
//  Created by Khánh on 26/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "DanhSachLoaiSPViewController.h"
#import "QRScanViewController.h"
#import "GanQRViewController.h"
#import "PlanTableViewCell.h"
#import "Server.h"
#import "DanhSachLoaiSPTableViewCell.h"
#import "DanhSachSanPhamDaGanViewController.h"
#import "Define.h"
@interface DanhSachLoaiSPViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray * arrPlan;
    NSMutableArray * arrPlanSearch;
    BOOL isSearch;
    NSString *qrCode;
    NSString *idProduct;
    NSString *idKeHoach;
}
@end

@implementation DanhSachLoaiSPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableviewPlan.delegate = self;
    _tableviewPlan.dataSource = self;
    self.searchBar.delegate = self;
    isSearch = NO;
    arrPlan = [[NSMutableArray alloc]init];
    arrPlanSearch = [[NSMutableArray alloc] init];
    [self.navigationItem setTitle:@"Loại sản phẩm"];
    [self requestPlan];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Mat Hang Table View Delegate and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isSearch = NO;
        arrPlanSearch = arrPlan;
    }
    else
    {
        isSearch = YES;
        NSPredicate *tenKHPredicate = [NSPredicate
                                       predicateWithFormat:@"%K contains[cd] %@",@"namestore",
                                       searchText];
        
        NSPredicate *tenkehoachPredicate = [NSPredicate
                                            predicateWithFormat:@"%K contains[cd] %@",@"nameplan",
                                            searchText];
        
        NSPredicate *tensnphamPredicate = [NSPredicate
                                           predicateWithFormat:@"%K contains[cd] %@",@"nameproduct",
                                           searchText];
        NSPredicate *modelPredicate = [NSPredicate
                                       predicateWithFormat:@"%K contains[cd] %@",@"model",
                                       searchText];
        
        arrPlanSearch = [[arrPlan filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:@[tenKHPredicate, tenkehoachPredicate, tensnphamPredicate, modelPredicate]]] mutableCopy];
        
        
    }
    [self.tableviewPlan reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (_viewMode == 1) {
    //        return 4;
    //    }
    //    else
    //    {
    //        return _arrMenuSetting.count;
    //    }
    return arrPlanSearch.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"DanhSachLoaiSPTableViewCellIdentifier";
    
    DanhSachLoaiSPTableViewCell *cell = (DanhSachLoaiSPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DanhSachLoaiSPTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = [arrPlanSearch objectAtIndex:indexPath.row];
    //    NSArray *arr = [dic objectForKey:@"schemeProducts"];
    //    NSDictionary *dicCustomer = [dic objectForKey:@"customer"];
    //    NSDictionary *dicScheme = [arr objectAtIndex:0];
    //    NSDictionary *dicProduct = [dicScheme objectForKey:@"product"];
    //
    //    cell.lblKh.text = [NSString stringWithFormat:@"%@", [dicCustomer objectForKey:@"name"]];
    //    cell.lblKeHoach.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    //    cell.lblMatHang.text = [NSString stringWithFormat:@"%@ - Model: %@", [dicProduct objectForKey:@"name"], [dicProduct objectForKey:@"model"]];
    //    cell.lblTrangThai.text = [NSString stringWithFormat:@"Tiến độ: %@/%@", [dicScheme objectForKey:@"quantityDeployed"],[dicScheme objectForKey:@"quantityDeploy"]];
//    cell.lblKh.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"namestore"]];
//    cell.lblKeHoach.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"nameplan"]];
    cell.lblQRCode.text = [NSString stringWithFormat:@"%@ - Model: %@", [dic objectForKey:@"nameproduct"], [dic objectForKey:@"modelproduct"]];
    cell.lblProduct.text = [NSString stringWithFormat:@"Tiến độ: %@",[dic objectForKey:@"tiendo"]];
    [cell.btnGanQRCode addTarget:self action:@selector(btnGanQRAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnGanQRCode.layer.cornerRadius = cell.btnGanQRCode.bounds.size.height/4;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = [arrPlanSearch objectAtIndex:indexPath.row];
    idKeHoach = [NSString stringWithFormat:@"%@", [dic objectForKey:@"idscheme"]];
    [self performSegueWithIdentifier:@"DanhSachSanPhamQRIdentifier" sender:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(void)requestPlan
{
    arrPlan = [_arrLoaiSP mutableCopy];
    arrPlanSearch = arrPlan;
    [self.tableviewPlan reloadData];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([[segue identifier] isEqualToString:@"BoLocIndentifier"]) {
//        BoLocTableViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
//        vc.arrItem = [arrPlan copy];
//        vc.delegate = self;
//    }
    if ([[segue identifier] isEqualToString:@"DanhSachSanPhamQRIdentifier"]) {
        DanhSachSanPhamDaGanViewController *vc = [segue destinationViewController];
        vc.strIDKeHach = idKeHoach;
        vc.idProduct = idProduct;

    }

    else if ([[segue identifier] isEqualToString:@"GanQRIdentifier"]) {
        GanQRViewController *vc = [segue destinationViewController];
        vc.strQRCode = qrCode;
        vc.idProduct = idProduct;
    }
    
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)locAction:(id)sender {
    [self performSegueWithIdentifier:@"BoLocIndentifier" sender:nil];
}
-(void)btnGanQRAction:(id)sender {
    UIButton *button = sender;
    CGPoint correctedPoint = [button convertPoint:button.bounds.origin toView:self.tableviewPlan];
    NSIndexPath *indexPath = [self.tableviewPlan indexPathForRowAtPoint:correctedPoint];
    
    NSDictionary * dic = [arrPlanSearch objectAtIndex:indexPath.row];
    idProduct = [NSString stringWithFormat:@"%@",[dic objectForKey:@"idscheme"]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        QRScanViewController *vc = [[QRScanViewController alloc] initWithNibName:@"QRScanViewController" bundle:nil];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lỗi!" message:@"Thiết bị không hỗ trợ camera" delegate:nil cancelButtonTitle:@"Xong" otherButtonTitles:nil];
        
        [alert show];
    }
}
#pragma mark - QRCodeReader Delegate Methods
-(void)qrScanSuccess :(QRScanViewController*)qrScan withResult :(NSString*)results;
{
    //    [qrScan stopReading];
    qrCode = results;
    [self dismissViewControllerAnimated:YES completion:^{
        [self requestGetData:results];
        
    }];
}
-(void)requestGetData:(NSString*)qrCode

{
    NSString *url = [NSString stringWithFormat:@"%@qrcode?qrcode=%@", ServerApi, qrCode];
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        [[Server sharedServer] hideAnimation:self.view];

        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                [self performSegueWithIdentifier:@"GanQRIdentifier" sender:nil];
                
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
