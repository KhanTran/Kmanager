//
//  AdminSanPhamTableViewController.m
//  Kmanager
//
//  Created by Khánh on 23/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "AdminSanPhamTableViewController.h"
#import "Server.h"
#import "Define.h"
#import "AdminSanPhamTableViewCell.h"
#import "ThemSanPhamViewController.h"
@interface AdminSanPhamTableViewController ()
{
    NSMutableArray *arrSanPham;
    NSMutableArray *arrSanPhamSearch;
    NSInteger *isEdit;
    NSDictionary *dicProduct;
}
@end

@implementation AdminSanPhamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrSanPham = [[NSMutableArray alloc] init];
    arrSanPhamSearch = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    [self requestSanPham];
    isEdit = 0;
    _arrayProduct = [[NSMutableArray alloc] init];
    if (_viewMode == 1) {
        [self.btnAdd setTitle:@"Xong"];
    }
    else
    {
        
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
    return arrSanPhamSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"AdminSanPhamTableViewCellIdentifier";
    
    AdminSanPhamTableViewCell *cell = (AdminSanPhamTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminSanPhamTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = [arrSanPhamSearch objectAtIndex:indexPath.row];
    cell.lblTen.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    cell.lblModel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"model"]];
    if (_viewMode == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for (int i = 0; i<_arrayProductID.count; i++) {
            NSString *dicS = [_arrayProductID objectAtIndex:i];
            if ([dicS isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"_id"]]] ) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
            }
            
            
        }
    }
    // Configure the cell...
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary *dic = [arrSanPhamSearch objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_viewMode == 1)
    {
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            //        NSString *idCuaHang = dicSP.idSanPham;
            [_arrayProductID addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"_id"]]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else
        {
            for (int i = 0; i< _arrayProductID.count; i++) {
                NSString *dicS = [_arrayProductID objectAtIndex:i];
                
                if ([[NSString stringWithFormat:@"%@",dicS] isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"_id"]]] ) {
                    [_arrayProductID removeObjectAtIndex:i];
                }
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        isEdit = 1;
        dicProduct = dic;
        [self performSegueWithIdentifier:@"AddProductIdentifier" sender:nil];
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:@"Bạn có chắc muốn xoá sản phẩm này" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"Có" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction* cancelAct = [UIAlertAction actionWithTitle:@"Không" style:UIAlertActionStyleCancel handler:nil];

        [c addAction:cancelAct];
        [c addAction:okAct];

        [self presentViewController:c animated:YES completion:nil];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {

    return @"Xoá";
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"AddProductIdentifier"]) {
        ThemSanPhamViewController *vc = [segue destinationViewController];
        vc.viewMode = isEdit;
        if (isEdit == 1) {
            vc.dicSanPham = dicProduct;
        }
    }
}
-(void)requestSanPham
{
    NSString *url = [NSString stringWithFormat:@"%@product",ServerApi];
    [[Server sharedServer] showAnimation:self.view];

    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        [[Server sharedServer] hideAnimation:self.view];

        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                
                NSArray *arr = data[@"data"];
                arrSanPham = [arr mutableCopy];
                arrSanPhamSearch = [arr mutableCopy];
            }
            else
            {
                NSString *msg = [NSString stringWithFormat:@"%@", @"Không tải được dữ liệu"];
                UIAlertController* c = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [c addAction:okAct];
                [self presentViewController:c animated:YES completion:nil];
                arrSanPham = [[NSMutableArray alloc] init];
                arrSanPhamSearch = [arrSanPham mutableCopy];
            }
            [self.tableView reloadData];
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

- (IBAction)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)btnAddPressed:(id)sender {
    if (_viewMode == 1) {
        for (int i = 0; i<arrSanPhamSearch.count; i++) {
            NSDictionary *dic = [arrSanPhamSearch objectAtIndex:i];
            for (NSString *idSp in _arrayProductID) {
                if ([[NSString stringWithFormat:@"%@",idSp] isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"_id"]]] ) {
                    [_arrayProduct addObject:dic];
                }
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectSanPham:didChooseSanPham:)])
        {
            [self.delegate selectSanPham:self didChooseSanPham:_arrayProduct];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"AddProductIdentifier" sender:nil];
    }
}
@end
