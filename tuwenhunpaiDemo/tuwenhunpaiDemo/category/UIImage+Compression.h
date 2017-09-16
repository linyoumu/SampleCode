//
//  UIImage+Compression.h
//  SKGShop
//
//  Created by singelet on 16/4/7.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)

- (UIImage *)compressImageToMaxFileSize:(NSInteger)maxFileSize;

+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;

+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size;

+ (UIImage *)scaleImage:(UIImage *)image;
@end
