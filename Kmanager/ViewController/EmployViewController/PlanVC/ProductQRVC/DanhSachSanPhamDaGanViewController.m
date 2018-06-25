//
//  DanhSachSanPhamDaGanViewController.m
//  Kmanager
//
//  Created by Khánh on 26/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "DanhSachSanPhamDaGanViewController.h"
#import "DanhSachSanPhamDaGanTableViewCell.h"
#import "Server.h"
#import "Define.h"
#import "QRScanViewController.h"
#import "DetailCustomerTableViewController.h"
@interface DanhSachSanPhamDaGanViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray * arrPlan;
    NSMutableArray * arrPlanSearch;
    BOOL isSearch;
    NSString *qrCode;
    NSString *idProduct;
}
@end

@implementation DanhSachSanPhamDaGanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableviewListProductQR.dataSource = self;
    self.tableviewListProductQR.delegate = self;
    self.searchBar.delegate = self;
    arrPlan = [[NSMutableArray alloc] init];
    arrPlanSearch = [[NSMutableArray alloc] init];
    [self.navigationItem setTitle:@"Sản phẩm"];

    [self requestPlan];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.tableviewListProductQR reloadData];
    
}
#pragma mark - Table View Delegate and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return arrPlanSearch.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"DanhSachSanPhamDaGanIdentifier";
    
    DanhSachSanPhamDaGanTableViewCell *cell = (DanhSachSanPhamDaGanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DanhSachSanPhamDaGanTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = [arrPlanSearch objectAtIndex:indexPath.row];

    cell.lblQRCode.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"qrcode"]];
    cell.lblSerial.text = [NSString stringWithFormat:@"Serial: %@", [dic objectForKey:@"serial"]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate *dateF = [df dateFromString:[dic objectForKey:@"datefrom"]];
    NSDate *dateT = [df dateFromString:[dic objectForKey:@"dateto"]];
    df.dateFormat = @"dd/MM/yyyy";

    cell.lblTime.text = [NSString stringWithFormat:@"Bảo hành: %@ - %@", [df stringFromDate:dateF], [df stringFromDate:dateT]];
    cell.lblProduct.text = [NSString stringWithFormat:@"%@ - Model: %@",[dic objectForKey:@"nameproduct"], [dic objectForKey:@"modelproduct"]];
    [cell.btnGanQRCode addTarget:self action:@selector(btnGanQRCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnGanQRCode.layer.cornerRadius = cell.btnGanQRCode.bounds.size.height/4;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = [arrPlanSearch objectAtIndex:indexPath.row];

    qrCode = [NSString stringWithFormat:@"%@", [dic objectForKey:@"qrcode"]];
    [self performSegueWithIdentifier:@"DetailProductQRIdentifier" sender:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(void)requestPlan
{
    NSString *url = [NSString stringWithFormat:@"%@schemeProductDetail?idlogin=%@", ServerApi, [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]];
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        [[Server sharedServer] hideAnimation:self.view];

        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                
                NSArray *arr = data[@"data"];
                NSMutableArray *arrFull = [[NSMutableArray alloc] init];
                for (int i =0; i<arr.count; i++) {
                    NSDictionary *dic = [arr objectAtIndex:i];
                    NSDictionary *dicScheme = [dic objectForKey:@"schemeProduct"];
                    NSDictionary *dicQRCode = [dic objectForKey:@"qrCode"];
                    NSDictionary *dicProduct = [dicScheme objectForKey:@"product"];
//                    NSDictionary *dicStatus = [dic objectForKey:@"status"];
                    
                    NSMutableDictionary *setDic = [[NSMutableDictionary alloc] init];
                    [setDic setValue:[dicQRCode objectForKey:@"code"] forKey:@"qrcode"];
//                    [setDic setValue:[dicCustomer objectForKey:@"_id"] forKey:@"idstore"];
                    [setDic setValue:[dicScheme objectForKey:@"_id"] forKey:@"idscheme"];
                    [setDic setValue:[dic objectForKey:@"serial"] forKey:@"serial"];
                    [setDic setValue:[dic objectForKey:@"dateFrom"] forKey:@"datefrom"];
                    [setDic setValue:[dic objectForKey:@"dateTo"] forKey:@"dateto"];
                    [setDic setValue:[dicProduct objectForKey:@"name"] forKey:@"nameproduct"];
                    [setDic setValue:[dicProduct objectForKey:@"model"] forKey:@"modelproduct"];
                    [setDic setValue:[dicProduct objectForKey:@"_id"] forKey:@"idproduct"];

//                    [setDic setValue:[NSString stringWithFormat:@"%@/%@", [dicScheme objectForKey:@"quantityDeployed"],[dicScheme objectForKey:@"quantityDeploy"]] forKey:@"tiendo"];
//                    [setDic setValue:[dicStatus objectForKey:@"statusName"] forKey:@"status"];
                    
                    
                    [arrFull addObject:setDic];
                }
                NSPredicate *idKHPredicate = [NSPredicate
                                               predicateWithFormat:@"%K contains[cd] %@",@"idscheme",
                                               _strIDKeHach];
//                NSPredicate *idSPPredicate = [NSPredicate
//                                               predicateWithFormat:@"%K contains[cd] %@",@"idproduct",
//                                               _idProduct];

                arrPlan = [[arrFull filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:@[idKHPredicate]]] mutableCopy];
                arrPlanSearch = [arrPlan mutableCopy];
            }
            else
            {
                NSString *msg = [NSString stringWithFormat:@"%@", @"Không tải được dữ liệu"];
                UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [c addAction:okAct];
                [self presentViewController:c animated:YES completion:nil];
                arrPlan = [[NSMutableArray alloc] init];
                arrPlanSearch = [arrPlan mutableCopy];
            }
            [self.tableviewListProductQR reloadData];
        }
        else
        {
            
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
    NSString *url = [NSString stringWithFormat:@"%@qrcode?qrcode=%@", ServerApi,qrCode];
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        [[Server sharedServer] hideAnimation:self.view];

        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                [self requestGanDeQR];
                
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
-(void)btnGanQRCodeAction:(id)sender {
    UIButton *button = sender;
    CGPoint correctedPoint = [button convertPoint:button.bounds.origin toView:self.tableviewListProductQR];
    NSIndexPath *indexPath = [self.tableviewListProductQR indexPathForRowAtPoint:correctedPoint];
    
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
-(void)requestGanDeQR
{
    NSString *url = [NSString stringWithFormat:@"%@schemeProductDetail?idschemeproductdetail=%@&qrcode=%@", ServerApi,idProduct,qrCode];
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer] putData:url param:@{} completion:^(NSError *error, NSDictionary *data){
        [[Server sharedServer] hideAnimation:self.view];

        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
                UIAlertController* c = [UIAlertController alertControllerWithTitle:@"Lỗi!" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([[segue identifier] isEqualToString:@"DetailProductQRIdentifier"]) {
        DetailCustomerTableViewController *vc = [segue destinationViewController];
        vc.qrcode = qrCode;
    }
    
}
@end
