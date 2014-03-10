//
//  DetailHeadView.h
//  FW_Project
//
//  Created by  striveliu on 13-10-26.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FW_DetailHeadView : UIView
{
    
    NSString *strName;
    int iCollectCount;
    UIButton *collectButton;
    
    UIButton *storeButton;
    NSString *strProductId;
}
@property (nonatomic,strong) UIImageView *headImgView;
- (void)setHeadData:(NSString *)aHeadUrl
               name:(NSString*)aGoodsName
              count:(int)aCollectCount
          productid:(NSString *)aId;
@end
