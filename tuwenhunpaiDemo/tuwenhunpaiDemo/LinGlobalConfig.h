//
//  LinGlobalConfig.h
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/16.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#ifndef LinGlobalConfig_h
#define LinGlobalConfig_h

// 默认分割线高度/宽度
#define GlobalSeperateLineWH 1.0f/[UIScreen mainScreen].scale
// 所有内容区分隔线
#define GlobalMainLineGrayColor [UIColor colorWithHex:0xe6e6e6]
// 黑色字体
#define GlobalTextBlackColor  [UIColor colorWithHex:0x333333]

#define GlobalMainBackgroundGrayColor [UIColor colorWithHex:0xf5f8fa]

#define GlobalBarLineGrayColor [UIColor colorWithHex:0xe8e8e8]

#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]

#define FontOfSize(size) [UIFont systemFontOfSize:size]
#define BoldFontOfSize(size) [UIFont boldSystemFontOfSize:size]

#define TextViewFont [UIFont systemFontOfSize:15]
#define PlaceholerTextColor [UIColor lightGrayColor]


#endif /* LinGlobalConfig_h */
