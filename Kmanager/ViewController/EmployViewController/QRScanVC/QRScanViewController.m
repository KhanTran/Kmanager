//
//  QRScanViewController.m
//  KsmartSales
//
//  Created by Khánh on 30/01/2018.
//  Copyright © 2018 LH. All rights reserved.
//

#import "QRScanViewController.h"
#import "AppDelegate.h"

@interface QRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL isLoad;
}
@end

@implementation QRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isLoad = NO;
    _isReading = NO;
    _captureSession = nil;
//    NSError *error;
//
//    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
//
//    _captureSession = [[AVCaptureSession alloc] init];
//    [_captureSession addInput:input];
//    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
//    [_captureSession addOutput:captureMetadataOutput];
//    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
//    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
//    NSLog(@"%f", self.viewPreview.layer.bounds.size.height);
//    [_viewPreview.layer addSublayer:_videoPreviewLayer];
//
//    [_captureSession startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    NSLog(@"2 %f", self.viewPreview.layer.bounds.size.height);

    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
}
- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    return YES;
    
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}
//-(void)loadBeepSound{
//    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
//    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
//    NSError *error;
//
//    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
//    if (error) {
//        NSLog(@"Could not play beep file.");
//        NSLog(@"%@", [error localizedDescription]);
//    }
//    else{
//        [_audioPlayer prepareToPlay];
//    }
//}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [self scanQrSuccess:[metadataObj stringValue]];
//            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
//            _isReading = NO;
            
            
        }
    }
}
- (IBAction)loadQR:(id)sender {
    if (isLoad == NO) {
        isLoad = YES;
        [self.scanBtn setTitle:@"Stop" forState:UIControlStateNormal];
        [self startReading];

    }
    else
    {
        isLoad = NO;
        [self.scanBtn setTitle:@"Scan" forState:UIControlStateNormal];
        [self stopReading];
    }
}
- (IBAction)stopReading:(id)sender
{
    [self stopReading];
    [self dismissViewControllerAnimated:YES completion:NULL];

}
- (IBAction)btnFlashOnClicked:(id)sender
{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
            if ([flashLight isTorchActive])
            {
                //                [_btnFlash setTitle:@"TURN ON" forState:UIControlStateNormal];
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
            else
            {
                //                [_btnFlash setTitle:@"TURN OFF" forState:UIControlStateNormal];
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }
            [flashLight unlockForConfiguration];
        }
    }
}
- (void) scanQrSuccess: (NSString *)results
{
//    [self stopReading];

    if(self.delegate !=nil && [self.delegate respondsToSelector:@selector(qrScanSuccess:withResult:)])
    {

        [self.delegate qrScanSuccess:self withResult:results];
    }


}
//-(void)statusLoad
//{
//    if (isLoad == NO) {
//        [self.scanBtn setTitle:@"Scan" forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.scanBtn setTitle:@"Stop" forState:UIControlStateNormal];
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
