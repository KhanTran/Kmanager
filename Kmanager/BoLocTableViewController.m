//
//  BoLocTableViewController.m
//  Kmanager
//
//  Created by Khánh on 20/03/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "BoLocTableViewController.h"
#import "PlanViewController.h"
@interface BoLocTableViewController ()
{
    NSMutableDictionary *dicObject;
}
@end

@implementation BoLocTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dicObject = [[NSMutableDictionary alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
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
    return _arrItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoLocIndentifier" forIndexPath:indexPath];
    NSDictionary *dic = [_arrItem objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"namestore"]];
//    switch (indexPath.row) {
//        case 0:
//            cell.textLabel.text = @"Khách hàng:";
//            cell.detailTextLabel.text = @"Khách hàng Nguyễn Đức Thắng";
//            break;
//        case 1:
//            cell.textLabel.text = @"Kế hoạch:";
//            cell.detailTextLabel.text = @"Khách hàng Nguyễn Đức Thắng";
//            break;
//        default:
//            break;
//    }
//    cell.textLabel.text = @"Khách hàng:";
//    cell.detailTextLabel.text = @"Khách hàng Nguyễn Đức Thắng";
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_arrItem objectAtIndex:indexPath.row];

//    NSArray *arr = [self.arrItem valueForKey:@"namestore"];
    NSString *strStore = [NSString stringWithFormat:@"%@",[dic objectForKey:@"namestore"]];
    [dicObject setObject:strStore forKey:@"nameStore"];
    [self doneAction:nil];
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
}
- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        if(self.delegate !=nil && [self.delegate respondsToSelector:@selector(boLocDidClose:withListPlan:)])
        {
            [self.delegate boLocDidClose:self withListPlan:dicObject];
        }
    }];

}

- (IBAction)btnBackPressed:(id)sender {
//    PlanViewController *vc = [[PlanViewController alloc] initWithNibName:@"popToViewController" bundle:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
