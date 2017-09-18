//
//  NSString+ImageURLTransform.m
//  SKGShop
//
//  Created by Fasa Mo on 16/1/7.
//  Copyright © 2016年 LIUX. All rights reserved.
//

#import "NSString+ImageURLTransform.h"

@implementation NSString (ImageURLTransform)
- (NSString *)transformURLToImageKey
{
    return [[self stringByReplacingOccurrencesOfString:@"/"withString:@"_"] stringByReplacingOccurrencesOfString:@"http:" withString:@"http"];
}
@end
