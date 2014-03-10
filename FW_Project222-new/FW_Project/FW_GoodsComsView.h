//
//  FW_GoodsComsView.h
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInputToolbar.h"

@interface FW_GoodsComsView : UIView<UITableViewDataSource,
                              UITableViewDelegate,UIInputToolbarDelegate>
{
    int oldKeyHeight;
    NSString *strProductID;
    CGRect inputBarRect;
}
@property (nonatomic, strong)UIInputToolbar *inputToolBar;
@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)NSMutableArray *comsArry;

- (void)requestComment:(NSString *)aStrid;
@end
