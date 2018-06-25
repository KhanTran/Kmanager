//
//  PlanCustomAnnotation.h
//  KsmartSales
//
//  Created by thailinh on 7/2/15.
//  Copyright (c) 2015 LH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "PlanCustomAnnotationView.h"

@interface PlanCustomAnnotation : NSObject<MKAnnotation>{
    PlanCustomAnnotationView *annotationView;
    CLLocationCoordinate2D storeCoordinate;
    NSString *storeName;
    NSString *storeAvatarImgName;
    BOOL isOK;
}
@property (nonatomic,strong) PlanCustomAnnotationView *annotationView;
@property (nonatomic,strong) NSString *storeName;
@property (nonatomic,strong) NSString *storeAvatarImgName;
@property (nonatomic) CLLocationCoordinate2D storeCoordinate;
- (CLLocationCoordinate2D)coordinate;
- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate;
@property (nonatomic, copy) NSString *title;

- (void)updateStatus:(NSInteger)status;
@end
