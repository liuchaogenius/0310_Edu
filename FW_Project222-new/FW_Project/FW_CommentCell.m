//
//  FW_CommentCell.m
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_CommentCell.h"
#import "ToolUtil.h"
#import "GoodsCommentData.h"

#define kCommentContentFontSize 12
#define kCommentNameFontSize   14
#define kCommentTimeFontSize    11


@implementation FW_CommentCell
@synthesize comData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCommentData:(GoodsCommentData *)aComData
{
    if(comData)
    {
        comData = nil;
    }
    comData = aComData;
    self.backgroundColor = [UIColor clearColor];
    [self setNeedsDisplay];
    
    int height = [FW_CommentCell getHeight:comData];
    if(!lineview)
    {
        lineview = [[UIView alloc] initWithFrame:CGRectMake(0, height-1, 320, 0.5)];
        lineview.backgroundColor = RGBCOLOR(213, 213, 213);
        [self addSubview:lineview];
    }
}

+ (CGFloat)getHeight:(GoodsCommentData *)aComentData
{
    int height = 0;
    
    height +=kCommentContentFontSize;
    height += 5;
    
    int line = [ToolUtil stringLine:[UIFont systemFontOfSize:kCommentContentFontSize] str:aComentData.comment rang:247];
    height += (kCommentContentFontSize)*line + 3*line;
    
    height += 5;
    height +=kCommentContentFontSize+kCommentContentFontSize+18;
    return height;
}

- (void)drawRect:(CGRect)rect
{
    if(comData)
    {
        int offsetX = 10;
        int offsetY = 5;
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIFont *font = [UIFont systemFontOfSize:kCommentNameFontSize];
        UIColor *nameC = RGBCOLOR(51, 51, 51);
        CGContextSetFillColorWithColor(context, nameC.CGColor);
        if(comData.userId)
        {
            [comData.userId drawAtPoint:CGPointMake(offsetX, offsetY) withFont:font];
        }
        offsetY +=kCommentNameFontSize+10;
        
        UIColor *countC = RGBCOLOR(136, 136, 136);
        CGContextSetFillColorWithColor(context, countC.CGColor);
        NSMutableArray *contentArry = [ToolUtil stringRangForArry:comData.comment font:[UIFont systemFontOfSize:kCommentContentFontSize] rangWidth:290];
        for(NSString *str in contentArry)
        {
            [str drawAtPoint:CGPointMake(offsetX, offsetY) withFont:[UIFont systemFontOfSize:kCommentContentFontSize]];
            offsetY += kCommentContentFontSize+3;
        }
        
        offsetY += kCommentContentFontSize+8;
        if(comData.gmtCreate)
        {
            CGSize timeSize = [comData.gmtCreate sizeWithFont:[UIFont systemFontOfSize:kCommentTimeFontSize]];
            UIColor *timeC = RGBCOLOR(136, 136, 136);
            CGContextSetFillColorWithColor(context, timeC.CGColor);
            offsetX = kViewWidth(self)-timeSize.width-10;
            [comData.gmtCreate drawAtPoint:CGPointMake(offsetX, offsetY) withFont:[UIFont systemFontOfSize:kCommentTimeFontSize]];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
