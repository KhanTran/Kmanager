//
//  LocationCustomerViewController.h
//  Kmanager
//
//  Created by Khánh on 23/04/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class  LocationCustomerViewController;
@protocol LocationCustomerDelegate <NSObject>

-(void)ReturnLocationVC :(LocationCustomerViewController*)homevc withLocation :(CLLocation*)locationSend;

@end
@interface LocationCustomerViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *customerMapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic)NSMutableArray * arrPlan;
@property (strong,nonatomic) NSMutableArray * arrAnnotion;
@property(assign)id<LocationCustomerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
- (IBAction)showMyLocation:(id)sender;
@end
