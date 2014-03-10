//
//  FW_GoodsDetailViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_GoodsDetailViewController.h"
#import "FWFeatureViewController.h"
#import "FW_CustomButton.h"
#import "FW_GoodsComsView.h"
#import "FW_GoodsInfoView.h"
#import "GoodsBaseInfo.h"
#import "classAppDelegate.h"
#import "FW_ScanManager.h"
#import "FW_TeseView.h"

#define kFootButtonHeight  50
@interface FW_GoodsDetailViewController ()

@end

@implementation FW_GoodsDetailViewController
@synthesize commentView;
@synthesize goodsInfoview;
@synthesize featurevc;
@synthesize teseView;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
//    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    
    if(self.infoData)
    {
        [self addFootButton];
        [self addGoodsInfoView];
    }
}

- (void)setNavigationTitle:(NSString*)aTitle
{
    self.navigationItem.titleView = [ToolUtil getNavgationTitleView:aTitle fontsize:18];
}

- (void)requestGoodsInfo:(NSString *)aStrid
{
    self.strProductId = aStrid;
    if(!self.manager)
    {
        self.manager = [[FW_ScanManager alloc] init];
    }
    __weak FW_GoodsDetailViewController *weakSelf = self;
    [self.manager requestGoodsInfo:aStrid infoblock:^(GoodsBaseInfo *infoData) {
        if(infoData)
        {
            weakSelf.infoData = infoData;
            [weakSelf addFootButton];
            [weakSelf addGoodsInfoView];
        }
    }];
}

- (void)addFootButton
{
    UIImage *backImgNor = [UIImage imageNamed:@"detailButton_nor"];
    UIImage *backImgSel = [UIImage imageNamed:@"detailButton_sel"];
    UIColor *titleColor = [UIColor whiteColor];
    __weak FW_GoodsDetailViewController *vc = self;
    self.goodsInfo_Button = [[FW_CustomButton alloc] initWithButton:@"宝贝"
                                                         titleColor:titleColor
                                                          titleFont:[UIFont systemFontOfSize:13] img:[UIImage imageNamed:@"detail_Baobei"] backImg:backImgSel backColor:nil rect:CGRectMake(0, kVCHeight(self)-kFootButtonHeight, kVCWidth(self)/4, kFootButtonHeight) itemBlock:^{
                                                              [vc modifyButton:vc.goodsInfo_Button];
                                                              [vc addGoodsInfoView];
    }];
    [self.goodsInfo_Button setImageEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, -26)];
    [self.goodsInfo_Button setTitleEdgeInsets:UIEdgeInsetsMake(30,0, 0, 18)];
    [self.view addSubview:self.goodsInfo_Button];
    self.currentButton = self.goodsInfo_Button;
    
    self.goodsSpec_Button = [[FW_CustomButton alloc] initWithButton:@"特色"
                                                         titleColor:titleColor
                                                          titleFont:[UIFont systemFontOfSize:13]
                                                                img:[UIImage imageNamed:@"detail_Tese"]
                                                            backImg:backImgNor backColor:nil
                                                               rect:CGRectMake(kViewX(self.goodsInfo_Button)+kViewWidth(self.goodsInfo_Button), kVCHeight(self)-kFootButtonHeight, kVCWidth(self)/4, kFootButtonHeight) itemBlock:^{
                                                                          [vc modifyButton:vc.goodsSpec_Button];
                                                                   [vc addFeatureView];
    }];
    [self.goodsSpec_Button setImageEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, -30)];
    [self.goodsSpec_Button setTitleEdgeInsets:UIEdgeInsetsMake(30,0, 0, 18)];
    [self.view addSubview:self.goodsSpec_Button];
    
    self.goodsAttention_Button = [[FW_CustomButton alloc] initWithButton:@"玩转"
                                                              titleColor:titleColor
                                                               titleFont:[UIFont systemFontOfSize:13]
                                                                     img:[UIImage imageNamed:@"detail_Wanzhuan"]
                                                                 backImg:backImgNor
                                                               backColor:nil
                                                                    rect:CGRectMake(kViewX(self.goodsSpec_Button)+kViewWidth(self.goodsSpec_Button), kVCHeight(self)-kFootButtonHeight, kVCWidth(self)/4, kFootButtonHeight) itemBlock:^{
                                                   [vc modifyButton:vc.goodsAttention_Button];
                                                                        [vc addGoodsTeseView];
    }];
    [self.goodsAttention_Button setImageEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, -26)];
    [self.goodsAttention_Button setTitleEdgeInsets:UIEdgeInsetsMake(30,0, 0, 18)];
    [self.view addSubview:self.goodsAttention_Button];
    
    self.goodsComment_Button = [[FW_CustomButton alloc] initWithButton:@"评论"
                                                            titleColor:titleColor
                                                             titleFont:[UIFont systemFontOfSize:13]
                                                                   img:[UIImage imageNamed:@"detail_Pinglun"]
                                                               backImg:backImgNor
                                                             backColor:nil
                                                                  rect:CGRectMake(kViewX(self.goodsAttention_Button)+kViewWidth(self.goodsAttention_Button), kVCHeight(self)-kFootButtonHeight, kVCWidth(self)/4, kFootButtonHeight) itemBlock:^{
                                                                       [vc modifyButton:vc.goodsComment_Button];
                                                                      [vc addCommentview];
        
    }];
    [self.goodsComment_Button setImageEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, -26)];
    [self.goodsComment_Button setTitleEdgeInsets:UIEdgeInsetsMake(30,0, 0, 18)];
    [self.view addSubview:self.goodsComment_Button];
}

