//
//  FWFeatureView.h
//  FW_Project
//
//  Created by  striveliu on 13-11-24.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeatureData;
@interface FWFeatureView : UIView
{
    UIImageView *imgview;
//    UIImageView *headView;
//    UILabel *nameLabel;
//    UILabel *contentlabel;
}
@property (nonatomic, assign)int type;

- (void)createImgview:(FeatureData *)aData;
//- (void)createCommentView:(NSString *)aUrl name:(NSString *)aStrName content:(NSString*)aStrContent;
+ (CGFloat)getImgview:(FeatureData *)aData;
+ (CGFloat)getCommentHeight;
@end
