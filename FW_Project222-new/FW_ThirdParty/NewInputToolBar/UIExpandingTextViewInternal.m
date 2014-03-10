//
//  UIExpandingTextViewInternal.m
//  snstaoban
//
//  Created by  striveliu on 13-9-16.
//  Copyright (c) 2013年 Bo Xiu. All rights reserved.
//

#import "UIExpandingTextViewInternal.h"
#define kTopContentInset 0
#define lBottonContentInset 6

@implementation UIExpandingTextViewInternal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setContentOffset:(CGPoint)s
{
    /* Check if user scrolled */
	if(self.tracking || self.decelerating)
    {
		self.contentInset = UIEdgeInsetsMake(kTopContentInset, 0, 0, 0);
	}
    else
    {
		float bottomContentOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(s.y < bottomContentOffset && self.scrollEnabled)
        {
			self.contentInset = UIEdgeInsetsMake(kTopContentInset, 0, lBottonContentInset, 0);
		}
	}
	[super setContentOffset:s];
}

-(void)setContentInset:(UIEdgeInsets)s
{
	UIEdgeInsets edgeInsets = s;
	edgeInsets.top = kTopContentInset;
	if(s.bottom > 12)
    {
        edgeInsets.bottom = 4;
    }
	[super setContentInset:edgeInsets];
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
