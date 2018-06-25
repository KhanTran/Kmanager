//
//  HomeViewController.m
//  Kmanager
//
//  Created by Khánh on 12/02/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "StaffInformationViewController.h"
#import "CustomerTableViewController.h"
#import "Server.h"
#import "Define.h"
#import "QRScanViewController.h"
#import "DetailCustomerTableViewController.h"
@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray * arrMenuChucNang;
    NSMutableArray * arrMenuSetting;
    NSInteger viewMode;
    NSString *qrCode;

}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _homeCollectionView.dataSource = self;
    _homeCollectionView.delegate = self;
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    arrMenuChucNang = [[NSMutableArray alloc] init];
    arrMenuSetting = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutApp) name:@"LogoutApp" object:nil];

    [self getMenu];
    
//    [_homeCollectionView setBounces:NO];

//    [_homeCollectionView setCollectionViewLayout:_flowLayout];

    [_homeCollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];

    // Do any additional setup after loading the view.
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
    if ([[segue identifier] isEqualToString:@"staffInformationIdentifier"]) {
        StaffInformationViewController *vc = [segue destinationViewController];
        vc.dicThongTinTaiKhoan = _dicThongTinTaiKhoan;
        vc.viewMode = viewMode;
        vc.arrMenuSetting = arrMenuSetting;
    }
    if ([[segue identifier] isEqualToString:@"customerIdentifier"]) {
        CustomerTableViewController *vc = [(UINavigationController*)[segue destinationViewController] topViewController];
        vc.viewMode = viewMode;
    }
    if ([[segue identifier] isEqualToString:@"ScanDetailQR"]) {
        DetailCustomerTableViewController *vc = [segue destinationViewController];
        vc.qrcode = qrCode;
    }

}
//MARK: Collection View delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrMenuChucNang.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"HomeCollectionViewCell";
    
    HomeCollectionViewCell *cell = (HomeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSMutableArray *arrChucNang = [[NSMutableArray alloc] initWithArray:_arrMenu];
    NSDictionary *dic = [arrMenuChucNang objectAtIndex:indexPath.row];
    NSString *strIdChucNang = [NSString stringWithFormat:@"%@", [dic objectForKey:@"TenChucNang"]];
    NSString *strIcon = [NSString stringWithFormat:@"%@", [dic objectForKey:@"TenIcon"]];

    cell.nameLbl.text =strIdChucNang;
    cell.iconIV.image = [UIImage imageNamed:strIcon];
////    cell.iconIV.image = [UIImage imageNamed:@"button"];
////    cell.nameLbl.text =@"Đăng xuất";

    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat screenScale = [[UIScreen mainScreen] scale];
//    if (screenScale == 2) {
//        return CGSizeMake(85, 100);
//    }
    CGSize size = CGSizeMake(_homeCollectionView.frame.size.width/3, _homeCollectionView.frame.size.height/3.05);

    return size;
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    float cellWidth = screenWidth / 3.2; //Replace the divisor with the column count requirement. Make sure to have it in float.
//    CGFloat screenHeight = screenRect.size.height;
//    float cellHeight = screenHeight/3.0;
//
//
//    CGSize size = CGSizeMake(cellWidth, cellHeight);
//    return size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"staffInformationIdentifier" sender:nil];
            break;
        case 3:
            viewMode = 1;
            [self performSegueWithIdentifier:@"customerIdentifier" sender:nil];
            break;
        case 1:
            viewMode = 2;
            [self performSegueWithIdentifier:@"customerIdentifier" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"mapIdentifier" sender:nil];
            break;
        case 4:
            [self scanQRCodeAction];
            break;
        case 5:
            [self performSegueWithIdentifier:@"BaoCaoKeHoachNhanVienIdentifier" sender:nil];
            break;
//        case 4:
//            [self scanQRCodeAction];
//            break;
        default:
            [self performSegueWithIdentifier:@"infoIdentifier" sender:nil];
            break;
    }
    NSLog(@"%ld",indexPath.row);
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGFloat pageWidth = _homeCollectionView.frame.size.width;
//    float currentPage = _homeCollectionView.contentOffset.x / pageWidth;
//
//    if (0.0f != fmodf(currentPage, 1.0f)) {
//        _pageControl.currentPage = currentPage + 1;
//    } else {
//        _pageControl.currentPage = currentPage;
//    }
//    NSLog(@"finishPage: %d", _pageControl.currentPage);
//}
-(void) getMenu
{
    for (int i = 0; i< _arrMenu.count; i++) {
        NSMutableArray *arrChucNang = [[NSMutableArray alloc] initWithArray:_arrMenu];
        NSDictionary *dic = [arrChucNang objectAtIndex:i];
        NSDictionary *postDic = [[NSDictionary alloc] init];
        NSString *strIdChucNang = [NSString stringWithFormat:@"%@", [dic objectForKey:@"mcode"]];
        if ([strIdChucNang isEqualToString:@"APP01"]) {
            postDic = @{@"TenChucNang":@"Thông tin tài khoản",
                        @"STT":@1,
                        @"TenIcon":@"avatar.png",
                        @"isSetting":@false
                        };
            [arrMenuChucNang addObject:postDic];
        }
        else    if ([strIdChucNang isEqualToString:@"APP02"]) {
            postDic = @{@"TenChucNang":@"Xem kế hoạch",
                        @"STT":@4,
                        @"TenIcon":@"list.png",
                        @"isSetting":@false
                        };
            [arrMenuChucNang addObject:postDic];
            postDic = @{@"TenChucNang":@"Quét QR",
                        @"STT":@5,
                        @"TenIcon":@"blackberry-qr-code-variant.png",
                        @"isSetting":@false
                        };
            [arrMenuChucNang addObject:postDic];

        }
        else    if ([strIdChucNang isEqualToString:@"APP03"]) {
            postDic = @{@"TenChucNang":@"Danh sách khách hàng",
                        @"STT":@2,
                        @"TenIcon":@"list-with-possible-workers-to-choose.png",
                        @"isSetting":@false

                        };
            [arrMenuChucNang addObject:postDic];
            postDic = @{@"TenChucNang":@"Vị trí khách hàng",
                        @"STT":@3,
                        @"TenIcon":@"street-map.png",
                        @"isSetting":@false
                        
                        };
            [arrMenuChucNang addObject:postDic];

        }
//        else    if ([strIdChucNang isEqualToString:@"APP07"]) {
//
//            postDic = @{@"TenChucNang":@"Cài đặt",
//                        @"STT":@7,
//                        @"TenIcon":@"settings.png",
//                        @"isSetting":@false
//                        };
//            [arrMenuChucNang addObject:postDic];
//        }
//        else    if ([strIdChucNang isEqualToString:@"APP06"]) {
//            postDic = @{@"TenChucNang":@"Đổi mật khẩu",
//                        @"STT":@6,
//                        @"TenIcon":@"list-with-possible-workers-to-choose.png",
//                        @"isSetting":@true
//                        };
//            [arrMenuSetting addObject:postDic];
//        }
        else    if ([strIdChucNang isEqualToString:@"APP05"]) {
            postDic = @{@"TenChucNang":@"Báo cáo",
                        @"STT":@6,
                        @"TenIcon":@"pie-chart",
                        @"isSetting":@false
                        };
            [arrMenuChucNang addObject:postDic];
            postDic = @{@"TenChucNang":@"Liên hệ",
                        @"STT":@7,
                        @"TenIcon":@"information.png",
                        @"isSetting":@false
                        };
            [arrMenuChucNang addObject:postDic];
        }
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"STT" ascending:YES];
        [arrMenuChucNang sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
        [arrMenuSetting sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];

    }
    [self.homeCollectionView reloadData];
}

