//
//  NSString+Length.m
//  SKGShop
//
//  Created by singelet on 16/3/19.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "NSString+Length.h"

@implementation NSString (Length)

//文本内容字符的个数
- (NSInteger)contentCharCountOfString
{
    NSInteger charCount = 0;
    if (self.length == 0)
    {
        return 0;
    }
    for (int i = 0; i < self.length; i++)
    {
        unichar c = [self characterAtIndex:i];
        
        if (c >=0x4E00 && c <=0x9FA5) {
            charCount = charCount + 2 ;//汉字
        }
        else {
            charCount = charCount + 1;
        }
    }
    return charCount;
}

- (NSString *)subStirngToMaxIndex:(NSInteger)maxIndex
{
    NSString *subString = @"";
    NSInteger charCount = 0;
    NSInteger toIndex = 0;
    if (self.length == 0)
    {
        return 0;
    }
    for (int i = 0; i < self.length; i++)
    {
        unichar c = [self characterAtIndex:i];
        
        if (c >=0x4E00 && c <=0x9FA5) {
            charCount = charCount + 2 ;//汉字
        }
        else {
            charCount = charCount + 1;
        }
        if (charCount == maxIndex) {
            toIndex = i + 1;
            break;
        }
        else if (charCount > maxIndex) {
            toIndex = i;
            break;
        }
    }
    
    subString = [self substringToIndex:toIndex];
    return subString;
}

@end
