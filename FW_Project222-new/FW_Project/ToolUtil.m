//
//  ToolUtil.m
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "ToolUtil.h"
#import <CoreGraphics/CoreGraphics.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation ToolUtil

+ (NSMutableArray *)stringRangForArry:(NSString *)aStr font:(UIFont *)aFont rangWidth:(int)aWidth
{
    if(aStr == nil)
    {
        return 0;
    }
    NSMutableArray *strArry = [[NSMutableArray alloc] init];
    int line = 0;
    int availableWidth=aWidth;
    float usedWidth=0;
    CGSize chSize=CGSizeZero;
    CGSize constrainedSize=CGSizeMake(aWidth, 50);
    
    int lastloopend = -1;
    NSString* content = aStr;
    
    int length = content.length;
    NSString *subString = nil;
    for(int iloop = 0; iloop < length; iloop++)
    {
        
        NSString* ch=[content substringWithRange:NSMakeRange(iloop, 1)];
        
        chSize = [ch sizeWithFont: aFont constrainedToSize:constrainedSize lineBreakMode:0];
        if (chSize.width+usedWidth>=availableWidth)
        {
            line++;
            lastloopend = iloop-1;
            
            iloop--;
            
            usedWidth = 0;
            if(subString == nil)
            {
                NSRange subRang;
                subRang.location = 0;
                subRang.length = lastloopend-subRang.location;
                subString = [aStr substringWithRange:subRang];
                [strArry addObject:subString];
            }
            else
            {
                NSRange subRang;
                subRang.location = 0;
                for(NSString *sub in strArry)
                {
                    subRang.location += sub.length;
                }
                subRang.length = lastloopend-subRang.location;
                subString = [aStr substringWithRange:subRang];
                [strArry addObject:subString];
            }
        }
        else
        {
            usedWidth+=chSize.width;
        }
    }
    
    line += 1;
    if(line > [strArry count])
    {
        NSRange subRang;
        subRang.location = 0;
        for(NSString *sub in strArry)
        {
            subRang.location += sub.length;
        }
        subRang.length = aStr.length-subRang.location;
        subString = [aStr substringWithRange:subRang];
        [strArry addObject:subString];
    }
    
    return strArry;
}

+ (UILabel *)getNavgationTitleView:(NSString*)aStr fontsize:(int)aFontsize
{
    CGSize size = [aStr sizeWithFont:[UIFont boldSystemFontOfSize:aFontsize]];
    int offsetX = (320-size.width)/2;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, size.width, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = aStr;
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:aFontsize];
    return titleLabel;
}

+ (int)stringLine:(UIFont*)aFont str:(NSString*)aStr rang:(int)aWidth
{
    if(aStr == nil)
    {
        return 0;
    }
    int line = 0;
    int availableWidth=aWidth;
    float usedWidth=0;
    CGSize chSize=CGSizeZero;
    CGSize constrainedSize=CGSizeMake(aWidth, 50);
    
    int lastloopend = -1;
    NSString* content = aStr;
    
    int length = content.length;
    
    for(int iloop = 0; iloop < length; iloop++)
    {
        
        NSString* ch=[content substringWithRange:NSMakeRange(iloop, 1)];
        
        chSize = [ch sizeWithFont: aFont constrainedToSize:constrainedSize lineBreakMode:0];
        if (chSize.width+usedWidth>=availableWidth)
        {
            line++;
            lastloopend = iloop-1;
            
            iloop--;
            
            usedWidth = 0;
        }
        else
        {
            usedWidth+=chSize.width;
        }
    }
    
    line += 1;
    
    return line;
}


+(UIImage *)fixOrientation:(UIImage *)aImage
{
    if (aImage == nil)
    {
        return nil;
    }
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
        {
            transform = CGAffineTransformIdentity;
            break;
        }
        case UIImageOrientationUpMirrored: //EXIF = 2
        {
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        }
        case UIImageOrientationDown: //EXIF = 3
        {
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        }
        case UIImageOrientationDownMirrored: //EXIF = 4
        {
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        }
        case UIImageOrientationLeftMirrored: //EXIF = 5
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        }
        case UIImageOrientationLeft: //EXIF = 6
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        }
        case UIImageOrientationRightMirrored: //EXIF = 7
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        }
        case UIImageOrientationRight: //EXIF = 8
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        }
        default:
        {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
        }
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

+ (BOOL)isIOS7
{
    if(kSystemVersion >= 7.0)
    {
        return YES;
    }
    return NO;
}


// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
