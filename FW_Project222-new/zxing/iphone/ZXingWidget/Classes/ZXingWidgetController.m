// -*- mode:objc; c-basic-offset:2; indent-tabs-mode:nil -*-
/**
 * Copyright 2009-2012 ZXing authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ZXingWidgetController.h"
#import "Decoder.h"
#import "NSString+HTML.h"
#import "ResultParser.h"
#import "ParsedResult.h"
#import "ResultAction.h"
#import "TwoDDecoderResult.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>

#define CAMERA_SCALAR 1.12412 // scalar = (480 / (2048 / 480))
#define FIRST_TAKE_DELAY 1.0
#define ONE_D_BAND_HEIGHT 10.0

@interface ZXingWidgetController ()

@property BOOL showCancel;
@property BOOL showLicense;
@property BOOL oneDMode;
@property BOOL isStatusBarHidden;

- (void)initCapture;
- (void)stopCapture;

@end

@implementation ZXingWidgetController

#if HAS_AVFF
@synthesize captureSession;
@synthesize prevLayer;
#endif
@synthesize result, delegate, soundToPlay;
@synthesize overlayView;
@synthesize oneDMode, showCancel, showLicense, isStatusBarHidden;
@synthesize readers;
@synthesize isFWPictureResult;

- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode {
    
    return [self initWithDelegate:scanDelegate showCancel:shouldShowCancel OneDMode:shouldUseoOneDMode showLicense:YES];
}

- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode showLicense:(BOOL)shouldShowLicense {
    self = [super init];
    if (self) {
        [self setDelegate:scanDelegate];
        self.oneDMode = shouldUseoOneDMode;
        self.showCancel = shouldShowCancel;
        self.showLicense = shouldShowLicense;
        self.wantsFullScreenLayout = YES;
        beepSound = -1;
        decoding = NO;
        OverlayView *theOverLayView = [[OverlayView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                           cancelEnabled:showCancel
                                                                oneDMode:oneDMode
                                                             showLicense:NO];
//        if([[[UIDevice currentDevice] systemVersion] floatValue] < 6.99)
//        {
//            theOverLayView.frame = CGRectMake(0, 44, 320, 460-44);
//        }
        [theOverLayView setDelegate:self];
        self.overlayView = theOverLayView;
        [theOverLayView release];
    }
    
    return self;
}

- (void)dealloc {
    if (beepSound != (SystemSoundID)-1) {
        AudioServicesDisposeSystemSoundID(beepSound);
    }
    
    [self stopCapture];
    self.delegate = nil;
    [result release];
    [soundToPlay release];
    [overlayView release];
    [readers release];
    [currentImg release];
    [super dealloc];
}

- (void)cancelled {
    [self stopCapture];
//    if (!self.isStatusBarHidden) {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    }
    
    wasCancelled = YES;
    if (delegate != nil) {
        [delegate zxingControllerDidCancel:self];
    }
}

- (NSString *)getPlatform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

- (BOOL)fixedFocus {
    NSString *platform = [self getPlatform];
    if ([platform isEqualToString:@"iPhone1,1"] ||
        [platform isEqualToString:@"iPhone1,2"]) return YES;
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.wantsFullScreenLayout = YES;
    if ([self soundToPlay] != nil) {
        OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)[self soundToPlay], &beepSound);
        if (error != kAudioServicesNoError) {
            NSLog(@"Problem loading nearSound.caf");
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.isStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
//    if (!isStatusBarHidden)
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    decoding = YES;
    
    [self initCapture];
    [self.view addSubview:overlayView];
    
    [overlayView setPoints:nil];
    wasCancelled = NO;
    
    [overlayView scanAnimation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    if (!isStatusBarHidden)
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.overlayView removeFromSuperview];
    [self stopCapture];
}

- (CGImageRef)CGImageRotated90:(CGImageRef)imgRef
{
    CGFloat angleInRadians = -90 * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, FALSE);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
    CGColorSpaceRelease(colorSpace);
    //      CGContextTranslateCTM(bmContext,
    //                                                +(rotatedRect.size.width/2),
    //                                                +(rotatedRect.size.height/2));
    CGContextScaleCTM(bmContext, rotatedRect.size.width/rotatedRect.size.height, 1.0);
    CGContextTranslateCTM(bmContext, 0.0, rotatedRect.size.height);
    CGContextRotateCTM(bmContext, angleInRadians);
    //      CGContextTranslateCTM(bmContext,
    //                                                -(rotatedRect.size.width/2),
    //                                                -(rotatedRect.size.height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                             rotatedRect.size.width,
                                             rotatedRect.size.height),
                       imgRef);
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    [(id)rotatedImage autorelease];
    
    return rotatedImage;
}

- (CGImageRef)CGImageRotated180:(CGImageRef)imgRef
{
    CGFloat angleInRadians = M_PI;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   width,
                                                   height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, FALSE);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext,
                          +(width/2),
                          +(height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext,
                          -(width/2),
                          -(height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), imgRef);
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    [(id)rotatedImage autorelease];
    
    return rotatedImage;
}

// DecoderDelegate methods

- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset{
#ifdef DEBUG
    NSLog(@"DecoderViewController MessageWhileDecodingWithDimensions: Decoding image (%.0fx%.0f) ...", image.size.width, image.size.height);
#endif
}

- (void)decoder:(Decoder *)decoder
  decodingImage:(UIImage *)image
    usingSubset:(UIImage *)subset {
}

- (void)presentResultForString:(NSString *)resultString {
    self.result = [ResultParser parsedResultForString:resultString];
    if (beepSound != (SystemSoundID)-1) {
        AudioServicesPlaySystemSound(beepSound);
    }
#ifdef DEBUG
    NSLog(@"result string = %@", resultString);
#endif
}

- (void)presentResultPoints:(NSArray *)resultPoints
                   forImage:(UIImage *)image
                usingSubset:(UIImage *)subset {
    // simply add the points to the image view
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:resultPoints];
    [overlayView setPoints:mutableArray];
    [mutableArray release];
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult {
    //[self presentResultForString:[twoDResult text]];
    //[self presentResultPoints:[twoDResult points] forImage:image usingSubset:subset];
    // now, in a selector, call the delegate to give this overlay time to show the points
    [self performSelector:@selector(notifyDelegate:) withObject:[[twoDResult text] copy] afterDelay:0.0];
    decoder.delegate = nil;
}

- (void)notifyDelegate:(id)text {
    if (!isStatusBarHidden) [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [delegate zxingController:self didScanResult:text];
    [text release];
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason {
    decoder.delegate = nil;
    [overlayView setPoints:nil];
    //decoding = YES;
}

- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point {
    //[overlayView setPoint:point];
}

/*
 - (void)stopPreview:(NSNotification*)notification {
 // NSLog(@"stop preview");
 }
 
 - (void)notification:(NSNotification*)notification {
 // NSLog(@"notification %@", notification.name);
 }
 */

