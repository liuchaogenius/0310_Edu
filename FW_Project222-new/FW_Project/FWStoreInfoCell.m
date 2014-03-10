//
//  FWStoreInfoCell.m
//  FW_Project
//
//  Created by  striveliu on 14-1-7.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "FWStoreInfoCell.h"
#import "StoreInfoData.h"
#import "UIImageView+WebCache.h"

#define kAddressFontsize  12
@implementation FWStoreInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createStoreInfoView:(StoreInfoData *)aData
{
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    [imgview setImageWithURL:[NSURL URLWithString:aData.strIconUrl]];
    [self addSubview:imgview];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgview.right+8, imgview.top, 190, 20)];
    descLabel.font = kFontSize(14);
    descLabel.textColor = RGBCOLOR(51, 51, 51);
    descLabel.text = aData.strDesc;
    [self addSubview:descLabel];
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgview.right+8, descLabel.bottom+8, 190, 15)];
    telLabel.font = kFontSize(14);
    telLabel.textColor = RGBCOLOR(51, 51, 51);
    telLabel.text = [NSString stringWithFormat:@"联系电话: %@", aData.strTel];
    [self addSubview:telLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgview.right+8, telLabel.bottom+8, 190, 15)];
    
    contentLabel.font = kFontSize(12);
    contentLabel.text = aData.strAddress;
    [contentLabel resizeToFit];
    [self addSubview:contentLabel];
    if(contentLabel.bottom > 90)
    {
        [self addCellLine:contentLabel];
    }
    else
    {
        [self addCellLine:imgview];
    }
}

- (void)addCellLine:(UIView *)offsetView
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kViewY(offsetView)+ kViewHeight(offsetView)+4-0.5, 320, 0.5)];
    lineView.backgroundColor = RGBCOLOR(153, 153, 153);
    [self addSubview:lineView];
}

+ (CGFloat)getHeight:(StoreInfoData *)aData
{
    CGFloat height = 90;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 15)];
    
    contentLabel.font = kFontSize(12);
    contentLabel.text = aData.strAddress;
    [contentLabel resizeToFit];
    
//    int line = [ToolUtil stringLine:kFontSize(kAddressFontsize) str:aData.strAddress rang:190];
    
    CGFloat addressHeight = contentLabel.bottom;//55+(kAddressFontsize+3)*line +6;
    contentLabel = nil;
    return MAX(height, addressHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
