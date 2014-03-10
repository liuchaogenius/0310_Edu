//
//  ToolUtil.h
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//
#import<UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ToolUtil : NSObject
+ (NSMutableArray *)stringRangForArry:(NSString *)aStr font:(UIFont *)aFont rangWidth:(int)aWidth;
+ (int)stringLine:(UIFont*)aFont str:(NSString*)aStr rang:(int)aWidth;

+ (BOOL)isIOS7;

+(UIImage *)fixOrientation:(UIImage *)aImage;

+ (UILabel *)getNavgationTitleView:(NSString*)aStr fontsize:(int)aFontsize;

+ (NSString *)getIPAddress;
@end
