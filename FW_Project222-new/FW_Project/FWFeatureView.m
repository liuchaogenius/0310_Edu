//
//  FWFeatureView.m
//  FW_Project
//
//  Created by  striveliu on 13-11-24.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FWFeatureView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "FeatureData.h"
@implementation FWFeatureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self createImgview:@"http://upload.hbtv.com.cn/2012/0803/2379716867.jpg"];
//        [self createCommentView:@"http://upload.hbtv.com.cn/2012/0803/2379716867.jpg" name:@"striveliu" content:@"jfdlsjflsjdlfjsl"];
    }
    return self;
}

- (void)resetUI
{
    if(imgview)
    {
        [imgview removeFromSuperview];
        imgview = nil;
    }
//    if(headView)
//    {
//        [headView removeFromSuperview];
//        headView = nil;
//    }
//    if(nameLabel)
//    {
//        [nameLabel removeFromSuperview];
//        nameLabel = nil;
//    }
//    if(contentlabel)
//    {
//        [contentlabel removeFromSuperview];
//        contentlabel = nil;
//    }
}

- (void)createImgview:(FeatureData *)aData
{
    if(imgview == nil)
    {
        imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
        [self addSubview:imgview];
    }
    imgview.frame = CGRectMake(0, 0, self.frame.size.width, 150);
    NSURL *url = [NSURL URLWithString:aData.strBigUrl];
    [imgview setImageWithURL:url];
    
    int y = imgview.bottom+8;
    for(FeatureDetailData *detailData in aData.detailList)
    {
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, 70, 70)];
        [self addSubview:headView];
        [headView setImageWithURL:[NSURL URLWithString:detailData.strSmallUrl]];

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.frame.origin.x+headView.frame.size.width+5, headView.top+5, 150, 18)];
        [self addSubview:nameLabel];
    
        nameLabel.text = detailData.strTitle;
        nameLabel.textColor = RGBCOLOR(102, 102, 102);//[UIColor blackColor];

        //content

        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+8, 220, 40)];
        [self addSubview:contentlabel];
            
        
        contentlabel.text = detailData.strIntro;
        contentlabel.textColor = RGBCOLOR(182, 182, 182);//[UIColor blackColor];
        contentlabel.font = [UIFont systemFontOfSize:13];
        [contentlabel resizeToFit];
//        CGSize contentsize = [detailData.strIntro sizeWithFont:[UIFont systemFontOfSize:13]];
//        int line = contentsize.width/contentlabel.frame.size.width;
//        if(contentsize.width -(contentlabel.frame.size.width*line)>0)
//        {
//            line+=1;
//        }
//        contentlabel.numberOfLines = line;
//        contentlabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+8, 220, 16*line);
        if(contentlabel.bottom>headView.bottom)
        {
            y = contentlabel.bottom+8;
        }
        else
        {
            y = headView.bottom+8;
        }
    }
}

//- (void)createCommentView:(NSString *)aUrl name:(NSString *)aStrName content:(NSString*)aStrContent
//{
//    [self resetUI];
//    if(!headView)
//    {
//        headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
//        [self addSubview:headView];
//
//    }
//    NSURL *url = [NSURL URLWithString:aUrl];
//    [headView setImageWithURL:url];
////    CALayer *layer = headView.layer;
////    [layer setMasksToBounds:YES];
////    headView.contentMode = UIViewContentModeScaleToFill;
////    [layer setCornerRadius:40];
//    //name
//    if(!nameLabel)
//    {
//        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.frame.origin.x+headView.frame.size.width+5, 5, 150, 18)];
//        [self addSubview:nameLabel];
//    }
//    nameLabel.frame = CGRectMake(headView.frame.origin.x+headView.frame.size.width+5, 5, 150, 18);
//    nameLabel.text = aStrName;
//    nameLabel.textColor = [UIColor blackColor];
//    
//    //content
//    if(!contentlabel)
//    {
//        contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+8, 220, 40)];
//        [self addSubview:contentlabel];
//
//    }
//    contentlabel.text = aStrContent;
//    contentlabel.textColor = [UIColor blackColor];
//    contentlabel.font = [UIFont systemFontOfSize:13];
//    
//    CGSize contentsize = [aStrContent sizeWithFont:[UIFont systemFontOfSize:13]];
//    int line = contentsize.width/contentlabel.frame.size.width;
//    if(contentsize.width -(contentlabel.frame.size.width*line)>0)
//    {
//        line+=1;
//    }
//    contentlabel.numberOfLines = line;
//    contentlabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+8, 220, 16*line);
//}

+ (CGFloat)getImgview:(FeatureData *)aData
{
    int height = 150;
    for(int i=0; i<[aData.detailList count]; i++)
    {
        height += 80;
    }
    return height;
}
+ (CGFloat)getCommentHeight
{
    return 80;
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
