//
//  NSAttributedString+ImageExtension.h
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/14.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LinHybridTextView;
@interface NSAttributedString (ImageExtension)

- (NSString *)getPlainString;

- (NSMutableArray *)getAttachmentImages;

- (NSMutableArray *)getAttachmentGifImageNames;

- (NSMutableArray *)getGifImageFramsWithTextView:(LinHybridTextView *)textView;

- (NSString *)getSaveCacheContent;

- (NSString *)getPlainContent;

+ (NSDictionary *)attributes;

@end
