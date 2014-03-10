//
//  FW_AVCaptureVideoVC.h
//  FW_Project
//
//  Created by  striveliu on 13-9-21.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ZXingWidgetController.h>
@class FW_AVCaptureVideoVC;

@protocol FW_AVCaptureVideoVCDelegate <NSObject>

@optional
- (void)customViewController:(FW_AVCaptureVideoVC *)controller didScanResult:(NSString *)result;
- (void)customViewControllerDidCancel:(FW_AVCaptureVideoVC *)controller;

@end

@interface FW_AVCaptureVideoVC : BaseViewController<UIAlertViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DecoderDelegate>
{
    int ret;
}
@property (nonatomic, strong) NSMutableArray *resultArry;
@property (nonatomic, weak) id<FW_AVCaptureVideoVCDelegate> delegate;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, assign) BOOL isScanning;
@property (nonatomic, strong) UIImage *img;
@end
