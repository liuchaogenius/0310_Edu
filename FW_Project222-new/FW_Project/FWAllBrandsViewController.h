//
//  FWAllBrandsViewController.h
//  FW_Project
//
//  Created by  striveliu on 13-12-6.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(int, viewtype)
{
    e_listViewType,
    e_lrViewType
};

@interface FWAllBrandsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *arry;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, assign) BOOL isHeadView;
@property (nonatomic, assign) int viewType;

- (void)requestAllBrands;
- (void)setNavgationItemTitle:(NSString *)aTitle;
- (void)setHeadViewDesc:(NSString *)strTitle height:(CGFloat)aHeight;
@end
