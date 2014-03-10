//
//  FWBrandsCell.m
//  FW_Project
//
//  Created by  striveliu on 13-12-6.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FWBrandsCell.h"
#import "GoodsDataList.h"
#import "UIImageView+WebCache.h"

@implementation FWBrandsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell:(NSString *)aImgUrl dec:(NSString*)aDec
{
    if(!goodsImgview)
    {
        goodsImgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self.contentView addSubview:goodsImgview];
    }
    NSURL *imgurl = [NSURL URLWithString:aImgUrl];
    [goodsImgview setImageWithURL:imgurl placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    if(!descLabel)
    {
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewX(goodsImgview)+kViewWidth(goodsImgview)+5, kViewY(goodsImgview)+3, 240, 30)];
        [self addSubview:descLabel];
    }
    descLabel.text = aDec;
    descLabel.textColor = RGBCOLOR(51, 51, 51);
}

@end
