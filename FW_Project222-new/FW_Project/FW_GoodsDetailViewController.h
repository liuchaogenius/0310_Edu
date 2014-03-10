//
//  FW_GoodsDetailViewController.h
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FW_GoodsComsView;
@class FW_GoodsInfoView;
@class GoodsBaseInfo;
@class FW_ScanManager;
@class FWFeatureViewController;
@class FW_TeseView;
@interface FW_GoodsDetailViewController : BaseViewController

@property(nonatomic, strong)UIButton *goodsInfo_Button;
@property(nonatomic, strong)UIButton *goodsSpec_Button;
@property(nonatomic, strong)UIButton *goodsAttention_Button;
@property(nonatomic, strong)UIButton *goodsComment_Button;
@property(nonatomic, strong)UIButton *currentButton;
@property(nonatomic, strong)FW_GoodsComsView *commentView;
@property(nonatomic, strong)FW_GoodsInfoView *goodsInfoview;
@property(nonatomic, strong)GoodsBaseInfo *infoData;
@property(nonatomic, strong)FW_ScanManager *manager;
@property(nonatomic, strong)FWFeatureViewController *featurevc;
@property(nonatomic, strong)FW_TeseView *teseView;
@property(nonatomic, strong)NSString *strProductId;
- (void)requestGoodsInfo:(NSString *)aStrid;
- (void)setNavigationTitle:(NSString*)aTitle;
@end
