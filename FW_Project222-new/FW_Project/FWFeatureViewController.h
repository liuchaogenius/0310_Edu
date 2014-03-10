//
//  FWFeatureViewController.h
//  FW_Project
//
//  Created by  striveliu on 13-11-23.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWFeatureViewController : UIView<UITableViewDataSource, UITableViewDelegate>
{    
    NSMutableArray *arry;
}
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arry;
- (void)requestWZData:(NSString *)strId;
@end
