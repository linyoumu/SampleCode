//
//  UIImage+CreatedSingleColorImage.h
//  SegmentScrollView
//
//  Created by Fasa on 15/5/26.
//  Copyright (c) 2015年 Fasa Mo. All rights reserved.
//  创建纯色图片

#import <UIKit/UIKit.h>

@interface UIImage (CreatedSingleColorImage)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color forSize:(CGSize)size;
@end
