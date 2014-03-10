//
//  PageView.m
//  snstaoban
//
//  Created by  striveliu on 13-8-29.
//  Copyright (c) 2013年 Bo Xiu. All rights reserved.
//

#import "PageView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#define kImgSpace  20
#define kBrowserSize  225
@implementation PageView
@synthesize index;
@synthesize didScrollerNum;
@synthesize isLink;
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        isLink = NO;
    }
    return self;
}

- (void)setImgUrl:(NSString *)aStrurl price:(NSString *)aPrice
{
    if(imageView == nil)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-kImgSpace, 0, kBrowserSize-1, kBrowserSize-1)];
        [self addSubview:imageView];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(-kImgSpace, 0, kBrowserSize-1, kBrowserSize-1);
    CALayer *layer=[imageView layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:0.5f];
    UIColor *bordColor = RGBCOLOR(221, 221, 221);
    [layer setBorderColor:[bordColor CGColor]]; 
    [imageView setImage:nil];
    NSURL *url = [NSURL URLWithString:aStrurl];
   // __weak PageView *view = self;
    __weak __block UIImageView *imageViewcopy = imageView;
    [imageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        if(image == nil)
      
        if(image != nil){
            CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnim.fromValue = [NSNumber numberWithFloat:0.1];
            opacityAnim.toValue = [NSNumber numberWithFloat:1.0f];
            
            opacityAnim.duration = 0.5f;
            opacityAnim.removedOnCompletion = YES;
            
            [imageViewcopy.layer addAnimation:opacityAnim forKey:@"opacityAnim"];
        }}];
    BOOL link = [[dictLink objectForKey:[NSNumber numberWithInt:index]] boolValue];
    if(link == YES)
    {
        if(!linkImgView)
        {
            linkImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HTLinkMarkBackground.png"]];
            linkImgView.frame = CGRectMake(imageView.frame.origin.x+imageView.frame.size.width-16-0.5f, imageView.frame.origin.y+0.5f, 16, 16);
            [self addSubview:linkImgView];
        }
    }
    else
    {
        [linkImgView removeFromSuperview];
        linkImgView = nil;
    }

    
    if(aPrice)
    {
        NSString *strPrice = [NSString stringWithFormat:@"¥ %@", aPrice];
        CGSize size = [strPrice sizeWithFont:[UIFont systemFontOfSize:14]];
        if(priceLabel == nil)
        {
            
            priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width-size.width-10, imageView.frame.origin.y+imageView.frame.size.height-32, size.width+10, 20)];
            [self addSubview:priceLabel];
        }
        priceLabel.frame = CGRectMake(imageView.frame.origin.x+imageView.frame.size.width-size.width-20, imageView.frame.origin.y+imageView.frame.size.height-32, size.width+19.5, 20);
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont systemFontOfSize:12.0f];
        priceLabel.textColor = [UIColor colorWithRed:51.0f/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        priceLabel.text = strPrice;
        priceLabel.textAlignment = UITextAlignmentCenter;
        priceLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"feedDetailPrice.png"]];
    }
    
}

- (void)setIsLink:(BOOL)aIsLink
{
    if(!dictLink)
    {
        dictLink = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    [dictLink setObject:[NSNumber numberWithBool:aIsLink] forKey:[NSNumber numberWithInt:index]];
}

- (void)tapImgviewitem
{

}

- (void)setIndex:(int)aIndex
{
    index = aIndex;
}

- (void)setdidScrollerNumBlock:(void(^)(PageView *view, int index))aBlock
{
    if(didScrollerNum)
    {
        didScrollerNum = nil;
    }
    didScrollerNum = aBlock;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(maskView == nil)
    {
        maskView = [[UIView alloc] initWithFrame:imageView.frame];
        [self addSubview:maskView];
    }
    [self bringSubviewToFront:maskView];
    maskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    [super touchesBegan:touches withEvent:event];
}

 - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(maskView)
    {
        [maskView removeFromSuperview];
        maskView = nil;
    }
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(didScrollerNum)
    {
        didScrollerNum(self, index);
    }
    if(maskView)
    {
        [maskView removeFromSuperview];
        maskView = nil;
    }
    [super touchesEnded:touches withEvent:event];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    if(isDraw)
//    {
//        CGRect rect = imageView.frame;
//        ILog(@"1111111=%.2f,%.2f,%.2f,%.2f",rect.origin.x, rect.origin.y, rect.size.width,rect.size.height);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        CGContextSetRGBFillColor(context,255.0/256.0, 133.0/256.0, 0.0/256.0, 0.5);
//        CGContextFillRect(context, rect);
//        CGContextRestoreGState(context);
//    }
//    else
//    {
//        CGRect rect = imageView.frame;
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        CGContextSetRGBFillColor(context,255/256.0, 255/256.0, 255/256.0, 0.5);
//        CGContextFillRect(context, rect);
//        CGContextRestoreGState(context);
//    }
}


@end
