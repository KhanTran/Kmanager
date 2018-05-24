//
//  AdminSanPhamTableViewController.m
//  Kmanager
//
//  Created by Khánh on 23/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "AdminSanPhamTableViewController.h"
#import "Server.h"
#import "AdminSanPhamTableViewCell.h"
@interface AdminSanPhamTableViewController ()
{
    NSMutableArray *arrSanPham;
    NSMutableArray *arrSanPhamSearch;
}
@end

@implementation AdminSanPhamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrSanPham = [[NSMutableArray alloc] init];
    arrSanPhamSearch = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self requestSanPham];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [self performSegueWithIdentifier:@"AddProductIdentifier" sender:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)requestSanPham
{
    NSString *url = [NSString stringWithFormat:@"http://svkmanager.herokuapp.com/api/product"];
    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                
                NSArray *arr = data[@"data"];
                arrSanPham = [arr mutableCopy];
                arrSanPhamSearch = [arr mutableCopy];
            }
            else
            {
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
    [self performSegueWithIdentifier:@"AddProductIdentifier" sender:nil];
}
@end
