//
//  FW_TeseView.h
//  FW_Project
//
//  Created by  striveliu on 14-1-6.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsTeseData;
@interface FW_TeseView : UIView
{
    UIScrollView *scrollview;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
}
@property (nonatomic, strong) GoodsTeseData *data;

- (void)requestTeseData:(NSString *)aStrid;
@end
