//
//  FW_GoodsPictCell.m
//  FW_Project
//
//  Created by  striveliu on 13-10-5.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_GoodsPictCell.h"
#import "UIImageView+WebCache.h"

#define kSegmentation   164

@implementation FW_GoodsPictCell
@synthesize touchLeftblock;
@synthesize touchlistblock;
@synthesize touchRightblock;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}
#pragma mark 图片左右排版加标题 使用setleft and setright
- (void)setleftView:(NSString *)aImgUrl title:(NSString*)aTitle index:(int)aIndex
{
    if(leftImgView == nil)
    {
        leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 80, 80)];
        [self.contentView addSubview:leftImgView];
    }
    leftImgView.tag = aIndex;
    [leftImgView setImageWithURL:[NSURL URLWithString:aImgUrl]];
    
    if(leftTitleLabel == nil)
    {
        leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kViewY(leftImgView)+kViewHeight(leftImgView)+5, 160, 16)];
        [self.contentView addSubview:leftTitleLabel];
    }
    leftTitleLabel.font = [UIFont systemFontOfSize:14];
    leftTitleLabel.textColor = RGBCOLOR(170, 170, 170);
    leftTitleLabel.text = aTitle;
    leftTitleLabel.textAlignment = 1;
    [self addCellLine:leftTitleLabel];
}
- (void)setRightView:(NSString *)aImgUrl title:(NSString*)aTitle index:(int)aIndex
{
    if(rightImgView == nil)
    {
        rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 5, 80, 80)];
        [self.contentView addSubview:rightImgView];
    }
    rightImgView.tag = aIndex;
    [rightImgView setImageWithURL:[NSURL URLWithString:aImgUrl]];
    
    if(rightTitleLabel == nil)
    {
        rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, kViewY(rightImgView)+kViewHeight(rightImgView)+5, 160, 16)];
        [self.contentView addSubview:rightTitleLabel];
    }
    rightTitleLabel.font = [UIFont systemFontOfSize:14];
    rightTitleLabel.textColor = RGBCOLOR(170, 170, 170);
    rightTitleLabel.text = aTitle;
    rightTitleLabel.textAlignment = 1;
    
    [self setNeedsDisplay];
}

+ (CGFloat)getCellHeight
{
    return 120;
}

#pragma mark 图片list即一张图片 一个个标题 排版使用一下函数
- (void)setImgList:(NSString *)aImgUrl title:(NSString *)aStrTitle
             index:(int)aIndex modifyTime:(NSString *)aTime
{
    if(listImgView == nil)
    {
        listImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];
        [self.contentView addSubview:listImgView];
    }
    listImgView.tag = aIndex;
    [listImgView setImageWithURL:[NSURL URLWithString:aImgUrl]];
    
    if(listTitleLabel == nil)
    {
        listTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewX(listImgView)+kViewWidth(listImgView)+10, kViewY(listImgView)+15, kViewWidth(self)-kViewWidth(listImgView)-20, 16)];
        [self.contentView addSubview:listTitleLabel];
    }
    listTitleLabel.font = kFontSize(14);
    listTitleLabel.textColor = RGBCOLOR(102, 102, 102);
    listTitleLabel.text = aStrTitle;//[NSString stringWithFormat:@"%@   %@",aStrTitle, aTime];
    listTitleLabel.textAlignment = 0;
    
    if(!updateLabel)
    {
        updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewX(listImgView)+kViewWidth(listImgView)+10, kViewY(listTitleLabel)+kViewHeight(listTitleLabel)+10, kViewWidth(self)-kViewWidth(listImgView)-20, 16)];
        [self.contentView addSubview:updateLabel];
    }
    updateLabel.font = kFontSize(12);
    updateLabel.textColor = RGBCOLOR(153, 153, 153);
    updateLabel.text = [NSString stringWithFormat:@"最近更新时间: %@", aTime];
    updateLabel.textAlignment = 0;
    
    
    [self addCellLine:listImgView];
}

- (void)setlistblock:(void(^)(int index))alistblock
{
    kSafeid(touchlistblock);
    touchlistblock = alistblock;
}
- (void)setleftblock:(void(^)(int index))aleftblock
{
    kSafeid(touchLeftblock);
    touchLeftblock = aleftblock;
}
- (void)setRightblock:(void(^)(int index))arightblock
{
    kSafeid(touchRightblock);
    touchRightblock = arightblock;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if(self.viewType == 0)
    {
        if(touchlistblock)
        {
            touchlistblock(listImgView.tag);
        }
    }
    else if(self.viewType == 1)
    {
        if(point.x < kSegmentation)
        {
            if(touchLeftblock)
            {
                touchLeftblock(leftImgView.tag);
            }
        }
        else
        {
            if(touchRightblock)
            {
                touchRightblock(rightImgView.tag);
            }
        }
    }
}

+ (CGFloat)getListCellHeight
{
    return 100;
}

- (void)addCellLine:(UIView *)offsetView
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kViewY(offsetView)+ kViewHeight(offsetView)+4-0.5, 320, 0.5)];
    lineView.backgroundColor = RGBCOLOR(153, 153, 153);//[UIColor grayColor];
    [self addSubview:lineView];
}

- (void)dealloc
{
    touchRightblock = nil;
    touchlistblock = nil;
    touchLeftblock = nil;
}
@end
