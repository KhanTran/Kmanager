//
//  StaffInformationViewController.m
//  Kmanager
//
//  Created by Khánh on 01/03/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "StaffInformationViewController.h"
#import "TableViewCell.h"

@interface StaffInformationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *dic ;
    

}
@end

@implementation StaffInformationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableviewInfor.delegate = self;
    self.tableviewInfor.dataSource = self;
    dic = _dicThongTinTaiKhoan;
    self.navigationItem.title = @"Thông tin khách hàng";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    dic = _dicThongTinTaiKhoan;
//    [self.tableviewInfor reloadData];
//}

#pragma mark - Mat Hang Table View Delegate and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *simpleTableIdentifier = @"TableViewCell";
        
        TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
//    if (_viewMode == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"Họ và tên: %@", [dic objectForKey:@"fullname"]];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"Số điện thoại: %@", [dic objectForKey:@"phonenumber"]];
                //            cell.backgroundColor =[UIColor colorWithRed:0.84 green:0.89 blue:0.90 alpha:1.0];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"Email: %@", [dic objectForKey:@"email"]];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"Ngày sinh: %@", [dic objectForKey:@"dateofbirth"]];
                //            cell.backgroundColor =[UIColor colorWithRed:0.84 green:0.89 blue:0.90 alpha:1.0];
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"Đổi mật khẩu"];
                //            cell.backgroundColor =[UIColor colorWithRed:0.84 green:0.89 blue:0.90 alpha:1.0];
                break;
            default:
                break;
        }
//    }
//    else
//    {
//        NSDictionary *dic = [_arrMenuSetting objectAtIndex:indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"TenChucNang"]];
//
//    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 4) {
        [self performSegueWithIdentifier:@"changePassIdentifier" sender:nil];
    }
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
