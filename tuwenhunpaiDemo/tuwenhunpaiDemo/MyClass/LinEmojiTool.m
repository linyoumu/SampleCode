//
//  LinEmojiTool.m
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/14.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "LinEmojiTool.h"

@implementation LinEmojiTool

// 约定好的rawString
+ (NSArray *)emojiRawStrings
{
    static NSArray *_emojiRawStrings;
    if (!_emojiRawStrings) {
        _emojiRawStrings = @[@"[):]",
                             @"[:D]",
                             @"[;)]",
                             @"[:-o]",
                             @"[:p]",
                             @"[(H)]",
                             @"[:@]",
                             @"[:s]",
                             @"[:$]",
                             @"[:(]",
                             @"[:'(]",
                             @"[:|]",
                             @"[(a)]",
                             @"[8o|]",
                             @"[8-|]",
                             @"[+o(]",
                             @"[+-o)]",
                             @"[|-)]",
                             @"[*-)]",
                             @"[:-#]",
                             @"[:-*]",
                             @"[^o)]",
                             @"[8-)]",
                             @"[(|)]",
                             @"[(u)]",
                             @"[(S)]",
                             @"[(*)]",
                             @"[(#)]",
                             @"[(R)]",
                             @"[({)]",
                             @"[(})]",
                             @"[(k)]",
                             @"[(F)]",
                             @"[(W)]",
                             @"[(D)]"];
    }
    return _emojiRawStrings;
}

+ (NSDictionary *)faceDictionary
{
    static NSDictionary *_faceDictionary;
    if (!_faceDictionary) {
        _faceDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LifeEmoji" ofType:@"plist"]];
    }
    return _faceDictionary;
}

+ (NSDictionary *)faceNameDictionary
{
    static NSDictionary *_faceNameDictionary;
    if (!_faceNameDictionary) {
        _faceNameDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LifeEmojiName" ofType:@"plist"]];
    }
    return _faceNameDictionary;
}

+ (UIImage *)imageForFaceName:(NSString *)faceName
{
    return [UIImage imageNamed:[[self faceDictionary] objectForKey:faceName]];
}

@end
