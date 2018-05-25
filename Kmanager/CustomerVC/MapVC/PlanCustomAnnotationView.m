//
//  PlanCustomAnnotationView.m
//  KsmartSales
//
//  Created by thailinh on 7/2/15.
//  Copyright (c) 2015 LH. All rights reserved.
//

#import "PlanCustomAnnotationView.h"
#define HeightWith 30
@implementation PlanCustomAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
        [self addSubview:annoView];
    }
    
    return self;
}

- (void)setPlanImageWithMarkerIndex:(NSInteger)isStore {
    UIImage *markerImg;
    markerImg = [UIImage imageNamed:[NSString stringWithFormat:@"cuahang.png"]];

    
    
    CGFloat width = HeightWith;
    CGFloat height = HeightWith;
    CGFloat oriX = self.center.x - width/2;
    CGFloat oriY = self.center.y - height/2;
    
    annoView.image = markerImg;

    self.frame = CGRectMake(oriX, oriY, width, height);
    annoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

}


@end