#pragma mark -
#pragma mark AVFoundation

#include <sys/types.h>
#include <sys/sysctl.h>

// Gross, I know. But you can't use the device idiom because it's not iPad when running
// in zoomed iphone mode but the camera still acts like an ipad.
#if HAS_AVFF
static bool isIPad() {
    static int is_ipad = -1;
    if (is_ipad < 0) {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0); // Get size of data to be returned.
        char *name = malloc(size);
        sysctlbyname("hw.machine", name, &size, NULL, 0);
        NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
        free(name);
        is_ipad = [machine hasPrefix:@"iPad"];
    }
    return !!is_ipad;
}
#endif

- (void)initCapture {
#if HAS_AVFF
    AVCaptureDevice* inputDevice =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput =
    [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if(inputDevice == nil)
    {
        //#warning 添加相机是否被保护 ios7出来的政策 而且是国行的iphone
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"打开权限" message:@"请到设置->隐私->相机 打开照相机权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }

    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    self.captureSession = [[[AVCaptureSession alloc] init] autorelease];
    
    NSString* preset = 0;
    if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
        [UIScreen mainScreen].scale > 1 &&
        isIPad() &&
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
    
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    
    [captureOutput release];
    
    
    if (!self.prevLayer) {
        self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
    self.prevLayer.frame = self.view.bounds;
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.prevLayer];
    
    [self.captureSession startRunning];
#endif
}

#if HAS_AVFF
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
     __block __unsafe_unretained ZXingWidgetController *weakSelf = self;
    if(decoding)
    {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        /*Lock the image buffer*/
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        /*Get information about the image*/
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        uint8_t* baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
        void* free_me = 0;
        if (true) { // iOS bug?
            uint8_t* tmp = baseAddress;
            int bytes = bytesPerRow*height;
            free_me = baseAddress = (uint8_t*)malloc(bytes);
            baseAddress[0] = 0xdb;
            memcpy(baseAddress,tmp,bytes);
        }
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext =
        CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace,
                              kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
        
        CGImageRef capture = CGBitmapContextCreateImage(newContext);
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        free(free_me);
        
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
        CGRect cropRect = [overlayView cropRect];

    //    cropRect.size.width = CGImageGetWidth(capture);
    //    cropRect.size.height = CGImageGetHeight(capture);
        
        //{
            float cheight = CGImageGetHeight(capture);
            float cwidth = CGImageGetWidth(capture);
    //        
    //        CGRect screen = UIScreen.mainScreen.bounds;
    //        float tmp = screen.size.width;
    //        screen.size.width = screen.size.height;;
    //        screen.size.height = tmp;
    //        
    //        cropRect.origin.x = (width-cropRect.size.width)/2;
    //        cropRect.origin.y = (height-cropRect.size.height)/2;
            
//            if([UIScreen mainScreen].bounds.size.height<568)
//            {
//                cropRect.origin.x = 44;
//                cropRect.origin.y = 22;
//            }
//            else
//            {
//                cropRect.origin.x = 42;
//                cropRect.origin.y = 10;
//            }
        //}
        CGImageRef newImage = CGImageCreateWithImageInRect(capture, CGRectMake(0, 0, cwidth, cheight));
        CGImageRelease(capture);
        // UIImage *scrn = [[UIImage alloc] initWithCGImage:newImage];
        int backCameraImageOrientation = UIImageOrientationRight;



        UIImage *scrn = [[UIImage alloc] initWithCGImage:newImage scale:
                         (CGFloat)1.0 orientation:backCameraImageOrientation];
        Decoder *d = [[Decoder alloc] init];
        d.readers = readers;
        d.delegate = self;
        cropRect.origin.x = 0.0;
        cropRect.origin.y = 0.0;
        decoding = [d decodeImage:scrn cropRect:cropRect] == YES ? NO : YES;
        [d release];
        [scrn release];
        CGImageRelease(newImage);
    }
    
    if(!isFWPictureResult)
    {
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf createERWEIMApic:sampleBuffer];
       // });
    }
}


