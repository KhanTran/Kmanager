//
//  QRScanViewController.h
//  KsmartSales
//
//  Created by Khánh on 30/01/2018.
//  Copyright © 2018 LH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class QRScanViewController;
@protocol qrScanDelegate <NSObject>

-(void)qrScanSuccess :(QRScanViewController*)qrScan withResult :(NSString*)results;

@end
@interface QRScanViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;
@property (nonatomic) BOOL isReading;
- (IBAction)stopReading:(id)sender;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
-(BOOL)startReading;
-(void)stopReading;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

//@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
- (IBAction)loadQR:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFlash;
@property(assign)id<qrScanDelegate>delegate;

@end
