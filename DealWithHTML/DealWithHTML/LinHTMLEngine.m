//
//  LinHTMLEngine.m
//  HTMLTest
//
//  Created by Myfly on 17/9/18.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "LinHTMLEngine.h"
#import "NSString+ImageURLTransform.h"
#import "SDWebImageManager.h"

#define PostDetailPlaceholderBackgroundPic @"life_grayBackgroundPlaceholder_file.png"
#define PostDetailPlaceholderPic @"life_placeholder_600_600_file.png"
#define PostDetailVideoPlayPic @"life_videoPlay_file.png"

#define IOSVersion   [[[UIDevice currentDevice] systemVersion] floatValue]

static const CGFloat PostDetailImgMargin = 16.f;

@implementation LinHTMLEngine


// convert normal string to HTML
+ (NSString *)convertToHTML:(NSString *)string
{
    if (![string rangeOfString:@"</"].length) {
        return [NSString stringWithFormat:@"<div style=\"word-wrap:break-word; width:%.fpx;\">%@</div>", [UIScreen mainScreen].bounds.size.width - PostDetailImgMargin, string];
    } else {
        return string;
    }
}

// use regex method to resizeImageSize
+ (NSString *)resizeImageSize:(NSString *)string widthScale:(CGFloat)scale
{
    // match all the Aliyun images to format them
    NSMutableString *resizeString = string.mutableCopy;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"img\\.skg\\.com[^\"]*\"" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regex matchesInString:resizeString options:0 range:NSMakeRange(0, resizeString.length)];
    for (NSTextCheckingResult *result in results.reverseObjectEnumerator) {
        NSString *resultString = [string substringWithRange:result.range];
        if ([resultString.lowercaseString rangeOfString:@"gif"].location != NSNotFound) {
            continue; // 不处理gif
        }
        NSString *newString = [NSString stringWithFormat:@"@%.fw_1l_70Q\"", ([UIScreen mainScreen].bounds.size.width - PostDetailImgMargin) * scale];
        [resizeString replaceCharactersInRange:NSMakeRange(result.range.location + result.range.length - 1, 1) withString:newString];
    }
    //    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //    NSString *domain = [userDefault objectForKey:@"cacheDomain"];
    //替换域名
    //    NSString *newImgStr = [resizeString stringByReplacingOccurrencesOfString:@"img.skg.com" withString:domain];
    return resizeString;
}

