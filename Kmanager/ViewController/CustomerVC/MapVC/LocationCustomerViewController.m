//
//  LocationCustomerViewController.m
//  Kmanager
//
//  Created by Khánh on 23/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "LocationCustomerViewController.h"
#import "PlanCustomAnnotation.h"
#import "Server.h"
@interface LocationCustomerViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate>
{
    CLLocation * locationNew;
    NSInteger status;
    NSMutableArray *arrCustomer;
    PlanCustomAnnotation *lastPlanAnno;
}

@end

@implementation LocationCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customerMapView.delegate = self;
    _customerMapView.showsUserLocation = YES;
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.numberOfTouchesRequired = 1;

    lpgr.minimumPressDuration = 0.5;
    lpgr.delegate = self;
    [self.customerMapView addGestureRecognizer:lpgr];
    _btnLocation.layer.cornerRadius = 3;
    _btnLocation.layer.shadowColor = [UIColor blackColor].CGColor;
    _btnLocation.layer.shadowOpacity = 0.7;
    _btnLocation.layer.shadowRadius = 1.5;
    _btnLocation.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    arrCustomer = [[NSMutableArray alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
//    [self.locationManager requestWhenInUseAuthorization];
//    [self.locationManager requestAlwaysAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 100;
    [self.locationManager startUpdatingLocation];
    status=1;
    lastPlanAnno = [[PlanCustomAnnotation alloc] init];

//    [lpgr release];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - location delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    locationNew =[locations lastObject];
    
    if(locationNew.coordinate.latitude>1.0 && locationNew.coordinate.longitude >1.0)
    {
        //        [self showViTri : locationNew];
        NSMutableArray * annotationsToRemove = [ _customerMapView.annotations mutableCopy ] ;
        [ annotationsToRemove removeObject:_customerMapView.userLocation ] ;
        [ _customerMapView removeAnnotations:annotationsToRemove ] ;
        //        if(!first){
        //            first=true;
        [self requestCustomer];
//        [self addAnnotion];
        
        [self.locationManager stopUpdatingLocation];
        CLLocationCoordinate2D location = [locationNew coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 500, 500);
        [self.customerMapView setRegion:region animated:YES];
        //        }
//        [self addAnnotionMaker];
        //        NSMutableArray * annotationsToRemove = [ mapView.annotations mutableCopy ] ;
        //        //        [ annotationsToRemove removeObject:mapView.userLocation ] ;
        //        [ mapView removeAnnotations:annotationsToRemove ] ;
        //        [self addAnnotion];
    }
    //
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}
//-(void)addAnnotionMaker
//{
//
//    CLLocationCoordinate2D location = [locationNew coordinate];
//    PlanCustomAnnotation *planAnno = [[PlanCustomAnnotation alloc] initWithName:@"Vị trí của bạn" coordinate:location avatarImgName:@"mylocationicon.png" ];
//    status=1;
//    [planAnno updateStatus:3];
//
//    [self.customerMapView addAnnotation:planAnno];
//
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 500, 500);
//    [self.customerMapView setRegion:region animated:YES];
//
//
//
//}

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

        // [self showPopUpView];
        //        plan.title = [NSString stringWithFormat:@"%@",plan.storeName];
        //        plan.title =plan.storeName;
        // NSLog(@"chon cua hang %@",plan.storeName);
    }
    
}


-(void)addAnnotion
{
    self.arrAnnotion = [[NSMutableArray alloc]init];
//    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:20.9717435 longitude:105.8300274];
//
//    CLLocationCoordinate2D location = [LocationAtual coordinate];
//    PlanCustomAnnotation *planAnno = [[PlanCustomAnnotation alloc] initWithName:@"test" coordinate:location avatarImgName:@"avatar.png"];
//
//    [planAnno updateStatus:1];
//    [self.arrAnnotion addObject:planAnno];
//    [_customerMapView addAnnotation:planAnno];
    for (int i=0; i<arrCustomer.count; i++) {
        NSDictionary *dicStore = [arrCustomer objectAtIndex:i];
        double kinhdoC = [[dicStore objectForKey:@"longitude"] doubleValue];
        double vidoC = [[dicStore objectForKey:@"latitude"] doubleValue];
        NSString *strNameC = [NSString stringWithFormat:@"%@", [dicStore objectForKey:@"name"]];
        CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:vidoC longitude:kinhdoC];
        CLLocationCoordinate2D location = [LocationAtual coordinate];
        PlanCustomAnnotation *planAnno = [[PlanCustomAnnotation alloc] initWithName:strNameC coordinate:location];
        [planAnno updateStatus:1];
        [self.arrAnnotion addObject:planAnno];
        [_customerMapView addAnnotation:planAnno];

    }

    
}
-(void)showViTri : (CLLocation*) vitri{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(vitri.coordinate, 500, 500);
    // NSLog(@"set vi tri %@",vitri);
    [_customerMapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
//     NSLog(@"annotation view did add: %@", [views objectAtIndex:0]);
//     NSLog(@"annotation added - total: %d", [[mapView annotations] count]);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)requestCustomer
{
    NSString *url = [NSString stringWithFormat:@"http://svkmanager.herokuapp.com/api/customer?idlogin=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"idnhanvien"]];
    [[Server sharedServer]getData:url completion:^(NSError *error, NSDictionary *data) {
        if (error == nil) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (status == true) {
                
                NSArray *arr = data[@"data"];
                arrCustomer = [arr mutableCopy];
                [self addAnnotion];

            }
            else
            {
                arrCustomer = [[NSMutableArray alloc] init];
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

- (IBAction)showMyLocation:(id)sender {
    [self showViTri:locationNew];
}
- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        /*
         Only handle state as the touches began
         set the location of the annotation
         */
        
        CLLocationCoordinate2D coordinate = [self.customerMapView convertPoint:[gestureRecognizer locationInView:self.customerMapView] toCoordinateFromView:self.customerMapView];
        [_customerMapView removeAnnotation:lastPlanAnno];

        [self.customerMapView setCenterCoordinate:coordinate animated:YES];
        PlanCustomAnnotation *planAnno = [[PlanCustomAnnotation alloc] initWithName:@"check" coordinate:coordinate];
        lastPlanAnno = planAnno;
        [planAnno updateStatus:1];
        [self.arrAnnotion addObject:planAnno];
        [_customerMapView addAnnotation:planAnno];
        // Do anything else with the coordinate as you see fit in your application
        
    }
}
@end
