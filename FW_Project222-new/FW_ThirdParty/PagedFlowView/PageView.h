//
//  PageView.h
//  snstaoban
//
//  Created by  striveliu on 13-8-29.
//  Copyright (c) 2013年 Bo Xiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView
{
    UILabel *priceLabel;
    UIView *maskView;
    NSMutableDictionary *dictLink;
    UIImageView *linkImgView;
}
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, assign)int index;
@property (nonatomic, copy) void(^didScrollerNum)(PageView *view, int aIndex);
@property(nonatomic, assign)BOOL isLink;
- (void)setdidScrollerNumBlock:(void(^)(PageView *view, int index))aBlock;
- (void)setImgUrl:(NSString *)aStrurl price:(NSString *)aPrice;
@end
