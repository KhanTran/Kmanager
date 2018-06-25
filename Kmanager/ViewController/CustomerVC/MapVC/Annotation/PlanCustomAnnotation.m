//
//  PlanCustomAnnotation.m
//  KsmartSales
//
//  Created by thailinh on 7/2/15.
//  Copyright (c) 2015 LH. All rights reserved.
//

#import "PlanCustomAnnotation.h"

@implementation PlanCustomAnnotation
@synthesize annotationView,storeAvatarImgName,storeCoordinate,storeName;

- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    if (self != nil){
        self.storeCoordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        self.storeName = name;
        _title =name;
       
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return self.storeCoordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    self.storeCoordinate = CLLocationCoordinate2DMake(newCoordinate.latitude, newCoordinate.longitude);
}
- (void)updateStatus:(NSInteger)status {

    [self.annotationView setPlanImageWithMarkerIndex:status];
}
@end
