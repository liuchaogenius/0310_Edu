//
//  FW_CommentCell.h
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsCommentData;
@interface FW_CommentCell : UITableViewCell
{
    UIView *lineview;
}
@property(nonatomic, strong)GoodsCommentData *comData;
- (void)setCommentData:(GoodsCommentData *)aComData;
+ (CGFloat)getHeight:(GoodsCommentData *)aComentData;
@end
