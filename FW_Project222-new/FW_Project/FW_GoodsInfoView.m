//
//  FW_GoodsInfoView.m
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_GoodsInfoView.h"
#import "UIImageView+WebCache.h"
#import "GoodsBaseInfo.h"
#import "ToolUtil.h"
#import "FW_DetailIntroduceView.h"
#import "FW_DetailHeadView.h"
#define kHeadViewHeight  80
#define kBrowserHeight   280-kHeadViewHeight

@implementation FW_GoodsInfoView
@synthesize browserImgVC;
@synthesize imgArry;
@synthesize goodsInfo;
@synthesize introduceView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addScrollerview];
    }
    return self;
}

- (void)setProductData:(GoodsBaseInfo *)aInfo
{
    goodsInfo = aInfo;
}

- (void)addScrollerview
{
    scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth(self), kViewHeight(self))];
    MLOG(@"%.2f", scrollerView.frame.size.height);
    scrollerView.alwaysBounceVertical = YES;
    scrollerView.alwaysBounceHorizontal = NO;
    [self addSubview:scrollerView];
    scrollerView.backgroundColor = RGBCOLOR(246, 246, 246);
}
- (void)addBrowserVC:(NSArray *)aImgArry
{
    imgArry = aImgArry;
    if(browserImgVC == nil)
    {
        browserImgVC = [[PagePhotosView alloc] initWithFrame:CGRectMake(0, kHeadViewHeight, kViewWidth(self), kBrowserHeight) withDataSource:self];
        [scrollerView addSubview:browserImgVC];
    }
    scrollerOffsetHeight += kBrowserHeight;
}

- (void)addDetailHeadView
{
    if(self.headView == nil)
    {
        self.headView = [[FW_DetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth(self), kHeadViewHeight)];
        [self addSubview:self.headView];
    }
    [self.headView setHeadData:goodsInfo.strBrandIconUrl
                          name:goodsInfo.strProductName
                         count:0 productid:goodsInfo.strProductId];
}

- (int)numberOfPages {
    if(imgArry)
    {
	    return [imgArry count];
    }
    return 0;
}

// 每页的图片
//
- (UIImageView *)imageAtIndex:(int)index {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *strUrl = [imgArry objectAtIndex:index];
    NSURL *imgUrl = [NSURL URLWithString:strUrl];
    [imgView setImageWithURL:imgUrl];
    return imgView;
}

- (void)initIntroduceView
{
    int height = [FW_DetailIntroduceView getHeight:goodsInfo];
    if(introduceView)
    {
        [introduceView removeFromSuperview];
        introduceView = nil;
    }
    if(introduceView == nil)
    {
        int offsetY =kViewY(browserImgVC)+kViewHeight(browserImgVC);
        introduceView = [[FW_DetailIntroduceView alloc] initWithFrame:CGRectMake(0, offsetY,kViewWidth(self), height)];
        [scrollerView addSubview:introduceView];
    }
    [introduceView setProductData:goodsInfo];
    scrollerOffsetHeight = kBrowserHeight;
    //scrollerOffsetHeight = self.frame.size.height;
    //scrollerView.contentSize=CGSizeMake(self.frame.size.width, self.frame.size.height);
    scrollerOffsetHeight += height+kHeadViewHeight;
    CGSize scrollerSize = scrollerView.contentSize;
    if(scrollerOffsetHeight > scrollerSize.height)
    {
        scrollerSize.height = scrollerOffsetHeight+20;
        scrollerView.contentSize = scrollerSize;
    }
}




@end
