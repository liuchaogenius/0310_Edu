//
//  FW_GoodsPictCell.h
//  FW_Project
//
//  Created by  striveliu on 13-10-5.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FW_GoodsPictCell : UITableViewCell
{
    UIImageView *leftImgView;
    UIImageView *rightImgView;
    UIImageView *listImgView;
    
    UILabel *leftTitleLabel;
    UILabel *rightTitleLabel;
    UILabel *listTitleLabel;
    UILabel *updateLabel;
}
@property (nonatomic, copy) void(^touchlistblock)(int index);
@property (nonatomic, copy) void(^touchLeftblock)(int index);
@property (nonatomic, copy) void(^touchRightblock)(int index);
@property (nonatomic, assign) int viewType; ///0是list  1是左右形式
+ (CGFloat)getCellHeight;
- (void)setRightView:(NSString *)aImgUrl title:(NSString*)aTitle index:(int)aIndex;
- (void)setleftView:(NSString *)aImgUrl title:(NSString*)aTitle index:(int)aIndex;
- (void)setImgList:(NSString *)aImgUrl
             title:(NSString *)aStrTitle
             index:(int)aIndex
        modifyTime:(NSString *)aTime;
- (void)setlistblock:(void(^)(int index))alistblock;
- (void)setleftblock:(void(^)(int index))aleftblock;
- (void)setRightblock:(void(^)(int index))arightblock;

@end
