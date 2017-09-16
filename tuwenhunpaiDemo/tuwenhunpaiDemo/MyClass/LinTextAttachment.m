//
//  LinTextAttachment.m
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/14.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "LinTextAttachment.h"


@implementation LinTextAttachment


//设置大小
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake( 0, 0,_imageSize.width, _imageSize.height);
}

+ (NSAttributedString *)textAttachmentStringWithImage:(UIImage *)image item:(int)item
{
    CGSize imageSize = CGSizeMake(ScreenWidth - 20, (ScreenWidth - 20) * image.size.height / image.size.width);
    LinTextAttachment *imageTextAttachment = [LinTextAttachment new];
    imageTextAttachment.image = image;
    imageTextAttachment.imageTag = [NSString stringWithFormat:@"[img%d]",item];
    imageTextAttachment.imageSize = imageSize;
    imageTextAttachment.isGif = NO;
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:imageTextAttachment];
    return textAttachmentString;
}

+ (NSAttributedString *)gifImageTextAttachmentStringWithGifIamgeName:(NSString *)gifIamgeName
{
    CGSize imageSize = CGSizeMake(60, 60);
    LinTextAttachment *imageTextAttachment = [LinTextAttachment new];
    imageTextAttachment.isGif = YES;
    imageTextAttachment.gifName = gifIamgeName;
    imageTextAttachment.imageSize = imageSize;
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:imageTextAttachment];
    return textAttachmentString;
}

+ (NSMutableAttributedString *)swapAttributeString:(NSString *)content gifNames:(NSArray *) gifNames
{
    NSMutableAttributedString *lastAttributedString = nil;
    if (content) {
        lastAttributedString = [[NSMutableAttributedString alloc] initWithString:content];
        for (NSString *gifName in gifNames) {
            NSAttributedString *textAttachmentString = [LinTextAttachment gifImageTextAttachmentStringWithGifIamgeName:gifName];
            NSString *changeContent = [lastAttributedString string];
            NSRange range = [changeContent rangeOfString:gifName];
            [lastAttributedString replaceCharactersInRange:range withAttributedString:textAttachmentString];
        }
        [lastAttributedString addAttributes:[NSAttributedString attributes] range:NSMakeRange(0, lastAttributedString.length)];
    }
    return lastAttributedString;
}

@end
