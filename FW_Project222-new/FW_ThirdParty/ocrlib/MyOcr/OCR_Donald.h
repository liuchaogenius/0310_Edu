//
//  OCR_Donald.h
//  OCR_Donald
//
//  Created by donald on 13-10-25.
//  Copyright (c) 2013年 donald. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OCR_Donald : NSObject
//+(IplImage *)CreateIplImageFromUIImage:(UIImage *)image;
+(int)OcrInit:(int)vwhite second:(int) vheigh thrid:(NSString *) xmlpath ;
//vwhite 视频图像宽度；  vheigh  视频图像高度 ； xmlpath： ocr.xml路径；
+(int)checkFWImage:(UIImage *)aImg;

@end

