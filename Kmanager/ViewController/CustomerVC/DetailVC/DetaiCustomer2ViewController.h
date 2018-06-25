//
//  DetaiCustomer2ViewController.h
//  Kmanager
//
//  Created by Khánh on 25/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface DetaiCustomer2ViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *customerMapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tableviewDetailCustomer;
@property (strong, nonatomic) NSDictionary* dicDetail;

@end
