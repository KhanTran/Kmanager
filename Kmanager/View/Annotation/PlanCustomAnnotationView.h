//
//  PlanCustomAnnotationView.h
//  KsmartSales
//
//  Created by thailinh on 7/2/15.
//  Copyright (c) 2015 LH. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PlanCustomAnnotationView : MKAnnotationView{
    MKAnnotationView *annoView;
    UIImageView *carIDPlate;
}
- (void)setPlanImageWithMarkerIndex:(NSInteger)isStore;
@end
