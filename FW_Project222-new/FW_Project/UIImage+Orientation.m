//
//  UIImage+Orientation.m
//  FW_Project
//
//  Created by  striveliu on 13-12-13.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "UIImage+Orientation.h"

@implementation UIImage (Orientation)

- (UIImage*)iconImageWithWidth:(double)radius border:(double)border borderColor:(UIColor*)color
{
    UIImage * result  = nil;
    
    int width = 320;
    if(self.size.width<width)
    {
        width = self.size.width;
    }
    int height = width*self.size.height/self.size.width;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        width = width * [UIScreen mainScreen].scale;
        height = height * [UIScreen mainScreen].scale;
        border = border * [UIScreen mainScreen].scale;
    }
    
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGSize imgSize = self.size;
    CGFloat mid = width/2;
    
    
    // use path
    CGMutablePathRef paths = CGPathCreateMutable();
    
    CGPathMoveToPoint(paths, nil, 0, mid);
    CGPathAddArcToPoint(paths, nil, 0, 0, mid, 0, radius);
    CGPathAddArcToPoint(paths,nil, width, 0, width, mid, radius);
    CGPathAddArcToPoint(paths,nil, width, width, mid, width, radius);
    CGPathAddArcToPoint(paths,nil,0, width, 0, mid, radius);
    CGPathCloseSubpath(paths);
    CGContextAddPath(context, paths);
    
    
    
    CGContextClip(context);
    
    
    
    if (self.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM(context, width, width);
        CGContextRotateCTM(context, 180 * (M_PI/180));
    } else if (self.imageOrientation == UIImageOrientationLeft) {
        CGContextTranslateCTM(context, width, 0);
        CGContextRotateCTM(context, 90 * (M_PI/180));
        CGFloat tmp = imgSize.width;
        imgSize.width  = imgSize.height;
        imgSize.height = tmp;
    } else if (self.imageOrientation == UIImageOrientationRight) {
        CGContextTranslateCTM(context, 0, width);
        CGContextRotateCTM(context, -90 * (M_PI/180));
        CGFloat tmp = imgSize.width;
        imgSize.width  = imgSize.height;
        imgSize.height = tmp;
    }
    
    
    
    if(imgSize.width > imgSize.height){
        
        CGFloat w = imgSize.width;//MAX(imgSize.width, width);
        CGFloat rate = w/imgSize.height;
        
        CGContextDrawImage(context, CGRectMake(floor(-(rate-1)/2*width), 0, floor(rate*width), floor(width)), self.CGImage);
        
    }
    else{
        CGFloat h = imgSize.height;//MAX (width, imgSize.height);
        CGFloat rate = h/imgSize.width;
        
        CGContextDrawImage(context, CGRectMake(0, floor(-(rate-1)/2*width), floor(width), floor(rate*width)), self.CGImage);
    }
    
    
    
//    CGContextSetStrokeColorWithColor(context, color.CGColor);
//    CGContextAddPath(context, paths);
//    CGContextSetLineWidth(context, border);
//    
//    CGContextDrawPath(context,kCGPathStroke);
    CGPathRelease(paths);
    
    CGImageRef roundImage = CGBitmapContextCreateImage(context);
    
    if(context) CGContextRelease (context);
    
    
    //     if ([self respondsToSelector:@selector(scale)]) {
    //        result = [UIImage imageWithCGImage:roundImage scale:self.scale orientation:self.imageOrientation];
    //    }else {
    //        result = [UIImage imageWithCGImage:roundImage];
    //    }
    //
    result = [UIImage imageWithCGImage:roundImage];
    
    if(roundImage) CGImageRelease(roundImage);
    
    if(colorSpace) CGColorSpaceRelease(colorSpace);
    return result;
}

@end
