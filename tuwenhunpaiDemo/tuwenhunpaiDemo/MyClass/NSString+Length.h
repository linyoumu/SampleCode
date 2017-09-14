//
//  NSString+Length.h
//  SKGShop
//
//  Created by singelet on 16/3/19.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Length)

//文本内容字符的个数
- (NSInteger)contentCharCountOfString;

- (NSString *)subStirngToMaxIndex:(NSInteger)maxIndex;

@end
