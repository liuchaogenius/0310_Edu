//
//  FW_AVCaptureVideoVC.m
//  FW_Project
//
//  Created by  striveliu on 13-9-21.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_AVCaptureVideoVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "OCR_Donald.h"
#import "ToolUtil.h"
#import <QRCodeReader.h>
#import <Decoder.h>
#import <TwoDDecoderResult.h>

@interface FW_AVCaptureVideoVC ()
{
    NSTimer *loopCheckTimer;
    BOOL isGetImg;
}
@property (nonatomic, strong)NSMutableSet *qrReader;
@end

@implementation FW_AVCaptureVideoVC
@synthesize resultArry;
@synthesize qrReader;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        isGetImg = YES;
        resultArry = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
   
	// Do any additional setup after loading the view.
    self.qrReader = [[NSMutableSet alloc ] init];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    [self.qrReader addObject:qrcodeReader];
//    self.scanningQR = NO;
//    self.step = STEP_QR;
    
    [self initCapture];
    
    _cancelButton = [[UIButton alloc] init];
    [self.cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    [self.cancelButton setFrame:CGRectMake((kVCWidth(self)-80)/2, self.captureVideoPreviewLayer.frame.origin.y+self.captureVideoPreviewLayer.frame.size.height, 80, 50.f)];
    [self.cancelButton addTarget:self action:@selector(pressCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
     [super viewDidLoad];
}

- (void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if(captureInput == nil)
    {
#warning 添加相机是否被保护 ios7出来的政策 而且是国行的iphone
        return;
    }
    [self.captureSession addInput:captureInput];
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [self.captureSession addOutput:captureOutput];
    
    NSString* preset = 0;
    if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
        [UIScreen mainScreen].scale > 1 &&
        [inputDevice
         supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
            // NSLog(@"960");
            preset = AVCaptureSessionPresetiFrame960x540;
        }
    if (!preset) {
        // NSLog(@"MED");
        preset = AVCaptureSessionPresetMedium;
    }
    self.captureSession.sessionPreset = preset;
    
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
    int offset = 45;
    if(kSystemVersion>6.99)
    {
        offset+=45;
    }
    self.captureVideoPreviewLayer.frame = CGRectMake(40, offset, 240, 276);//self.view.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.captureVideoPreviewLayer];
    
    self.isScanning = YES;
    [self.captureSession startRunning];
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}


- (UIImage *) imageFromSampleBuffer1:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst
                                                 );//kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    //UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    MLOG(@"imageOrientation111 = %d", image.imageOrientation);
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (void)startLoopCheckImgTimer
{
    if(!loopCheckTimer)
    {
        loopCheckTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkImgFail) userInfo:nil repeats:NO];
        isGetImg = YES;
    }
}

- (void)checkImgFail
{
    isGetImg = NO;
    if([resultArry count]>3)
    {
        [self verificationIsTrue];
    }
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
//    if(isGetImg == YES)
//    {
//        UIImage *image1 = [self imageFromSampleBuffer1:sampleBuffer];
//        
//        MLOG(@"imgWidth1 = %.2f imgHeight1 = %.2f", image1.size.width, image1.size.height);
//        UIImage *image = [ToolUtil fixOrientation:image1];
//        MLOG(@"imgWidth = %.2f imgHeight = %.2f", image.size.width, image.size.height);
//        if(image)
//        {
//            //if(ret <= 0)
//            {
//                ret = [OCR_Donald OcrInit:image.size.width second:image.size.height thrid:@"OCR"];
//            }
//            MLOG(@"captureOutputRet = %d",ret);
//            isGetImg = NO;
//            long long checkRet = [OCR_Donald checkFWImage:image];
//            if(checkRet > 0)
//            {
//                MLOG(@"cccccc恭喜识别成功");
//                NSNumber *retNum = [NSNumber numberWithLongLong:checkRet];
//                [resultArry addObject:retNum];
//            }
//            isGetImg = YES;
//            MLOG(@"checkRet = %lld",checkRet);
//            //if([resultArry count]>=6)
//            {
//                [self performSelector:@selector(verificationIsTrue) withObject:nil afterDelay:0.4];
//                //[self verificationIsTrue];
//            }
//        }
//    }
//
    
    UIImage *image1 = [self imageFromSampleBuffer1:sampleBuffer];
    [self decodeImage:image1];
}

- (void)decodeImage:(UIImage *)image
{
    Decoder *decoder = [[Decoder alloc] init];
    decoder.delegate = self;
    decoder.readers = qrReader;
    [decoder decodeImage:image];
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    MLOG(@"条形码 result= %@", result.text);
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    MLOG(@"条形码 reason= %@", reason);
}

- (void)verificationIsTrue
{
    isGetImg = NO;
    [loopCheckTimer invalidate];
    loopCheckTimer = nil;
    if(self.delegate && [self.delegate respondsToSelector:@selector(customViewControllerDidCancel:)])
    {
        [self.delegate customViewControllerDidCancel:self];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MLOG(@"获取图片");
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        self.isScanning = YES;
//        [self.captureSession startRunning];
//    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.isScanning = YES;
    [self.captureSession startRunning];
}


- (void)pressCancelButton
{
    self.isScanning = NO;
    [self.captureSession stopRunning];
    [self dismissModalViewControllerAnimated:YES];
//    if (_delegate && [_delegate respondsToSelector:@selector(customViewControllerDidCancel:)]) {
//        [_delegate customViewControllerDidCancel:self];
//    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
