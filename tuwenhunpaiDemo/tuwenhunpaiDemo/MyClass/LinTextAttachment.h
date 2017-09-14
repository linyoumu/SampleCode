//
//  LinTextAttachment.h
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/14.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinTextAttachment : NSTextAttachment

@property (nonatomic, strong) NSString *imageTag;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) NSString *gifName;
@property (nonatomic, assign) BOOL isGif;

+ (NSAttributedString *)textAttachmentStringWithImage:(UIImage *)image item:(int)item;

+ (NSAttributedString *)gifImageTextAttachmentStringWithGifIamgeName:(NSString *)gifIamgeName;

+ (NSMutableAttributedString *)swapAttributeString:(NSString *)content gifNames:(NSArray *) gifNames;

@end
