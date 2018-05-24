//
//  AddLocationViewController.h
//  Kmanager
//
//  Created by Khánh on 23/05/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class  AddLocationViewController;
@protocol AddLocationDelegate <NSObject>
-(void)ReturnLocationVC :(AddLocationViewController*)homevc withLocation :(CLLocation*)locationSend;
-(void)didSelectLocation :(AddLocationViewController*)homevc withAddress :(NSString*)address withLocation :(CLLocation*)locationSend;

@end

@interface AddLocationViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *customerMapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic)NSMutableArray * arrPlan;
@property (strong,nonatomic) NSMutableArray * arrAnnotion;
@property(assign)id<AddLocationDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
- (IBAction)showMyLocation:(id)sender;
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnXongPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *tfDiaChi;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnXong;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomDiaChi;
@end
