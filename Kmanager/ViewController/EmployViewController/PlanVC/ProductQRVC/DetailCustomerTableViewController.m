//
//  DetailCustomerTableViewController.m
//  Kmanager
//
//  Created by Khánh on 23/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "DetailCustomerTableViewController.h"
#import "Server.h"
#import "Define.h"
#import "DetailProductTableViewCell.h"
@interface DetailCustomerTableViewController ()
{
    NSDictionary *dic;
    NSMutableArray *arrPlanSearch;
    NSMutableArray *arrPlan;

}
@end

@implementation DetailCustomerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrPlan = [[NSMutableArray alloc] init];
    arrPlanSearch = [[NSMutableArray alloc] init];
    [self.navigationItem setTitle:@"Chi tiết sản phẩm"];

    [self requestPlan];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    dic = self.dicDetail;
//    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *simpleTableIdentifier = @"DetailCustomerTableViewCellIdentifier";
    
    DetailProductTableViewCell *cell = (DetailProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailProductTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate *dateF = [df dateFromString:[dic objectForKey:@"datefrom"]];
    NSDate *dateT = [df dateFromString:[dic objectForKey:@"dateto"]];
    df.dateFormat = @"dd/MM/yyyy";
    switch (indexPath.row) {
        case 0:
            cell.lblText.text = [NSString stringWithFormat:@"Tên sản phẩm: %@", [dic objectForKey:@"nameproduct"]];
            if ([dic objectForKey:@"nameproduct"] == nil || [dic objectForKey:@"nameproduct"] == [NSNull null]) {
                cell.lblText.text = @"";
            }
            break;
        case 1:
            cell.lblText.text = [NSString stringWithFormat:@"Model: %@", [dic objectForKey:@"modelproduct"]];
            if ([dic objectForKey:@"modelproduct"] == nil || [dic objectForKey:@"modelproduct"] == [NSNull null]) {
                cell.lblText.text = @"";
            }
            break;
        case 2:
            cell.lblText.text = [NSString stringWithFormat:@"Mã QR: %@", [dic objectForKey:@"qrcode"]];
            if ([dic objectForKey:@"qrcode"] == nil || [dic objectForKey:@"qrcode"] == [NSNull null]) {
                cell.lblText.text = @"";
            }
            break;
        case 3:
            cell.lblText.text = [NSString stringWithFormat:@"Serial: %@", [dic objectForKey:@"serial"]];
            if ([dic objectForKey:@"nameproduct"] == nil || [dic objectForKey:@"nameproduct"] == [NSNull null]) {
                cell.lblText.text = @"";
            }
            break;
        case 4:
            cell.lblText.text = [NSString stringWithFormat:@"Thời gian bảo hành: %@ - %@", [df stringFromDate:dateF], [df stringFromDate:dateT]];
            if ([dic objectForKey:@"datefrom"] == nil || [dic objectForKey:@"datefrom"] == [NSNull null]) {
                cell.lblText.text = @"";
            }
            break;
        case 5:
            cell.lblText.text = [NSString stringWithFormat:@"Thông tin sản phẩm: \n%@", [dic objectForKey:@"infoproduct"]];
            if ([dic objectForKey:@"infoproduct"] == nil || [dic objectForKey:@"infoproduct"] == [NSNull null]) {
                cell.lblText.text = @"";
            }
            break;
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
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
                    [setDic setValue:[dicProduct objectForKey:@"info"] forKey:@"infoproduct"];

                    //                    [setDic setValue:[NSString stringWithFormat:@"%@/%@", [dicScheme objectForKey:@"quantityDeployed"],[dicScheme objectForKey:@"quantityDeploy"]] forKey:@"tiendo"];
                    //                    [setDic setValue:[dicStatus objectForKey:@"statusName"] forKey:@"status"];
                    
                    
                    [arrFull addObject:setDic];
                }
                NSPredicate *idKHPredicate = [NSPredicate
                                              predicateWithFormat:@"%K contains[cd] %@",@"qrcode",
                                              _qrcode];
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
            if (arrPlan.count > 0) {
                dic = [arrPlan objectAtIndex:0];
            }
            [self.tableView reloadData];
        }
        else
        {
            
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

@end
