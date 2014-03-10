//
//  ViewController2.m
//  PagedFlowView
//
//  Created by  striveliu on 13-8-23.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BroswerImgViewController.h"
#import "UIImageView+WebCache.h"
#import "PageView.h"

#define kBrowserSize 225
#define kImgSpace   20
@interface BroswerImgViewController ()

@end

@implementation BroswerImgViewController
@synthesize hFlowView;
@synthesize hPageControl;
@synthesize imageArray;
@synthesize ImgaDataArry;
@synthesize didScrollerNum;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

//    hPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 205, 320, 15)];
//    hPageControl.backgroundColor = [UIColor redColor];
//    [hPageControl addTarget:self action:@selector(pageControlValueDidChange:) forControlEvents:UIControlEventTouchUpInside];
    self.hFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, 320, kBrowserSize)];
    hFlowView.delegate = self;
    hFlowView.dataSource = self;
    hFlowView.pageControl = nil;
//    hFlowView.minimumPageAlpha = 0.3;
//    hFlowView.minimumPageScale = 0.9;
    hFlowView.minimumPageAlpha = 1;
    hFlowView.minimumPageScale = 1;
    //[self.view addSubview:hPageControl];
    [self.view addSubview:hFlowView];
}

- (void)setdidScrollerNumBlock:(void(^)(BroswerImgViewController *view, int index))aBlock
{
    if(didScrollerNum)
    {
        didScrollerNum = nil;
    }
    didScrollerNum = aBlock;
}

#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;{
    return CGSizeMake(kBrowserSize+kImgSpace, kBrowserSize);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView {
    NSLog(@"Scrolled to page # %d", pageNumber);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
    if(imageArray)
    {
        return [imageArray count];
    }
    else if(ImgaDataArry)
    {
        return [ImgaDataArry count];
    }
    return 0;
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{

    PageView *vew = (PageView *)[flowView dequeueReusableCell];
    
    if(vew == nil)
    {
        vew = [[PageView alloc] init];
    }
    [vew setIndex:index];
    if(imageArray && index < [imageArray count])
    {
        [vew setImgUrl:[imageArray objectAtIndex:index] price:nil];
    }
    else if(ImgaDataArry && index < [ImgaDataArry count])
    {
//        HTFeedImageData *imgData = [ImgaDataArry objectAtIndex:index];
//        if(imgData.item == NO)
//        {
//            if(imgData.linkUrl && imgData.linkUrl.length > 0)
//            {
//                vew.isLink = YES;
//            }
//            else
//            {
//                vew.isLink = NO;
//            }
//        }
//        else
//        {
//            vew.isLink = NO;
//        }
        
//        NSString *webpUrl = [ToolUtil getWebPURL:imgData.imageUrl strSize:@"540x540"];
//        NSString *strPrice = nil;
//        if(imgData.goodsPromotionPrice)
//        {
//            strPrice = imgData.goodsPromotionPrice;
//        }
//        else if(imgData.goodsPrice)
//        {
//            strPrice = imgData.goodsPrice;
//        }
        NSString *strUrl = [ImgaDataArry objectAtIndex:index];
        [vew setImgUrl:strUrl price:nil];
    }
    vew.index = index;
    __weak BroswerImgViewController *vc = self;
    [vew setDidScrollerNum:^(PageView *aView, int aIndex) {
        if(vc.didScrollerNum)
        {
            vc.didScrollerNum(vc, aIndex);
        }
    }];
    return vew;
}

//- (void)pageControlValueDidChange:(UIPageControl*)sender {
//    UIPageControl *pageControl = sender;
//    [hFlowView scrollToPage:pageControl.currentPage];
//    //[vFlowView scrollToPage:pageControl.currentPage];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    imageArray = nil;
    ImgaDataArry = nil;
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
