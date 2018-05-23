//
//  AdminHomeViewController.m
//  Kmanager
//
//  Created by Khánh on 03/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "AdminHomeViewController.h"
#import "AdminHomeCollectionViewCell.h"
#import "CustomerTableViewController.h"
@interface AdminHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger viewMode;

}
@end

@implementation AdminHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _homeCollectionView.dataSource = self;
    _homeCollectionView.delegate = self;
//    [_homeCollectionView registerNib:[UINib nibWithNibName:@"AdminHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AdminHomeCollectionViewCell"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"AdminHomeCollectionViewCell";
    
    AdminHomeCollectionViewCell *cell = (AdminHomeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminHomeCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    switch (indexPath.row) {
        case 0:
            cell.imageIcon.image = [UIImage imageNamed:@"notebook-with-bookmark.png"];
            cell.lblTitle.text = @"Quản lý kế hoạch";
            break;
        case 1:
            cell.imageIcon.image = [UIImage imageNamed:@"user-list.png"];
            cell.lblTitle.text = @"Quản lý khách hàng";
            break;
        case 2:
            cell.imageIcon.image = [UIImage imageNamed:@"user-list.png"];
            cell.lblTitle.text = @"Quản lý nhân viên";
            break;
        case 3:
            cell.imageIcon.image = [UIImage imageNamed:@"list.png"];
            cell.lblTitle.text = @"Danh sách mã QR";
            break;
        case 4:
            cell.imageIcon.image = [UIImage imageNamed:@"package.png"];
            cell.lblTitle.text = @"Danh sách sản phẩm";
            break;
        case 5:
            cell.imageIcon.image = [UIImage imageNamed:@"pie-chart.png"];
            cell.lblTitle.text = @"Báo cáo";
            break;
        case 6:
            cell.imageIcon.image = [UIImage imageNamed:@"street-map.png"];
            cell.lblTitle.text = @"Vị trí khách hàng";
            break;
        case 7:
            cell.imageIcon.image = [UIImage imageNamed:@"street-map.png"];
            cell.lblTitle.text = @"Vị trí khách hàng";
            break;
        default:
            break;
    }
//    NSMutableArray *arrChucNang = [[NSMutableArray alloc] initWithArray:_arrMenu];
//    NSDictionary *dic = [arrMenuChucNang objectAtIndex:indexPath.row];
//    NSString *strIdChucNang = [NSString stringWithFormat:@"%@", [dic objectForKey:@"TenChucNang"]];
//    NSString *strIcon = [NSString stringWithFormat:@"%@", [dic objectForKey:@"TenIcon"]];
//
//    cell.nameLbl.text =strIdChucNang;
//    cell.iconIV.image = [UIImage imageNamed:strIcon];
//    ////    cell.iconIV.image = [UIImage imageNamed:@"button"];
//    ////    cell.nameLbl.text =@"Đăng xuất";
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CGSize size = CGSizeMake(_homeCollectionView.frame.size.width/2 - 2.5, _homeCollectionView.frame.size.height/3 - 5);
    
    return size;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"adminPlanIdentifier" sender:nil];
            break;
//        case 3:
//            viewMode = 1;
//            [self performSegueWithIdentifier:@"customerIdentifier" sender:nil];
//            break;
        case 1:
            viewMode = 4;
            [self performSegueWithIdentifier:@"adminCustomerIdentifier" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"NhanVienIdentifier" sender:nil];
            break;
//        case 4:
//            [self scanQRCodeAction];
//            break;
        default:
//            [self performSegueWithIdentifier:@"infoIdentifier" sender:nil];
            break;
    }
    NSLog(@"%ld",indexPath.row);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([[segue identifier] isEqualToString:@"staffInformationIdentifier"]) {
//        StaffInformationViewController *vc = [segue destinationViewController];
//        vc.dicThongTinTaiKhoan = _dicThongTinTaiKhoan;
//        vc.viewMode = viewMode;
//        vc.arrMenuSetting = arrMenuSetting;
//    }
    if ([[segue identifier] isEqualToString:@"adminCustomerIdentifier"]) {
        CustomerTableViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        vc.viewMode = viewMode;
    }
//    if ([[segue identifier] isEqualToString:@"ScanDetailQR"]) {
//        DetailCustomerTableViewController *vc = [segue destinationViewController];
//        vc.qrcode = qrCode;
//    }
    
}


@end
