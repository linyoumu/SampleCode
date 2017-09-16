//
//  NSMutableAttributedString+TextAttachment.h
//  SKGShop
//
//  Created by singelet on 16/4/12.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (TextAttachment)

+ (NSMutableAttributedString *)imageTextAttachmentWithAttributedString:(NSAttributedString *)attributedString image:(UIImage *)image location:(NSUInteger)location item:(NSInteger)item;


+ (NSMutableAttributedString *)gifImageTextAttachmentWithAttributedString:(NSAttributedString *)attributedString faceName:(NSString *)faceName location:(NSUInteger)location;


+ (NSMutableAttributedString *)stringTextAttachmentWithAttributedString:(NSAttributedString *)attributedString faceString:(NSString *)faceString location:(NSUInteger)location;

@end
