//
//  UIImage+Compression.m
//  SKGShop
//
//  Created by singelet on 16/4/7.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "UIImage+Compression.h"

@implementation UIImage (Compression)

+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

- (UIImage *)compressImageToMaxFileSize:(NSInteger)maxFileSize
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)scaleImage:(UIImage *)image
{
    CGSize originalImageSize = image.size;
    CGSize imageSize = originalImageSize;
    if (originalImageSize.width >= ScreenWidth) {
        imageSize = CGSizeMake(ScreenWidth, ScreenWidth * image.size.height / image.size.width);
    }
    UIImage *scaleImage = [UIImage scaleImage:image withSize:imageSize]; //缩放图片
    return scaleImage;
}

@end
