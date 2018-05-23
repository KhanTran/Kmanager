//
//  IndiViewController.m
//  testIndicator
//
//  Created by Khánh on 08/02/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "IndiViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface IndiViewController ()
{
    UIActivityIndicatorView *activityIndiView;
    UILabel *label;
}
@end

@implementation IndiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat bgWidth = 160;
    CGFloat bgHeight = 100;
    
    UIView *loadingBgView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - bgWidth/2, self.view.frame.size.height/2 - bgHeight/2, 160,80)];
    NSLog(@"%f - %f",self.view.frame.size.width/2 - bgWidth/2,self.view.frame.size.height/2 - bgHeight/2 );
    loadingBgView.layer.cornerRadius = 10.0f;
    loadingBgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    
    activityIndiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGFloat indiSize = 40;
    activityIndiView.frame = CGRectMake(60, 5, indiSize, indiSize);
    [loadingBgView addSubview:activityIndiView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 200, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    [loadingBgView addSubview:label];
    [self.view addSubview:loadingBgView];
    label.text = @"Xin chờ giây lát ...";
    self.view.hidden = NO;
    self.view.alpha = 1.0;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)showAnimated:(BOOL)animated {
    if (!animated) {
        [self show];
    } else {
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self show];
                         }
                         completion:^(BOOL finished){
                             [self viewDidShow];
                         }];
    }
}

- (void)hideAnimated:(BOOL)animated {
    if (!animated) {
        [self hide];
        [self viewDidHide];
    } else {
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self hide];
                         }
                         completion:^(BOOL finished){
                             [self viewDidHide];
                         }];
    }
}

- (void)viewDidShow {
    [activityIndiView startAnimating];
}

- (void)viewDidHide {
    [activityIndiView stopAnimating];
}
- (void)hide {
    self.view.alpha = 0.0;
    self.view.hidden = YES;
}
- (void)show {
    self.view.hidden = NO;
    self.view.alpha = 1.0;
}
@end
