//
//  FW_ScanViewController.h
//  FW_Project
//
//  Created by  striveliu on 13-9-21.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FW_AVCaptureVideoVC.h"
#import <ZXingWidgetController.h>
@class FW_ScanManager;
@class GoodsBaseInfo;
@interface FW_ScanViewController : BaseViewController<FW_AVCaptureVideoVCDelegate, ZXingDelegate>
{
    BOOL isMove;
    int ret;
    CGFloat imgwidth;
    CGFloat imgHeight;
    BOOL isChecking;
    NSString *strSeq;
    NSMutableArray *checkCodeArry;
    BOOL isTimeOut;
}
@property(nonatomic, strong)FW_ScanManager *manager;
@property(nonatomic, strong)UITapGestureRecognizer *tapGest;
@property(nonatomic, strong)GoodsBaseInfo *infoData;
@property(nonatomic, strong)UIImageView *imgview;
@end
