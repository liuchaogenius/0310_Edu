//
//  FW_CustomButton.m
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_CustomButton.h"



@implementation FW_CustomButton
@synthesize buttonItemBlock;


- (UIButton *)initWithButton:(NSString *)aTitle
                titleColor:(UIColor *)aTitleColor
                 titleFont:(UIFont *)aTitleFont
                       img:(UIImage *)aImg
                   backImg:(UIImage *)aBackImg
                 backColor:(UIColor *)aBackColor
                      rect:(CGRect)aRect
                 itemBlock:(void (^)())aBlock
{
    if(self = [super init])
    {
        if(aTitle)
        {
            [self setTitle:aTitle forState:UIControlStateNormal];
        }
        if(aTitleColor)
        {
            [self setTitleColor:aTitleColor forState:UIControlStateNormal];
        }
        else
        {
            [self setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
        }
        if(aTitleFont)
        {
            self.titleLabel.font = aTitleFont;
        }
        if(aImg)
        {
            [self setImage:aImg forState:UIControlStateNormal];
        }
        if(aBackColor)
        {
            [self setBackgroundColor:aBackColor];
        }
        else
        {
            [self setBackgroundColor:[UIColor clearColor]];
        }
        if(aBackImg)
        {
            [self setBackgroundImage:aBackImg forState:UIControlStateNormal];
        }
        if(aBlock)
        {
            [self addTarget:self action:@selector(buttonItem) forControlEvents:UIControlEventTouchUpInside];
            buttonItemBlock = aBlock;
        }
        self.frame = aRect;
    }
    return self;
}


- (void)buttonItem
{
    if(buttonItemBlock)
    {
        buttonItemBlock();
    }
}


- (void)dealloc
{
    buttonItemBlock = nil;
}


+ (UIView *)goBackButton:(id)aItemId action:(SEL)aSelector
{
    CGRect buttonFrame = CGRectMake(-5, 0, 88/2, 44);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button setBackgroundImage:[UIImage imageNamed:@"fw_back"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"navigation_back_hi.png"] forState:UIControlStateHighlighted];
    [button addTarget:aItemId action:aSelector forControlEvents:UIControlEventTouchUpInside];
    
    CGRect viewFrame = CGRectMake(0, 0, 88/2, 44);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    [view addSubview:button];
    
    
    return view;
    
}

@end
