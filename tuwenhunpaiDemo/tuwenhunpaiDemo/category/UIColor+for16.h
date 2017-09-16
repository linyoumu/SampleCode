//
//  UIColor+for16.h
//  bank—my
//
//  Created by luoliang on 15/3/31.
//  Copyright (c) 2015年 luoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (for16)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;

@end