- (void)modifyButton:(UIButton *)aButton
{
    UIImage *backImgNor = [UIImage imageNamed:@"detailButton_nor"];
    UIImage *backImgSel = [UIImage imageNamed:@"detailButton_sel"];
    [self.currentButton setBackgroundImage:backImgNor forState:UIControlStateNormal];
    self.currentButton = aButton;
    [aButton setBackgroundImage:backImgSel forState:UIControlStateNormal];
}

- (void)addCommentview
{
    if(commentView == nil)
    {
        commentView = [[FW_GoodsComsView alloc] initWithFrame:CGRectMake(0, self.g_OffsetY, kVCWidth(self), kVCHeight(self)-kFootButtonHeight)];
        [self.view addSubview:commentView];
        [commentView requestComment:self.infoData.strProductId];
    }
    else
    {
        [self.view bringSubviewToFront:commentView];
    }
}

- (void)addGoodsTeseView
{
    if(teseView == nil)
    {
        teseView = [[FW_TeseView alloc] initWithFrame:CGRectMake(0, self.g_OffsetY, kVCWidth(self), kVCHeight(self)-kFootButtonHeight-self.g_OffsetY)];
        [self.view addSubview:teseView];
        [teseView requestTeseData:self.infoData.strProductId];
        
    }
    else
    {
        [self.view bringSubviewToFront:teseView];
    }
}

- (void)addGoodsInfoView
{
    if(goodsInfoview == nil)
    {
        goodsInfoview = [[FW_GoodsInfoView alloc] initWithFrame:CGRectMake(0, self.g_OffsetY, kVCWidth(self), kVCHeight(self)-kFootButtonHeight-self.g_OffsetY)];
        [self.view addSubview:goodsInfoview];
    }
    else
    {
        [self.view bringSubviewToFront:goodsInfoview];
    }

    [goodsInfoview setGoodsInfo:self.infoData];
    [goodsInfoview addDetailHeadView];
    [goodsInfoview addBrowserVC:self.infoData.productUrlsArry];
    [goodsInfoview initIntroduceView];
}

- (void)addFeatureView
{
    if(!featurevc)
    {
        featurevc = [[FWFeatureViewController alloc] initWithFrame:CGRectMake(0, self.g_OffsetY, kVCWidth(self), kVCHeight(self)-kFootButtonHeight)];
        [self.view addSubview:featurevc];
        if(!self.strProductId)
        {
            self.strProductId = self.infoData.strProductId;
        }
        [featurevc requestWZData:self.strProductId];
    }
    else
    {
        [self.view bringSubviewToFront:featurevc];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    CGFloat duration = 0.2;//[UIApplicationsharedApplication].statu;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    self.navigationController.view.transform = CGAffineTransformIdentity;
//    self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI*(90)/180.0);
//    self.navigationController.view.bounds = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//    self.navigationController.view.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    CGFloat duration = 0.2;//[UIApplicationsharedApplication].statu;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    self.navigationController.view.transform = CGAffineTransformIdentity;
//    self.navigationController.view.transform = CGAffineTransformMakeRotation((M_PI*(0)/180.0));
//    self.navigationController.view.bounds = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//    self.navigationController.view.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)dealloc
{
    classAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.isRotation = NO;
}

@end
