//
//  ListQRTableViewController.m
//  Kmanager
//
//  Created by Khánh on 25/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "ListQRTableViewController.h"
#import "Server.h"
@interface ListQRTableViewController ()
{
    NSMutableArray *arrQR;
    NSMutableArray *arrQRSearch;

}

@end

@implementation ListQRTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    arrQR = [[NSMutableArray alloc] init];
    arrQRSearch = [[NSMutableArray alloc] init];
    [self requestData];
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
    return arrQRSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QRCellIdentifier" forIndexPath:indexPath];
    NSDictionary *dic = [arrQRSearch objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Mã QR: %@",[dic objectForKey:@"code"]];
    NSDictionary *dicStatus = [dic objectForKey:@"status"];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dicStatus objectForKey:@"statusName"]];

    // Configure the cell...
    
    return cell;
}
-(void)requestData
{
    NSString *url = [NSString stringWithFormat:@"http://svkmanager.herokuapp.com/api/qrcode/all"];
//    if (_viewMode == 3 || _viewMode == 4) {
//        url = [NSString stringWithFormat:@"http://svkmanager.herokuapp.com/api/customer/all?idlogin=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]];
//
//    }
    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                
                NSArray *arr = data[@"data"];
                arrQR = [arr mutableCopy];
                arrQRSearch = [arr mutableCopy];
            }
            else
            {
                arrQR = [[NSMutableArray alloc] init];
                arrQRSearch = [arrQR mutableCopy];
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

- (IBAction)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
