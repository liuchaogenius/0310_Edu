//
//  FlashView.m
//  HHD_Prj
//
//  Created by striveliu on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FlashView.h"
//#import "TJRootViewController.h"

@implementation FlashView
@synthesize flash_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.alwaysBounceHorizontal = YES;
        //self.alwaysBounceVertical = YES;
        self.pagingEnabled = YES;
        self.directionalLockEnabled = YES;
        self.delegate = self;
        [self initFlashView];
    }
    return self;
}

- (void)initFlashView
{
    UIImage *image = [UIImage imageNamed:@"flash_1.jpg"];
    UIImageView* flashView = [[UIImageView alloc] initWithImage:image];
    flashView.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:flashView];

    
    UIImage *image2 = [UIImage imageNamed:@"flash_2.jpg"];
    UIImageView* flashView2 = [[UIImageView alloc] initWithImage:image2];
    flashView2.frame = CGRectMake(320, 0, self.width, self.height);
    [self addSubview:flashView2];

    
    UIImage *image3 = [UIImage imageNamed:@"flash_3.jpg"];
    UIImageView* flashView3 = [[UIImageView alloc] initWithImage:image3];
    flashView3.frame = CGRectMake(640, 0, self.width, self.height);
    [self addSubview:flashView3];
    
    UIImage *image4 = [UIImage imageNamed:@"flash_4.jpg"];
    UIImageView* flashView4 = [[UIImageView alloc] initWithImage:image4];
    flashView4.frame = CGRectMake(960, 0, self.width, self.height);
    [self addSubview:flashView4];

    
    self.contentSize = CGSizeMake(self.frame.size.width*4, self.height);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint offsetPoint = scrollView.contentOffset;
    if(offsetPoint.x > 960)
    {
        self.delegate = nil;
        CGRect bRect = CGRectMake((offsetPoint.x-960)-640, 0, self.width, self.height);//CGRectMake(offsetPoint.x-640, offsetPoint.y, 320-(offsetPoint.x-640), 480);
        CGRect eRect = CGRectMake(-320, 0, 320, 460);
        self.frame = CGRectMake((offsetPoint.x-960)-640, 0, self.width, self.height);
        //self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinish)];
        [UIView setAnimationDuration:0.5f];
        self.frame = bRect;//CGRectMake(265, 384, 0, 0);
        self.frame = eRect;//CGRectMake(0, 0, 974, 768);
        [UIView commitAnimations];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0)
    {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
    }
}

- (void)animationFinish
{
    if (flash_delegate && [flash_delegate respondsToSelector:@selector(flashFinishedDelegate:)])
    {
        [flash_delegate flashFinishedDelegate:self];
    }

    self.delegate = nil;
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
