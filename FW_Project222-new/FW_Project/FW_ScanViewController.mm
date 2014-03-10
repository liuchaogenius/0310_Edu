//
//  FW_ScanViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-9-21.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_ScanViewController.h"
#import "FW_GoodsDetailViewController.h"
#import "classAppDelegate.h"
#import "FW_ScanManager.h"
#import "OCR_Donald.h"
#import "CRNavigationController.h"
#import "FWFeatureViewController.h"
#import "UIImage+Orientation.h"
#import "UIImage+Extensions.h"
#import "FWAllBrandsViewController.h"
#import "GoodsBrandData.h"
#import "FWCheckFailViewController.h"
#import <MultiFormatOneDReader.h>
//自定义需要用到
#import <Decoder.h>
#import <TwoDDecoderResult.h>
#import <QRCodeReader.h>
#import "UIImage+Extensions.h"
#import "CRNavigationBar.h"

@interface FW_ScanViewController ()

@end

@implementation FW_ScanViewController
@synthesize tapGest;
@synthesize manager;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        isMove = NO;
        isChecking = NO;
        if(!manager)
        {
            manager = [[FW_ScanManager alloc] init];
        }
        if(!checkCodeArry)
        {
            checkCodeArry = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    MLOG(@"viewDidLoad-sub");
    ret = [OCR_Donald OcrInit:300 second:300 thrid:@"OCR"];
	// Do any additional setup after loading the view.
    //CRNavigationController *navigationController = (CRNavigationController *)self.navigationController;
//    CRNavigationBar *navigationBar = (CRNavigationBar *)navigationController.navigationBar;
//    //navigationBar.backgroundColor = [UIColor whiteColor];
//    if(kSystemVersion>6.99)
//    {
//        [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
//    }
//    else
//    {
//        [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
//    }
//    [navigationBar displayColorLayer:YES];
    self.navigationItem.titleView = [ToolUtil getNavgationTitleView:@"防伪小超人" fontsize:18];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [button setTitle:@"分类" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(categoryButtonItem) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    UIImageView *bgImgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.g_OffsetY, self.view.width, self.view.height)];
    [bgImgview setImage:[UIImage imageNamed:@"scanviewBg"]];
    bgImgview.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bgImgview];
    
    UIButton *allBrandButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 5+self.g_OffsetY, 80, 20)];
    [allBrandButton setTitle:@"所有品牌" forState:UIControlStateNormal];
    [allBrandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [allBrandButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -8)];
    allBrandButton.titleLabel.font = kFontSize(16);
    [allBrandButton setImage:[UIImage imageNamed:@"allbrandtag"] forState:UIControlStateNormal];
    [allBrandButton addTarget:self action:@selector(allBrandButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBrandButton];
    
//    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 100, 100, 80)];
//    [otherButton setTitle:@"失败页面" forState:UIControlStateNormal];
//    [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [otherButton addTarget:self action:@selector(otherButtonItem) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:otherButton];
    
    
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 190, 150, 141)];
    scanButton.center = self.view.center;
    //[scanButton setTitle:@"开始扫描" forState:UIControlStateNormal];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"scanButtonBg"] forState:UIControlStateNormal];
    //[scanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MLOG(@"willapper");
}

- (void)otherButtonItem
{
    FWCheckFailViewController *failVC = MAlloc(FWCheckFailViewController);
    classAppDelegate *appDelegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.nav pushViewController:failVC animated:YES];
}

- (void)allBrandButtonItem
{
    FWAllBrandsViewController *brandVC = [[FWAllBrandsViewController alloc] init];
    
    classAppDelegate *appDelegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.nav pushViewController:brandVC animated:YES];
    [brandVC requestAllBrands];
    [brandVC setNavgationItemTitle:@"所有品牌"];
    if ([appDelegate.nav respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        appDelegate.nav.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    MLOG(@"viewDidAppear-sub");
}
- (void)scanButtonItem
{
    if(isMove == YES)
    {
        [self tapGestItem:tapGest];
        return;
    }
    isTimeOut = NO;
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:YES];
    
    MultiFormatOneDReader *OneReaders=[[MultiFormatOneDReader alloc]init];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:OneReaders,qrcodeReader,nil];
    widController.readers = readers;
    widController.isSave = YES;
    [self presentViewController:widController animated:YES completion:^{}];
    
    [self performSelector:@selector(checkTimeOut:) withObject:widController afterDelay:kScanTimeOut];
}

- (void)checkTimeOut:(ZXingWidgetController *)controller
{
    isTimeOut = YES;
    MBTipWindow *tipWindow = [MBTipWindow GetInstance];
   [tipWindow hideProgressHUD:YES];
    [controller dismissViewControllerAnimated:YES completion:^{MLOG(@"checktimeout!");}];
    [checkCodeArry removeAllObjects];
    strSeq = nil;
    isChecking = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    FWCheckFailViewController *failVC = MAlloc(FWCheckFailViewController);
    classAppDelegate *appDelegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.nav pushViewController:failVC animated:YES];
}

