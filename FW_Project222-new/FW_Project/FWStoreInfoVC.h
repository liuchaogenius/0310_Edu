//
//  FWStoreInfoVC.h
//  FW_Project
//
//  Created by  striveliu on 14-1-7.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWStoreInfoVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *storeArry;

- (void)requestStoreInfo:(NSString *)strId;
@end
