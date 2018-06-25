//
//  DetaiCustomer2ViewController.m
//  Kmanager
//
//  Created by Khánh on 25/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "DetaiCustomer2ViewController.h"
#import "PlanCustomAnnotation.h"
#import "DetailCustomer2TableViewCell.h"
@interface DetaiCustomer2ViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate>
{
    NSDictionary *dic;
    CLLocation * locationNew;

}

@end

@implementation DetaiCustomer2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customerMapView.delegate = self;
    _customerMapView.showsUserLocation = YES;

    _tableviewDetailCustomer.dataSource = self;
    _tableviewDetailCustomer.delegate = self;

    dic = self.dicDetail;
    [self.tableviewDetailCustomer reloadData];
    [self addAnnotion];
    // Do any additional setup after loading the view.
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DetailCustomer2TableViewCellIdentifier";
    
    DetailCustomer2TableViewCell *cell = (DetailCustomer2TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailCustomer2TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"Tên khách hàng: %@", [dic objectForKey:@"name"]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"Mã khách hàng: %@", [dic objectForKey:@"code"]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"Số điện thoại: %@", [dic objectForKey:@"phoneNumber"]];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"Địa chỉ: %@", [dic objectForKey:@"address"]];
            break;
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"Ghi chú: %@", [dic objectForKey:@"note"]];
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
-(void)showViTri : (CLLocation*) vitri{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(vitri.coordinate, 500, 500);
    // NSLog(@"set vi tri %@",vitri);
    [_customerMapView setRegion:region animated:YES];
}
#pragma mark - mapview delegate and MKAnnotationView

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"view for annotion");
    if ([annotation isKindOfClass:[PlanCustomAnnotation class]] == NO){
        return nil;
    }
    
    /* First typecast the annotation for which the Map View has fired this delegate message */
    PlanCustomAnnotation *senderAnnotation = (PlanCustomAnnotation *)annotation;
    
    PlanCustomAnnotationView *annotationView = senderAnnotation.annotationView;
    
    if (annotationView != nil) {
        NSLog(@"annotation already added");
        return (MKAnnotationView*) annotationView;
    } else {
        annotationView = [[PlanCustomAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:nil];
        annotationView.enabled = YES;
        
        [annotationView setPlanImageWithMarkerIndex: 1];
        
        
        senderAnnotation.title = senderAnnotation.storeName;
        senderAnnotation.annotationView = annotationView;
        
    }
    annotationView.canShowCallout =YES;
    return (MKAnnotationView*) annotationView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:[PlanCustomAnnotationView class]]) {
        PlanCustomAnnotationView *customAnnoView = (PlanCustomAnnotationView *)view;
        //            [self._mapView setCenterCoordinate:((CarCustomAnnotation *)customAnnoView.annotation).coordinate animated:YES];
        
        PlanCustomAnnotation *plan = (PlanCustomAnnotation *)customAnnoView.annotation;
        CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:plan.coordinate.latitude longitude:plan.coordinate.longitude];
        [self showViTri:LocationAtual];
        

    }
    
}
-(void)addAnnotion
{
    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[[dic objectForKey:@"latitude"] doubleValue] longitude:[[dic objectForKey:@"longitude"] doubleValue]];
    
    CLLocationCoordinate2D location = [LocationAtual coordinate];
    PlanCustomAnnotation *planAnno = [[PlanCustomAnnotation alloc] initWithName:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]] coordinate:location];
    
    [planAnno updateStatus:1];
    [_customerMapView addAnnotation:planAnno];
    [self showViTri:LocationAtual];

    
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