// setupPlaceholderImage
+ (NSString *)setupPlaceholderImage:(NSString *)string forImagesArray:(NSMutableArray *)imagesArray shitImages:(NSMutableArray *)shitImagesArray videoImages:(NSMutableDictionary *)videoImagesDict emojiCount:(NSInteger *)emojiCount
{
    if (!string || !string.length) {
        return nil;
    }
    [imagesArray removeAllObjects];
    [shitImagesArray removeAllObjects];
    NSMutableString *transformedString = string.mutableCopy;
    // match all images regex
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]+>" options:NSRegularExpressionCaseInsensitive error:nil];
    // match src segment regex
    NSRegularExpression *srcRegex = [NSRegularExpression regularExpressionWithPattern:@"src=\"[^\"]\\S+\"" options:NSRegularExpressionCaseInsensitive error:nil];
    // match img-height segment regex
    NSRegularExpression *imgHRegex = [NSRegularExpression regularExpressionWithPattern:@"img-height=\"[^\"]\\S+\"" options:NSRegularExpressionCaseInsensitive error:nil];
    // match img-width segment regex
    NSRegularExpression *imgWRegex = [NSRegularExpression regularExpressionWithPattern:@"img-width=\"[^\"]\\S+\"" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRegularExpression *videoRegex = [NSRegularExpression regularExpressionWithPattern:@"videolink=\"[^\"]\\S+\"" options:NSRegularExpressionCaseInsensitive error:nil];
    
    // placeholderImagePath
    NSString *placeholderImagePath = [[NSBundle mainBundle] pathForResource:PostDetailPlaceholderPic ofType:nil];
    NSString *placeholderBgImagePath = [[NSBundle mainBundle] pathForResource:PostDetailPlaceholderBackgroundPic ofType:nil];
    NSString *videoPlayImagePath = [[NSBundle mainBundle] pathForResource:PostDetailVideoPlayPic ofType:nil];
    NSMutableString *placeholderBgString = @"\n<div class=\"bgBoxBefore\" style=\"background-image:url({placeholderpic});\"".mutableCopy;
    BOOL videoLinkExist = [string rangeOfString:@"videolink"].length > 0;
    if (videoLinkExist) {
        placeholderBgString = @"\n<div class=\"bgBoxBeforeForVideo\" style=\"background-image:url({placeholderpic});\"".mutableCopy;
    }
    [placeholderBgString replaceOccurrencesOfString:@"{placeholderpic}" withString:placeholderImagePath options:NSCaseInsensitiveSearch range:NSMakeRange(0, placeholderBgString.length)];
    NSString *shitImagePlaceholderBgString = [placeholderBgString stringByReplacingOccurrencesOfString:@"120px 120px" withString:@"90px 90px"];
    // placeholderString to replace src="xxx"
    NSString *placeholderString = [NSString stringWithFormat:@"src=\"%@\" ",placeholderBgImagePath];
    NSString *videoPlayString = @"<img class=\"playBtn\" src=\"{videoplaypic}\" onclick=\"onVideoPlayBtn('{transurl}')\" /> ";
    if (IOSVersion >= 8.0 && IOSVersion < 9.0) {
        UIImage *videoPlayButtonImage = [UIImage imageNamed:PostDetailVideoPlayPic];
        NSString *imgB64 = [UIImagePNGRepresentation(videoPlayButtonImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        videoPlayImagePath = [NSString stringWithFormat:@"data:image/jpg;base64,%@", imgB64];
    }
    videoPlayString = [videoPlayString stringByReplacingOccurrencesOfString:@"{videoplaypic}" withString:videoPlayImagePath];
    // find all the images
    NSArray *results = [regex matchesInString:transformedString options:0 range:NSMakeRange(0, transformedString.length)];
    
    for (NSTextCheckingResult *result in results.reverseObjectEnumerator) {
        NSString *oldString = [transformedString substringWithRange:result.range];
        NSMutableString *newString = @"<img onClick=\"onImageClick(this)\" ".mutableCopy;
        // get imageURL
        NSArray *srcResults = [srcRegex matchesInString:oldString options:0 range:NSMakeRange(0, oldString.length)];
        NSArray *imgHResults = [imgHRegex matchesInString:oldString options:0 range:NSMakeRange(0, oldString.length)];
        NSArray *imgWResults = [imgWRegex matchesInString:oldString options:0 range:NSMakeRange(0, oldString.length)];
        if (!srcResults.count) {
            continue;
        }
        NSArray *videoResults = [videoRegex matchesInString:oldString options:0 range:NSMakeRange(0, oldString.length)];
        
        NSTextCheckingResult *srcResult = srcResults[0];
        // 20160414 by FasaMo check is emoji
        BOOL isEmoji = ([oldString.lowercaseString rangeOfString:@"expression=\"yes\""].location != NSNotFound);
        BOOL hasVideo = videoResults.count > 0;
        /**< 1.0 */
        // add imageURL to imagesArray
        NSString *originalImageURL = [[oldString substringWithRange:srcResult.range] substringWithRange:NSMakeRange(5, srcResult.range.length - 6)];
        if (isEmoji) {
            originalImageURL = [[originalImageURL componentsSeparatedByString:@"@"] firstObject];
            //            [emojisArray addObject:originalImageURL];
            (*emojiCount)++;
        }
        [imagesArray addObject:originalImageURL];
        if (hasVideo) {
            NSTextCheckingResult *videoResult = videoResults[0];
            NSString *videoLink = [[oldString substringWithRange:videoResult.range] substringWithRange:NSMakeRange(11, videoResult.range.length - 12)];
            [videoImagesDict setObject:videoLink forKey:originalImageURL];
        }
        NSString *originalImageURLCacheKey = [originalImageURL transformURLToImageKey];
        
        if (imgHResults.count && imgWResults.count) {
            NSTextCheckingResult *imgHResult = imgHResults[0];
            NSString *imgHString = [[oldString substringWithRange:imgHResult.range] substringWithRange:NSMakeRange(12, imgHResult.range.length - 13)];
            NSTextCheckingResult *imgWResult = imgWResults[0];
            NSString *imgWString = [[oldString substringWithRange:imgWResult.range] substringWithRange:NSMakeRange(11, imgWResult.range.length - 12)];
            if (!imgHString.integerValue || !imgWString.integerValue) {
                continue;
            }
            
            // replace the src segment
            [newString appendString:placeholderString];
            
            /**< 2.0 */
            // setup imgW and imgH
            CGFloat imgW = MIN(ceilf([UIScreen mainScreen].bounds.size.width - PostDetailImgMargin), imgWString.integerValue);
            CGFloat imgH = ceilf(imgW * imgHString.integerValue / imgWString.integerValue);
            NSString *imageSizeString = [NSString stringWithFormat:@" width=\"%.0f\" height=\"%.0f\" ", imgW, imgH];
            if (isEmoji) {
                imageSizeString = [NSString stringWithFormat:@" width=\"%@\" height=\"%@\" ", imgWString, imgHString];
            }
            [newString appendString:imageSizeString];
            
            /**< 3.0 */
            // setup id for every image
            [newString appendString:[NSString stringWithFormat:@" id=\"%@\" sssrc=\"%@\" ",originalImageURLCacheKey, originalImageURLCacheKey]];
            [newString appendString:@" />"];
            if (hasVideo) {
                NSString *realVideoPlayString = [videoPlayString stringByReplacingOccurrencesOfString:@"{transurl}" withString:originalImageURLCacheKey];
                [newString appendString:realVideoPlayString];
            }
            /**< 3.5 */
            NSString *setPlaceholderNewString;
            if (isEmoji) { // make emoji normal
                setPlaceholderNewString = newString;
            } else { // make normal image center
                setPlaceholderNewString = [NSString stringWithFormat:@"%@ id=\"div%@\"> %@ %@",placeholderBgString, originalImageURLCacheKey, newString, @"</div>\n"];
            }
            
            /**< 4.0 */
            // replace the originalString
            [transformedString replaceCharactersInRange:result.range withString:setPlaceholderNewString];
        } else {
            /**< 1.0 */
            // add imageURL to shitImagesArray
            [shitImagesArray addObject:originalImageURL];
            
            // replace the src segment
            [newString appendString:placeholderString];
            
            /**< 3.0 */
            // setup id for every image
            [newString appendString:[NSString stringWithFormat:@" id=\"%@\" sssrc=\"%@\" ",originalImageURLCacheKey, originalImageURLCacheKey]];
            [newString appendString:@" />"];
            if (hasVideo) {
                NSString *realVideoPlayString = [videoPlayString stringByReplacingOccurrencesOfString:@"{transurl}" withString:originalImageURLCacheKey];
                [newString appendString:realVideoPlayString];
            }
            /**< 3.5 */
            NSString *setPlaceholderNewString;
            if (isEmoji) { // make emoji normal
                setPlaceholderNewString = newString;
            } else { // make normal image center
                setPlaceholderNewString = [NSString stringWithFormat:@"%@ id=\"div%@\"> %@ %@",shitImagePlaceholderBgString, originalImageURLCacheKey, newString, @"</div>\n"];
            }
            
            /**< 4.0 */
            // replace the originalString
            [transformedString replaceCharactersInRange:result.range withString:setPlaceholderNewString];
        }
        
    }
    [transformedString replaceOccurrencesOfString:@"style=\"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, transformedString.length)];
    return transformedString;
}

// setup with HTML Template
+ (NSString *)setupWithHTMLTemplate:(NSString *)string
{
    if (!string || !string.length) {
        return nil;
    }
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"SKGPostDetailContentHTML" ofType:@"html"];
    NSMutableString *appHtml = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSRange range = [appHtml rangeOfString:@"<p>mainnews</p>"];
    [appHtml replaceOccurrencesOfString:@"<p>mainnews</p>" withString:string options:NSCaseInsensitiveSearch range:range];
    NSRange playBtnRange = [appHtml rangeOfString:@"{playbtnleftandtop}"];
    NSString *playString = @"left:43%;top:41%;";
    if (IOSVersion >= 9.0) {
        playString = @"left:50%;top:50%;";
    }
    [appHtml replaceOccurrencesOfString:@"{playbtnleftandtop}" withString:playString options:NSCaseInsensitiveSearch range:playBtnRange];
    return appHtml;
}

//// transform URL to an image key: 1. as 'id' in the js; 2. as cacheKey for SDWebImage
//+ (NSString *)transformURLToImageKey:(NSString *)string
//{
//    return [[string stringByReplacingOccurrencesOfString:@"/"withString:@"_"] stringByReplacingOccurrencesOfString:@"http:" withString:@"http"];
//}

// download images
+ (void)downloadImages:(NSArray *)imagesArray shitImages:(NSArray *)shitImagesArray forWebView:(UIView *)webView withShitImageBlock:(void (^)())shitImageBlock
{
    if (!imagesArray.count) {
        return;
    }
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    
    for (NSString *imageName in imagesArray) {
        NSURL *imageUrl = [NSURL URLWithString:imageName];
        if ([imageManager diskImageExistsForURL:imageUrl]) {
            [self setRealImageForName:imageName shitImages:shitImagesArray webView:webView withShitImageBlock:shitImageBlock];
        } else {
            [imageManager downloadImageToDiskOnlyWithURL:imageUrl
                                                 options:SDWebImageRetryFailed
                                                progress:nil
                                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                   if (image && finished) {
                                                       [self setRealImageForName:imageName shitImages:shitImagesArray webView:webView withShitImageBlock:shitImageBlock];
                                                   } else {
                                                       [self setRestartImageForName:imageName webView:webView withShitImageBlock:shitImageBlock];
                                                   }
                                               }];
        }
    }
}

+ (void)setRealImageForName:(NSString *)imageName shitImages:(NSArray *)shitImagesArray webView:(UIView *)webView withShitImageBlock:(void (^)())shitImageBlock
{
    if (!webView.superview || !webView) {
        return;
    }
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    NSString *cacheKey = [imageManager cacheKeyForURL:[NSURL URLWithString:imageName]];
    NSString *imagePaths = [imageManager.imageCache defaultCachePathForKey:cacheKey];
    NSString *message = [NSString stringWithFormat:@"%@-TTTT-%@",[imageName transformURLToImageKey], imagePaths];
    NSString *jsString = [NSString stringWithFormat:@"setRealImage(\"%@\")",message];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (webView && [webView isKindOfClass:[UIWebView class]]) {
            [(UIWebView *)webView stringByEvaluatingJavaScriptFromString:jsString];
            //        if ([shitImagesArray containsObject:imageName]) {
            !shitImageBlock ? : shitImageBlock();
            //        }
        }
#ifdef __IPHONE_8_0
        else if (webView && [webView isKindOfClass:[WKWebView class]]) {
            [(WKWebView *)webView evaluateJavaScript:jsString completionHandler:^(NSString *result, NSError *error) {
                //#warning ShitImagesArray go here?
                !shitImageBlock ? : shitImageBlock();
            }];
        }
#endif
    });
}

