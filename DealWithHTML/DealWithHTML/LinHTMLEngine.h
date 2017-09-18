//
//  LinHTMLEngine.h
//  HTMLTest
//
//  Created by Myfly on 17/9/18.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#define IOSVersion   [[[UIDevice currentDevice] systemVersion] floatValue]
@interface LinHTMLEngine : NSObject

// convert normal string to HTML
+ (NSString *)convertToHTML:(NSString *)string;
// use regex method to resizeImageSize
+ (NSString *)resizeImageSize:(NSString *)string widthScale:(CGFloat)scale;
// setupPlaceholderImage
+ (NSString *)setupPlaceholderImage:(NSString *)string forImagesArray:(NSMutableArray *)imagesArray shitImages:(NSMutableArray *)shitImagesArray videoImages:(NSMutableDictionary *)videoImagesDict emojiCount:(NSInteger *)emojiCount;
// setup with HTML Template
+ (NSString *)setupWithHTMLTemplate:(NSString *)string;

// download images
+ (void)downloadImages:(NSArray *)imagesArray shitImages:(NSArray *)shitImagesArray forWebView:(UIView *)webView withShitImageBlock:(void (^)())shitImageBlock;

/**
 @deprecated This method has been deprecated. Use -setValue:forHTTPHeaderField: instead.
 */
// user JS to resizeImageSize
+ (void)adjustImageSizeForWebView:(UIWebView *)webView DEPRECATED_ATTRIBUTE;

@end

#ifdef __IPHONE_8_0
@interface WKWebView (Fasa)
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javascript;
@end
#endif

