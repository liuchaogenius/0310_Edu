//
//  FW_CustomButton.h
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FW_CustomButton : UIButton

- (UIButton *)initWithButton:(NSString *)aTitle
                  titleColor:(UIColor *)aTitleColor
                   titleFont:(UIFont *)aTitleFont
                         img:(UIImage *)aImg
                     backImg:(UIImage *)aBackImg
                   backColor:(UIColor *)aBackColor
                        rect:(CGRect)aRect
                   itemBlock:(void (^)())aBlock;
@property(nonatomic, copy)void(^buttonItemBlock)();
+ (UIView *)goBackButton:(id)aItemId action:(SEL)aSelector;
@end
