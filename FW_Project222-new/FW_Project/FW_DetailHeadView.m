//
//  DetailHeadView.m
//  FW_Project
//
//  Created by  striveliu on 13-10-26.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_DetailHeadView.h"
#import "UIImageView+WebCache.h"
#import "FW_CustomButton.h"
#import "FWStoreInfoVC.h"
#import <QuartzCore/QuartzCore.h>
@implementation FW_DetailHeadView
@synthesize headImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHeadData:(NSString *)aHeadUrl
               name:(NSString*)aGoodsName
              count:(int)aCollectCount
          productid:(NSString *)aId
{
    strProductId = aId;
    self.backgroundColor = RGBACOLOR(232, 42, 42,0.95f);
    strName = aGoodsName;
    __weak FW_DetailHeadView *view = self;
    if(headImgView == nil)
    {
        headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 75, 75)];
        [headImgView setImage:[UIImage imageNamed:@"detail_headBg"]];
        [self addSubview:headImgView];
    }
    [headImgView setImageWithURL:[NSURL URLWithString:aHeadUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [view.headImgView setImage:image];
    }];
    CALayer *lay  = headImgView.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:35.0];
    __weak FW_DetailHeadView *weakSelf = self;
    if(storeButton == nil)
    {
        storeButton = [[FW_CustomButton alloc] initWithButton:@"店铺信息"
                                                     titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:16]
                                                            img:[UIImage imageNamed:nil] backImg:nil
                                                      backColor:[UIColor clearColor] rect:CGRectMake(240, 40, 80, 30) itemBlock:^{
                                                          [weakSelf joinStoreInfoViewController];
                                                      }];
        [self addSubview:storeButton];
    }
    
    if(aCollectCount > 0)
    {
        iCollectCount = aCollectCount;
        NSString *strCount = nil;
        kIntToString(strCount, iCollectCount);
        if(collectButton == nil)
        {
            collectButton = [[FW_CustomButton alloc] initWithButton:strCount
                                                         titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:13]
                                                                img:[UIImage imageNamed:@"detailCollect"] backImg:nil
                                                          backColor:[UIColor clearColor] rect:CGRectMake(247, 44, 50, 20) itemBlock:^{
                                                              
                                                          }];
            [self addSubview:collectButton];
        }
    }
}

- (void)joinStoreInfoViewController
{
    FWStoreInfoVC *storevc = [[FWStoreInfoVC alloc] init];
    classAppDelegate *appDelegate = (classAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.nav pushViewController:storevc animated:YES];
    [storevc requestStoreInfo:strProductId];
    //[brandVC requestAllBrands];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    int offsetx = 0;
    int offsetY = 0;
    if(headImgView && strName)
    {
        NSMutableString *tempStr = nil;
        tempStr = [[NSMutableString alloc] init];
        CGSize size = [strName sizeWithFont:[UIFont systemFontOfSize:14]];
        if(size.width>150)
        {
            NSArray *arry = [ToolUtil stringRangForArry:strName font:[UIFont systemFontOfSize:14] rangWidth:150];
            [tempStr appendString:[arry objectAtIndex:0]];
            [tempStr appendString:@"..."];
        }
        else
        {
            [tempStr appendString:strName];
        }
        offsetx = kViewX(headImgView)+kViewWidth(headImgView)+5;
        offsetY = kViewY(headImgView)+(kViewHeight(headImgView)-16)/2;
        //[strName drawAtPoint:CGPointMake(offsetx, offsetY) withAttributes:nil];
        CGContextRef context = UIGraphicsGetCurrentContext();
        //CGContextSaveGState(context);
        //CGContextSetTextDrawingMode(context, kCGTextStroke);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        //[[UIColor whiteColor] setFill];
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        //[strName drawAtPoint:CGPointMake(offsetx, offsetY) withFont:[UIFont systemFontOfSize:14]];
        [tempStr drawInRect:CGRectMake(offsetx, offsetY, 185, 17) withFont:[UIFont systemFontOfSize:14]];
        //CGContextRestoreGState(context);
    }
}


@end
