//
//  UIImage+Extensions.h
//  FW_Project
//
//  Created by  striveliu on 13-12-14.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageRotatedByUp;
@end
