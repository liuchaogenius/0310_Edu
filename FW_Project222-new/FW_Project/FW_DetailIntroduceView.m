//
//  FW_DetailIntroduceView.m
//  FW_Project
//
//  Created by  striveliu on 13-10-24.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_DetailIntroduceView.h"
#import "GoodsBaseInfo.h"
#import "UIImageView+WebCache.h"
#import "UILabel+dynamicSizeMe.h"
#define kIntroduceHeight  80
#define kFontSize1 12
#define kIntroduceAblityWidth  210
#define kParameWidth  100
#define kParameRightWidth   180
#define kFontSizeSpace 5
@implementation FW_DetailIntroduceView
@synthesize goodsInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        parameDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        keyArry = [NSMutableArray array];
    }
    return self;
}

- (void)setProductData:(GoodsBaseInfo *)aInfo
{
    goodsInfo = aInfo;
    [parameDict removeAllObjects];
    [self setNeedsDisplay];
}

- (void)addGoodsImgview
{
    if(!goodsImgView)
    {
        goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(18, iOffsetY+10, 60, 60)];
        [self addSubview:goodsImgView];
    }
    [goodsImgView setImageWithURL:[NSURL URLWithString:goodsInfo.strIconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    if(!desLabel)
    {
        desLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, iOffsetY+10, 220, 80)];
        [self addSubview:desLabel];
    }
    desLabel.font = [UIFont systemFontOfSize:kFontSize1];
    desLabel.text = goodsInfo.strBrandDesc;
    desLabel.textColor = RGBCOLOR(126, 125, 128);
    [desLabel resizeToFit];
    if(!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(10, iOffsetY, 300, MAX(desLabel.frame.size.height+20, kIntroduceHeight))];
        view.backgroundColor = [UIColor whiteColor];
        CALayer *layer = [view layer];
        layer.borderWidth = 0.5;
        layer.borderColor = [RGBCOLOR(213, 213, 213) CGColor];
        [self addSubview:view];
    }
    [self bringSubviewToFront:goodsImgView];
    [self bringSubviewToFront:desLabel];
}


/////////描述产品的每个参数////////////////
- (void)drawProductParam:(CGContextRef)aContext
{
    iOffsetY = 0;
    int offsetY = iOffsetY+10;
    int offsetX = 10;
    int height = [self getParamDict];
    UIFont *font = [UIFont systemFontOfSize:kFontSize1];
//    if(goodsInfo)
//    {
    
        CGRect rect = CGRectMake(offsetX, offsetY, kViewWidth(self)-20, height);
        
        //矩形，并填弃颜色
    CGContextSaveGState(aContext);
    CGContextSetLineWidth(aContext, 0.5f);
    UIColor *color = [UIColor whiteColor];
    CGContextSetFillColorWithColor(aContext, color.CGColor);
    color = RGBCOLOR(213, 213, 213);
    CGContextSetStrokeColorWithColor(aContext, color.CGColor);
    CGContextAddRect(aContext, rect);
    CGContextDrawPath(aContext, kCGPathFillStroke);
    
    color = RGBCOLOR(234, 234, 234);
    CGContextSetFillColorWithColor(aContext, color.CGColor);
    CGRect gryRect = CGRectMake(offsetX+1, offsetY+1, kParameWidth, height-2);
    CGContextAddRect(aContext, gryRect);
    CGContextDrawPath(aContext, kCGPathFillStroke);
    CGContextRestoreGState(aContext);
    
    //NSArray *keyArry = [parameDict allKeys];
    int parame_offsetY = offsetY+5;
    int parame_offsetx = offsetX;
    CGContextSaveGState(aContext);
    for(int i=0; i<[keyArry count]; i++)
    {
        NSString *strKey = [keyArry objectAtIndex:i];
        CGSize strSize = [strKey sizeWithFont:font];
        parame_offsetx = offsetX+(kParameWidth-strSize.width-5);
        UIColor *keyColor = RGBCOLOR(126, 163, 96);
        CGContextSetFillColorWithColor(aContext, keyColor.CGColor);
        [strKey drawAtPoint:CGPointMake(parame_offsetx, parame_offsetY) withFont:font];
        
        NSString *strValue = [parameDict objectForKey:strKey];
        NSArray *valueArry = [ToolUtil stringRangForArry:strValue font:font rangWidth:kParameRightWidth];
        ///////draw right text//////////
        parame_offsetx = offsetX+kParameWidth+5;
        for(int i=0; i<[valueArry count]; i++)
        {
            NSString *indexValue = [valueArry objectAtIndex:i];
            UIColor *valueColor = RGBCOLOR(126, 125, 128);
            CGContextSetFillColorWithColor(aContext, valueColor.CGColor);
            [indexValue drawAtPoint:CGPointMake(parame_offsetx, parame_offsetY) withFont:font];
            parame_offsetY += (kFontSize1+2+kFontSizeSpace);
        }
    }
    iOffsetY = parame_offsetY += (kFontSize1+2+kFontSizeSpace);
    CGContextRestoreGState(aContext);
    //}
}

