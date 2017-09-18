//
//  NSString+ImageURLTransform.h
//  SKGShop
//
//  Created by Fasa Mo on 16/1/7.
//  Copyright © 2016年 LIUX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ImageURLTransform)

// transform URL to an image key: 1. as 'id' in the js; 2. as cacheKey for SDWebImage
- (NSString *)transformURLToImageKey;
@end
