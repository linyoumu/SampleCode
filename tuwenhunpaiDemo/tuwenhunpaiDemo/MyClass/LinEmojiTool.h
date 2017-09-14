//
//  LinEmojiTool.h
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/14.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LinEmojiTool : NSObject

#pragma mark - Emoji表情库
//// 处理点击表情面板按钮后的文字
//+ (void)handleTextView:(UITextView *)textView withNewString:(NSString *)newString isDelete:(BOOL)isDelete;
//
//// 将表情文字转化为能发送的文字
//+ (NSString *)rawStringFromEmojiString:(NSString *)originalString;
//
//// 将文字转化为表情文字
//+ (NSString *)emojiStringFromRawString:(NSString *)rawString;

// 约定好的rawStrings，用来匹配
+ (NSArray *)emojiRawStrings;

//+ (BOOL)faceCountOverFlowWithText:(NSString *)text afterEdit:(BOOL)afterEdit;

#pragma mark - SKG自定义表情库
// SKG自定义表情库
+ (NSDictionary *)faceDictionary;
// 对应字符串
+ (NSDictionary *)faceNameDictionary;

// 通过faceName寻找对应的image
+ (UIImage *)imageForFaceName:(NSString *)faceName;

// 将文字转化为表情文字（同时处理emoji与face）
//+ (NSAttributedString *)faceStringFromRawString:(NSString *)rawString font:(UIFont *)font;

@end