- (void)checkScanProductid:(ZXingWidgetController *)controller
{
    __weak FW_ScanViewController *weakself = self;
#if DEBUG
    classAppDelegate *delegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *temView = [delegate.window viewWithTag:10000];
    if(temView)
    {
        [temView removeFromSuperview];
        temView = nil;
    }
    UIView *tempview = [delegate.window viewWithTag:10001];
    if(tempview)
    {
        [tempview removeFromSuperview];
        tempview = nil;
    }
#endif
    if(isTimeOut == NO)
    {
        MBTipWindow *tipWindow = [MBTipWindow GetInstance];
        [tipWindow showProgressHUDWithMessage:@"扫描成功,识别中..."];
        [manager checkGoods:strSeq checkCode:checkCodeArry infoblock:^(GoodsBaseInfo *infoData) {
            [tipWindow hideProgressHUD:YES];
            if(infoData)
            {
                weakself.infoData = infoData;
                
                [controller dismissViewControllerAnimated:NO completion:^{
                    FW_GoodsDetailViewController *detailVC = [[FW_GoodsDetailViewController alloc] init];
                    classAppDelegate *appDelegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
                    detailVC.infoData = weakself.infoData;
                    
                    [appDelegate.nav pushViewController:detailVC animated:YES];
                    [detailVC setNavigationTitle:@"恭喜，您的宝贝是正品"];
                    if ([appDelegate.nav respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                        appDelegate.nav.interactivePopGestureRecognizer.delegate = nil;
                    }
                }];
            }
            else
            {
                [controller dismissViewControllerAnimated:NO completion:^{
                    
                    FWCheckFailViewController *failVC = MAlloc(FWCheckFailViewController);
                    classAppDelegate *appDelegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
                    [appDelegate.nav pushViewController:failVC animated:YES];
                 }];
            }
                
            [checkCodeArry removeAllObjects];
            isChecking = NO;
            strSeq = nil;
        }];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    MLOG(@"aaaaaa条形码识别结果=%@", result);
    strSeq = result;
    if(strSeq && strSeq.length>0 && [checkCodeArry count]>0)
    {
        MLOG(@"sssssssss条形码慢");
#if DEBUG
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, 300, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.tag = 10001;
        label.text = [NSString stringWithFormat:@"条形码:%@",result];
        classAppDelegate *delegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:label];
#endif
        [self checkScanProductid:controller];

    }
}

- (BOOL)zxingImg:(UIImage *)aImg controller:(ZXingWidgetController*)controller
{
    UIImage *img1 = [aImg imageRotatedByDegrees:90];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [controller saveImgToAlbum:img1];
//    });
    
    MLOG(@"ret = %d", ret);
    if(ret>0)
    {
        if(isChecking == NO)
        {
            isChecking = YES;
            long long checkRet = [OCR_Donald checkFWImage:img1];
            isChecking = NO;
            MLOG(@"checkRet = %lld", checkRet);
            if(checkRet > 0)
            {
                MLOG(@"cccccc恭喜识别成功");
#if  DEBUG
                classAppDelegate *delegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 410, 300, 30)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor blackColor];
                label.tag = 10000;
                label.text = [NSString stringWithFormat:@"液晶结果:%lld",checkRet];
                [delegate.window addSubview:label];
#endif
                [checkCodeArry addObject:[NSString stringWithFormat:@"%lld", checkRet]];
                if([checkCodeArry count]>0)
                {
                    if(strSeq && strSeq.length>0)
                    {
                        MLOG(@"sssssssss自己识别慢");
                        [self checkScanProductid:controller];
                    }

                    return YES;
                }
                else
                {
                    return NO;
                }
            }
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    controller.isSave = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [checkCodeArry removeAllObjects];
    isChecking = NO;
    strSeq = nil;
#if DEBUG
    classAppDelegate *delegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *temView = [delegate.window viewWithTag:10000];
    if(temView)
    {
        [temView removeFromSuperview];
        temView = nil;
    }
    UIView *tempview = [delegate.window viewWithTag:10001];
    if(tempview)
    {
        [tempview removeFromSuperview];
        tempview = nil;
    }
#endif
    [controller dismissViewControllerAnimated:YES completion:^{MLOG(@"cancel!");}];
}

- (void)categoryButtonItem
{
    __weak FW_ScanViewController *vc = self;
    if(isMove == NO)
    {
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.frame = CGRectMake(80, 0, kVCWidth(vc), kVCHeight(vc));
        } completion:^(BOOL finished) {
            if(vc.tapGest == nil)
            {
                vc.tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestItem:)];
            }
            isMove = YES;
            [vc.view addGestureRecognizer:tapGest];
        }];
    }
    else
    {
        [self tapGestItem:tapGest];
    }
}

- (void)tapGestItem:(UITapGestureRecognizer*)aTapGest
{
    __weak FW_ScanViewController *vc = self;
    [UIView animateWithDuration:0.3 animations:^{
        vc.view.frame = CGRectMake(0, 0, kVCWidth(vc), kVCHeight(vc));
    } completion:^(BOOL finished) {
        [vc.view removeGestureRecognizer:aTapGest];
        vc.tapGest = nil;
        isMove = NO;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
