//
//  FW_DetailIntroduceView.h
//  FW_Project
//
//  Created by  striveliu on 13-10-24.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsBaseInfo;
@interface FW_DetailIntroduceView : UIView
{
    int iOffsetY;
    UIImageView *goodsImgView;
    NSMutableDictionary *parameDict;
    NSMutableArray *keyArry;
    UILabel *desLabel;
    UIView *view;
}

@property(nonatomic, strong)GoodsBaseInfo *goodsInfo;

- (void)setProductData:(GoodsBaseInfo *)aInfo;
+ (CGFloat)getHeight:(GoodsBaseInfo *)aInfo;

@end
