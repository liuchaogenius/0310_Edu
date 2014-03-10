//
//  FW_GoodsInfoView.h
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePhotosDataSource.h"
#import "PagePhotosView.h"
@class GoodsBaseInfo;
@class FW_DetailIntroduceView;
@class FW_DetailHeadView;

@interface FW_GoodsInfoView : UIView<PagePhotosDataSource>
{
    UIScrollView *scrollerView;
    int scrollerOffsetHeight;
}
@property(nonatomic, strong)GoodsBaseInfo *goodsInfo;
@property(nonatomic, strong)PagePhotosView *browserImgVC;
@property(nonatomic, strong)NSArray *imgArry;
@property(nonatomic, strong)FW_DetailIntroduceView *introduceView;
@property(nonatomic, strong)FW_DetailHeadView *headView;
- (void)addDetailHeadView;
- (void)addBrowserVC:(NSArray *)aImgArry;
- (void)initIntroduceView;
- (void)setProductData:(GoodsBaseInfo *)aInfo;
@end
