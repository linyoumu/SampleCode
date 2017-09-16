//
//  NSAttributedString+ImageExtension.m
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/14.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "NSAttributedString+ImageExtension.h"

@implementation NSAttributedString (ImageExtension)

- (NSString *)getPlainString
{
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[LinTextAttachment class]]) {
            LinTextAttachment *textAttachment = (LinTextAttachment *)value;
            if (textAttachment.isGif) {
                [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:textAttachment.gifName];
                base += textAttachment.gifName.length - 1;
            }
            else {
                [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:textAttachment.imageTag];
                base += textAttachment.imageTag.length - 1;
            }
        }
    }];

    return plainString;
}

- (NSString *)getPlainContent
{
    NSMutableString *content = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[LinTextAttachment class]]) {
            LinTextAttachment *textAttachment = (LinTextAttachment *)value;
            if (textAttachment.isGif) {

                [content replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:textAttachment.gifName];
                base += textAttachment.gifName.length - 1;
            }
            else {
                [content replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:@""];
                base += [@"" length] - 1;
            }
        }
    }];
    return content;
}

- (NSMutableArray *)getAttachmentImages
{
    __block NSUInteger base = 0;
    __block NSMutableArray *images = [[NSMutableArray alloc] init];
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[LinTextAttachment class]]) {
            LinTextAttachment *textAttachment = (LinTextAttachment *)value;
            if (!textAttachment.isGif) {
                textAttachment.imageTag = [NSString stringWithFormat:@"[img%lu]",(unsigned long)base];
                [images addObject:textAttachment.image];
                base += 1;
            }
        }
    }];
    return images;
}

- (NSMutableArray *)getAttachmentGifImageNames
{
    __block NSUInteger base = 0;
    __block NSMutableArray *imageNames = [[NSMutableArray alloc] init];
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[LinTextAttachment class]]) {
            LinTextAttachment *textAttachment = (LinTextAttachment *)value;
            if (textAttachment.isGif) {
                [imageNames addObject:textAttachment.gifName];
                base += 1;
            }
        }
    }];
    return imageNames;
}

- (NSMutableArray *)getGifImageFramsWithTextView:(LinHybridTextView *)textView
{
    static UITextView *caculateTextView;
    if (!caculateTextView) {
        caculateTextView = [UITextView new];
        caculateTextView.scrollEnabled = NO;
        caculateTextView.editable = NO;
    }
    caculateTextView.bounds = CGRectMake(0, 0, textView.bounds.size.width, CGFLOAT_MAX);
    caculateTextView.attributedText = textView.attributedText;
    __block NSMutableArray *gifFrameArray = [NSMutableArray array];
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id __nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[LinTextAttachment class]]) {
            LinTextAttachment *textAttachment = (LinTextAttachment *)value;
            if (textAttachment.isGif) {
                caculateTextView.selectedRange = range;
                CGRect gifRect = [caculateTextView firstRectForRange:caculateTextView.selectedTextRange];
                gifRect.size = CGSizeMake(60, 60);
                NSDictionary *gifDictionary = [LinEmojiTool faceDictionary];
                NSString *faceNameStr = [gifDictionary objectForKey:textAttachment.gifName];
                [gifFrameArray addObject:@{[faceNameStr stringByDeletingPathExtension] : NSStringFromCGRect(gifRect) }];
            }
        }
    }];
    return gifFrameArray;
}

- (NSString *)getSaveCacheContent {
    NSMutableString *cacheContent = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[LinTextAttachment class]]) {
            LinTextAttachment *textAttachment = (LinTextAttachment *)value;
            if (textAttachment.isGif) {
                [cacheContent replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:textAttachment.gifName];
                base += textAttachment.gifName.length - 1;
            }
            else {
                [cacheContent replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:textAttachment.imageTag];
                base += textAttachment.imageTag.length - 1;
            }
        }
    }];
    return cacheContent;
}

+ (NSDictionary *)attributes
{
    //设置富文本的格式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    //    paragraphStyle.paragraphSpacing = 10;
    return  @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f], NSParagraphStyleAttributeName: paragraphStyle};
}

@end