- (void)createERWEIMApic:(CMSampleBufferRef)sampleBuffer
{
    

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
    CGImageRef capture = CGBitmapContextCreateImage(context);
    //CGRect cropRect = [overlayView cropRect];

    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
//    UIImage *image = [UIImage imageWithCGImage:quartzImage];
//    //UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
//    //MLOG(@"imageOrientation111 = %d", image.imageOrientation);
//    // Release the Quartz image
//    CGImageRelease(quartzImage);
    
        // N.B.
        // - Won't work if the overlay becomes uncentered ...
        // - iOS always takes videos in landscape
        // - images are always 4x3; device is not
        // - iOS uses virtual pixels for non-image stuff
//    cropRect.size.width = CGImageGetWidth(capture);
//    cropRect.size.height = CGImageGetHeight(capture);
        CGRect cropRect = [overlayView cropRect];
        {
            float cheight = CGImageGetHeight(capture);
            float cwidth = CGImageGetWidth(capture);
            
//            CGRect screen = UIScreen.mainScreen.bounds;
//            float tmp = screen.size.width;
//            screen.size.width = screen.size.height;;
//            screen.size.height = tmp;
            NSLog(@"hhhhhhhh%.2f", cheight);
            NSLog(@"wwwwwwww%.2f", cwidth);
            if([UIScreen mainScreen].bounds.size.height<568)
            {
                cropRect.origin.x = 44;
                cropRect.origin.y = 22;
            }
            else
            {
                cropRect.origin.x = 42;
                cropRect.origin.y = 10;
            }

            //(height-cropRect.size.height)/2-89;
        }
        CGImageRef newImage = CGImageCreateWithImageInRect(capture, cropRect);
    //CGImageRef newImage = CGImageCreateWithImageInRect(capture, CGRectMake(0, 0, width, height));

        CGImageRelease(capture);
//    newImage = [self CGImageRotated90:newImage];
//    newImage = [self CGImageRotated180:newImage];
//        UIImage *scrn = [[UIImage alloc] initWithCGImage:newImage scale:0 orientation:UIImageOrientationRight];

    
    if(delegate && !isFWPictureResult)
    {
        UIImage *scrn = [[UIImage alloc] initWithCGImage:newImage];
        __block __unsafe_unretained ZXingWidgetController *weakSelf = self;
        //dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isFWPictureResult = [weakSelf.delegate zxingImg:scrn controller:self];
        //});
        
        [scrn release];
    }
    CGImageRelease(newImage);
    
}
#endif

- (void)stopCapture {
    decoding = NO;
#if HAS_AVFF
    [captureSession stopRunning];
    AVCaptureInput* input = [captureSession.inputs objectAtIndex:0];
    [captureSession removeInput:input];
    AVCaptureVideoDataOutput* output = (AVCaptureVideoDataOutput*)[captureSession.outputs objectAtIndex:0];
    [captureSession removeOutput:output];
    [self.prevLayer removeFromSuperlayer];
    
    /*
     // heebee jeebees here ... is iOS still writing into the layer?
     if (self.prevLayer) {
     layer.session = nil;
     AVCaptureVideoPreviewLayer* layer = prevLayer;
     [self.prevLayer retain];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12000000000), dispatch_get_main_queue(), ^{
     [layer release];
     });
     }
     */
    
    self.prevLayer = nil;
    self.captureSession = nil;
#endif
}

- (void)saveImgToAlbum:(UIImage *)aImg
{
    if(self.isSave)
    {
        UIImageWriteToSavedPhotosAlbum(aImg, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}
//
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存失败");
}

#pragma mark - Torch

- (void)setTorch:(BOOL)status {
#if HAS_AVFF
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device lockForConfiguration:nil];
        if ( [device hasTorch] ) {
            if ( status ) {
                [device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
        [device unlockForConfiguration];
        
    }
#endif
}

- (BOOL)torchIsOn {
#if HAS_AVFF
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ( [device hasTorch] ) {
            return [device torchMode] == AVCaptureTorchModeOn;
        }
        [device unlockForConfiguration];
    }
#endif
    return NO;
}
CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees aimg:(UIImage *)aImg
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,aImg.size.width, aImg.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    //[rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-aImg.size.width / 2, -aImg.size.height / 2, aImg.size.width, aImg.size.height), [aImg CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end
