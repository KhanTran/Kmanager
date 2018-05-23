//
//  PlanViewController.m
//  Kmanager
//
//  Created by Khánh on 03/03/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "PlanViewController.h"
#import "PlanTableViewCell.h"
#import "BoLocTableViewController.h"
#import "QRScanViewController.h"
#import "GanQRViewController.h"
#import "DanhSachSanPhamDaGanViewController.h"
#import "DanhSachLoaiSPViewController.h"

@interface PlanViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray * arrPlan;
    NSMutableArray * arrPlanSearch;
    BOOL isSearch;
    NSString *qrCode;
    NSString *idProduct;
    NSString *idKeHoach;
    NSArray *arrLoaiSP;

}
@end

@implementation PlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableviewPlan.delegate = self;
    _tableviewPlan.dataSource = self;
//    [self.tableviewPlan registerNib:[UINib nibWithNibName:@"PlanTableViewCell" bundle:nil] forCellReuseIdentifier:@"PlanTableViewCellIdentifier"];

    arrPlan = [[NSMutableArray alloc]init];
    arrPlanSearch = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    isSearch = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestPlan) name:@"ReloadDataPlan" object:nil];

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
    static NSString *simpleTableIdentifier = @"PlanTableViewCellIdentifier";

    PlanTableViewCell *cell = (PlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlanTableViewCell" owner:self options:nil];
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
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate *dateF = [df dateFromString:[dic objectForKey:@"date"]];
    df.dateFormat = @"dd/MM/yyyy";
    cell.lblKh.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"nameplan"]];
    cell.lblMatHang.text = [NSString stringWithFormat:@"%@", [df stringFromDate:dateF]];
//    cell.lblMatHang.text = [NSString stringWithFormat:@"%@ - Model: %@", [dic objectForKey:@"nameproduct"], [dic objectForKey:@"modelproduct"]];
    cell.lblTrangThai.text = [NSString stringWithFormat:@"Trạng thái: %@",[dic objectForKey:@"status"]];
    [cell.btnGanQR addTarget:self action:@selector(btnGanQRAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnGanQR.layer.cornerRadius = cell.btnGanQR.bounds.size.height/4;


    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = [arrPlanSearch objectAtIndex:indexPath.row];
    idKeHoach = [NSString stringWithFormat:@"%@", [dic objectForKey:@"idscheme"]];
    arrLoaiSP = [dic objectForKey:@"arrProduct"];
    [self performSegueWithIdentifier:@"DanhSachLoaiSPIdentifier" sender:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)requestPlan
{
    NSString *url = [NSString stringWithFormat:@"http://svkmanager.herokuapp.com/api/scheme?idlogin=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]];
    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
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

                    [setDic setValue:[dicStatus objectForKey:@"statusName"] forKey:@"status"];
                    [setDic setValue:[dic objectForKey:@"updatedAt"] forKey:@"date"];
                    for (int j =0 ; j <array.count; j++) {
                        NSDictionary *dicScheme = [array objectAtIndex:j];
                        NSMutableDictionary *setDicP = [[NSMutableDictionary alloc] init];

                        [setDicP setValue:[dicScheme objectForKey:@"_id"] forKey:@"idscheme"];
                        [setDicP setValue:[NSString stringWithFormat:@"%@/%@", [dicScheme objectForKey:@"quantityDeployed"],[dicScheme objectForKey:@"quantityDeploy"]] forKey:@"tiendo"];
                        NSDictionary *dicProduct = [dicScheme objectForKey:@"product"];
                        [setDicP setValue:[dicProduct objectForKey:@"name"] forKey:@"nameproduct"];
                        [setDicP setValue:[dicProduct objectForKey:@"model"] forKey:@"modelproduct"];
                        [arrProduct addObject:setDicP];
                    }
                    
                    [setDic setValue:arrProduct forKeyPath:@"arrProduct"];

                    [arrFull addObject:setDic];
                }
                NSPredicate *tenKHPredicate = [NSPredicate
                                               predicateWithFormat:@"%K contains[cd] %@",@"idstore",
                                               _strKhachHang];
                arrPlan = [[arrFull filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:@[tenKHPredicate]]] mutableCopy];
                arrPlanSearch = [arrPlan mutableCopy];
            }
            else
            {
                arrPlan = [[NSMutableArray alloc] init];
                arrPlanSearch = [arrPlan mutableCopy];
            }
            [self.tableviewPlan reloadData];
        }
        else
        {
            
        }
    } ];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"BoLocIndentifier"]) {
        BoLocTableViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        vc.arrItem = [arrPlan copy];
        vc.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"DanhSachSanPhamQRIdentifier"]) {
        DanhSachSanPhamDaGanViewController *vc = [segue destinationViewController];
        vc.strIDKeHach = idKeHoach;
    }
    if ([[segue identifier] isEqualToString:@"DanhSachLoaiSPIdentifier"]) {
        DanhSachLoaiSPViewController *vc = [segue destinationViewController];
        vc.arrLoaiSP = arrLoaiSP;
        vc.strIDKeHoach = idKeHoach;
    }
    else if ([[segue identifier] isEqualToString:@"GanQRIdentifier"]) {
        GanQRViewController *vc = [segue destinationViewController];
        vc.strQRCode = qrCode;
        vc.idProduct = idProduct;
    }

}
- (void)boLocDidClose:(BoLocTableViewController*)boLocVC withListPlan:(NSDictionary*) arrayPlan;
{
    NSPredicate *tenKHPredicate = [NSPredicate
                                   predicateWithFormat:@"%K contains[cd] %@",@"namestore",
                                   [arrayPlan objectForKey:@"nameStore"]];
    
//    NSPredicate *tenkehoachPredicate = [NSPredicate
//                                        predicateWithFormat:@"%K contains[cd] %@",@"nameplan",
//                                        [arrayPlan objectForKey:@"namePlan"]];
//
//    NSPredicate *tensnphamPredicate = [NSPredicate
//                                       predicateWithFormat:@"%K contains[cd] %@",@"nameproduct",
//                                       [arrayPlan objectForKey:@"nameProduct"]];
//    NSPredicate *modelPredicate = [NSPredicate
//                                   predicateWithFormat:@"%K contains[cd] %@",@"model",
//                                   [arrayPlan objectForKey:@"Model"]];
    
    arrPlanSearch = [[arrPlan filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:@[tenKHPredicate]]] mutableCopy];
    [self.tableviewPlan reloadData];

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
    NSString *url = [NSString stringWithFormat:@"http://svkmanager.herokuapp.com/api/qrcode?qrcode=%@", qrCode];
    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
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
@end