- (CGFloat)getParamDict
{
    int height = 0;
    int line = 0;
    UIFont *font = [UIFont systemFontOfSize:kFontSize1];
    if(goodsInfo.strCorpName)
    {
        line = [ToolUtil stringLine:font str:goodsInfo.strCorpName rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
        [keyArry addObject:@"公司名称"];
        [parameDict setObject:goodsInfo.strCorpName forKey:@"公司名称"];
    }
    if(goodsInfo.strCorpAddress)
    {
        line = [ToolUtil stringLine:font str:goodsInfo.strCorpAddress rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
        [keyArry addObject:@"公司地址"];
        [parameDict setObject:goodsInfo.strCorpAddress forKey:@"公司地址"];
    }
    if(goodsInfo.strServiceTel)
    {
        line = [ToolUtil stringLine:font str:goodsInfo.strServiceTel rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
        [keyArry addObject:@"公司联系方式"];
        [parameDict setObject:goodsInfo.strServiceTel forKey:@"公司联系方式"];
    }
    if(goodsInfo.strCorpTel)
    {
        line = [ToolUtil stringLine:font str:goodsInfo.strCorpTel rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
        [keyArry addObject:@"客服电话"];
        [parameDict setObject:goodsInfo.strCorpTel forKey:@"客服电话"];
    }
    if(goodsInfo.strProductName)
    {
        line = [ToolUtil stringLine:font str:goodsInfo.strProductName rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
        [keyArry addObject:@"产品名称"];
        [parameDict setObject:goodsInfo.strProductName forKey:@"产品名称"];
    }
//    if(goodsInfo.strQuality)
//    {
//        line = [ToolUtil stringLine:font str:goodsInfo.strQuality rang:kParameRightWidth];
//        height += (kFontSize1+2+kFontSizeSpace)*line;
//        [keyArry addObject:@"质检报告"];
//        [parameDict setObject:goodsInfo.strQuality forKey:@"质检报告"];
//    }
    if(goodsInfo.strProductDate)
    {
        line = [ToolUtil stringLine:font str:goodsInfo.strProductDate rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
        [keyArry addObject:@"生产日期"];
        [parameDict setObject:goodsInfo.strProductDate forKey:@"生产日期"];
    }
//    if(goodsInfo.strSaleArea)
//    {
//        line = [ToolUtil stringLine:font str:goodsInfo.strSaleArea rang:kParameRightWidth];
//        height += (kFontSize1+2+kFontSizeSpace)*line;
//        [keyArry addObject:@"销售区域"];
//        [parameDict setObject:goodsInfo.strSaleArea forKey:@"销售区域"];
//    }


    return height+kFontSizeSpace;

}

+ (CGFloat)getHeight:(GoodsBaseInfo *)aInfo
{
    int height = 10;
    if(aInfo == nil)
    {
        return height;
    }
    int line = 0;
    height += 5;
    UIFont *font = [UIFont systemFontOfSize:kFontSize1];
    if(aInfo.strCorpName)
    {
        line = [ToolUtil stringLine:font str:aInfo.strCorpName rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
    }
    if(aInfo.strCorpAddress)
    {
        line = [ToolUtil stringLine:font str:aInfo.strCorpAddress rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
    }
    if(aInfo.strCorpTel)
    {
        line = [ToolUtil stringLine:font str:aInfo.strCorpTel rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
    }
    if(aInfo.strServiceTel)
    {
        line = [ToolUtil stringLine:font str:aInfo.strServiceTel rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
    }
    if(aInfo.strProductName)
    {
        line = [ToolUtil stringLine:font str:aInfo.strProductName rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
    }
//    if(aInfo.strQuality)
//    {
//        line = [ToolUtil stringLine:font str:aInfo.strQuality rang:kParameRightWidth];
//        height += (kFontSize1+2+kFontSizeSpace)*line;
//    }
    if(aInfo.strProductDate)
    {
        line = [ToolUtil stringLine:font str:aInfo.strProductDate rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
    }
    if(aInfo.strSaleArea)
    {
        line = [ToolUtil stringLine:font str:aInfo.strSaleArea rang:kParameRightWidth];
        height += (kFontSize1+2+kFontSizeSpace)*line;
    }
    height += 19;
    
    
 
    UILabel *tempdesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 80)];
 
    
    tempdesLabel.font = [UIFont systemFontOfSize:kFontSize1];
    tempdesLabel.text = aInfo.strBrandDesc;
    tempdesLabel.textColor = RGBCOLOR(126, 125, 128);
    [tempdesLabel resizeToFit];
    

    height += tempdesLabel.frame.size.height;
    height = MAX(height, kIntroduceHeight);

    height += 20;
    tempdesLabel = nil;
    return height;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawProductParam:context];
    [self addGoodsImgview];
    //[self drawProductIntroduce:context];
    
}


@end
