//
//  ViewController2.h
//  PagedFlowView
//
//  Created by  striveliu on 13-8-23.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"
@interface BroswerImgViewController : UIViewController<PagedFlowViewDelegate,PagedFlowViewDataSource>
{
    
}

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *ImgaDataArry;
@property (nonatomic, strong) PagedFlowView *hFlowView;
@property (nonatomic, strong) PagedFlowView *vFlowView;
@property (nonatomic, strong) UIPageControl *hPageControl;
@property (nonatomic, copy) void(^didScrollerNum)(BroswerImgViewController *view, int index);
- (void)setdidScrollerNumBlock:(void(^)(BroswerImgViewController *view, int index))aBlock;
@end