// add onclick function to image to restart download
+ (void)setRestartImageForName:(NSString *)imageName webView:(UIView *)webView withShitImageBlock:(void (^)())shitImageBlock
{
    if (!webView.superview || !webView) {
        return;
    }
    NSString *restartDownloadImagePath = [[NSBundle mainBundle] pathForResource:PostDetailPlaceholderPic ofType:nil];
    NSString *message = [NSString stringWithFormat:@"%@-TTTT-%@",[imageName transformURLToImageKey], restartDownloadImagePath];
    NSString *jsString = [NSString stringWithFormat:@"setRestartImage(\"%@\")",message];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (webView && [webView isKindOfClass:[UIWebView class]]) {
            [(UIWebView *)webView stringByEvaluatingJavaScriptFromString:jsString];
            !shitImageBlock ? : shitImageBlock();
        }
#ifdef __IPHONE_8_0
        else if (webView && [webView isKindOfClass:[WKWebView class]]) {
            [(WKWebView *)webView evaluateJavaScript:jsString completionHandler:^(NSString *result, NSError *error) {
                //#warning ShitImagesArray go here?
                !shitImageBlock ? : shitImageBlock();
            }];
        }
#endif
    });
}

// user JS to resizeImageSize
+ (void)adjustImageSizeForWebView:(UIWebView *)webView DEPRECATED_ATTRIBUTE
{
    NSString *jsString = [NSString stringWithFormat:@"var script = document.createElement('script');"
                          "script.type = 'text/javascript';"
                          "script.text = \"function ResizeImages() { "
                          "var myimg,oldwidth;"
                          "var maxwidth = %.f;" // UIWebView中显示的图片宽度
                          "for(i=0;i <document.images.length;i++){"
                          "myimg = document.images[i];"
                          "if(myimg.width > maxwidth){"
                          "oldwidth = myimg.width;"
                          "myimg.width = maxwidth;"
                          "}"
                          "}"
                          "}\";"
                          "document.getElementsByTagName('head')[0].appendChild(script);", [UIScreen mainScreen].bounds.size.width - PostDetailImgMargin];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

@end

#ifdef __IPHONE_8_0
@implementation WKWebView (Fasa)

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javascript {
    __block NSString *res = nil;
    __block BOOL finish = NO;
    [self evaluateJavaScript:javascript completionHandler:^(NSString *result, NSError *error){
        res = result;
        finish = YES;
    }];
    
    CGFloat totalTime = 0.0f;
    while(!finish && totalTime < 4.0f) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        totalTime += 0.1f;
        //        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return res;
}

@end
#endif