- (IBAction)logoutAction:(id)sender {
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer] logoutWithUsername:[_dicThongTinTaiKhoan objectForKey:@"_id"] token:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] completion:^(NSError *error, NSDictionary *data) {
        [[Server sharedServer] hideAnimation:self.view];

        if (error == nil) {
            NSLog(@"Login success! \n ----------------------------------\n %@", data);
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status != 0) {
                NSString *msg = [NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]];
                [self dismissViewControllerAnimated:true completion:nil];
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
-(void)logoutApp
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - QRCodeReader Delegate Methods
-(void)qrScanSuccess :(QRScanViewController*)qrScan withResult :(NSString*)results;
{
    //    [qrScan stopReading];
    qrCode = results;
    
    [self dismissViewControllerAnimated:YES completion:^{
//        [self requestGetData:results];
        [self performSegueWithIdentifier:@"ScanDetailQR" sender:nil];
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
                [self performSegueWithIdentifier:@"ScanDetailQR" sender:nil];
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
-(void)scanQRCodeAction{
//    UIButton *button = sender;
//    CGPoint correctedPoint = [button convertPoint:button.bounds.origin toView:self.tableviewListProductQR];
//    NSIndexPath *indexPath = [self.tableviewListProductQR indexPathForRowAtPoint:correctedPoint];
//    
//    NSDictionary * dic = [arrPlanSearch objectAtIndex:indexPath.row];
//    idProduct = [NSString stringWithFormat:@"%@",[dic objectForKey:@"idscheme"]];
    
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

@end
