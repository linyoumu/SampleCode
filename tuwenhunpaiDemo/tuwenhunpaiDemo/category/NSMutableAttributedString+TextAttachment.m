//
//  NSMutableAttributedString+TextAttachment.m
//  SKGShop
//
//  Created by singelet on 16/4/12.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "NSMutableAttributedString+TextAttachment.h"


@implementation NSMutableAttributedString (TextAttachment)

+ (NSMutableAttributedString *)imageTextAttachmentWithAttributedString:(NSAttributedString *)attributedString image:(UIImage *)image location:(NSUInteger)location item:(NSInteger)item
{
//    UIImage *compressImage = [UIImage compressImage:image toMaxFileSize:0.2]; //压缩图片s
    UIImage *compressImage = image;
    
    NSMutableAttributedString *mutableattributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    CGSize originalImageSize = compressImage.size;
    CGSize imageSize = originalImageSize;
    if (originalImageSize.width >= ScreenWidth - 20) {
        imageSize = CGSizeMake(ScreenWidth - 20, (ScreenWidth - 20) * compressImage.size.height / compressImage.size.width);
    }
    UIImage *scaleImage = [UIImage scaleImage:compressImage withSize:imageSize]; //缩放图片
    NSAttributedString *textAttachmentString = [LinTextAttachment textAttachmentStringWithImage:scaleImage item:item];
    NSAttributedString *oneNewline = [[NSAttributedString alloc] initWithString:@"\n" attributes:nil];
    NSAttributedString *twoNewline = [[NSAttributedString alloc] initWithString:@"\n\n" attributes:nil];
    [mutableattributedString insertAttributedString:oneNewline atIndex:location];
    [mutableattributedString insertAttributedString:textAttachmentString atIndex:location + 1];
    [mutableattributedString insertAttributedString:twoNewline atIndex:location + 2];
    
    [mutableattributedString removeAttribute:NSFontAttributeName range:NSMakeRange(0, mutableattributedString.length)];
    [mutableattributedString removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, mutableattributedString.length)];
    [mutableattributedString addAttributes:[NSAttributedString attributes] range:NSMakeRange(0, mutableattributedString.length)];
    return mutableattributedString;
}

+ (NSMutableAttributedString *)gifImageTextAttachmentWithAttributedString:(NSAttributedString *)attributedString faceName:(NSString *)faceName location:(NSUInteger)location
{
    NSMutableAttributedString *mutableattributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    NSAttributedString *textAttachmentString = [LinTextAttachment gifImageTextAttachmentStringWithGifIamgeName:faceName];
    NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@" " attributes:nil];
    [mutableattributedString insertAttributedString:spaceString atIndex:location];
    [mutableattributedString insertAttributedString:textAttachmentString atIndex:location + 1];
    [mutableattributedString insertAttributedString:spaceString atIndex:location + 2];
    [mutableattributedString addAttributes:[NSAttributedString attributes] range:NSMakeRange(0, mutableattributedString.length)];
    
    [mutableattributedString removeAttribute:NSFontAttributeName range:NSMakeRange(0, mutableattributedString.length)];
    [mutableattributedString removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, mutableattributedString.length)];
    [mutableattributedString addAttributes:[NSAttributedString attributes] range:NSMakeRange(0, mutableattributedString.length)];
    return mutableattributedString;
}

+ (NSMutableAttributedString *)stringTextAttachmentWithAttributedString:(NSAttributedString *)attributedString faceString:(NSString *)faceString location:(NSUInteger)location
{
    NSMutableAttributedString *mutableattributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    NSAttributedString *appendString = [[NSAttributedString alloc] initWithString:faceString attributes:[NSAttributedString attributes]];
    [mutableattributedString insertAttributedString:appendString atIndex:location];
    return mutableattributedString;
}

@end
