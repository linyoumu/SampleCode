//
//  UIImage+CreatedSingleColorImage.m
//  SegmentScrollView
//
//  Created by Fasa on 15/5/26.
//  Copyright (c) 2015年 Fasa Mo. All rights reserved.
//

#import "UIImage+CreatedSingleColorImage.h"

@implementation UIImage (CreatedSingleColorImage)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color forSize:CGSizeMake(2.0f, 2.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color forSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
