//
//  ViewController.m
//  HTMLTest
//
//  Created by Myfly on 17/9/18.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "LinHTMLEngine.h"
#import "NSString+ImageURLTransform.h"
#import "LinImageBrowseController.h"

static NSString * const SKGPostDetailBrowserimage = @"browserimage";
static NSString * const SKGPostDetailImgslocation = @"imgslocation";
static NSString * const SKGPostDetailRestartdownload = @"restartdownload";
NSString * const SKGPostDetailWebViewUserInteractionEnabledNotification = @"SKGPostDetailWebViewUserInteractionEnabledNotification";

@interface ViewController ()<WKNavigationDelegate, UIScrollViewDelegate, WKScriptMessageHandler>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) WKWebView *wkWebView;

@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *shitImagesArray;

@property (strong, nonatomic) NSMutableDictionary *videoImagesDict;
@property (assign, nonatomic) NSInteger emojiCount;

@property (strong, nonatomic) NSMutableDictionary *imgRects;
@property (strong, nonatomic) NSMutableArray *imgOffsetYs;
@property (assign, nonatomic) CGFloat lastImgOffsetY;

@property (copy, nonatomic) NSString *content;

@property (weak, nonatomic) UIImageView *browserImageView;
@property (assign, nonatomic) BOOL shouldPreventBrowserImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldPreventBrowserImage = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWebViewUserInteraction:) name:SKGPostDetailWebViewUserInteractionEnabledNotification object:nil];
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 15400);
    [self.contentView addSubview:self.wkWebView];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    
    self.content = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
    
    [self loadHTMLContent];
    
}
- (void)handleWebViewUserInteraction:(NSNotification *)note
{
    if ([note.object boolValue]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.shouldPreventBrowserImage = NO;
        });
    } else {
        self.shouldPreventBrowserImage = YES;
    }
}

- (void) loadHTMLContent{
    
    NSString *htmlStr = [self formatContent:self.content withPlaceholder:NO];
    if (htmlStr) {
        NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"webViewContent.html"]];
        [htmlStr writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        [self.wkWebView loadHTMLString:htmlStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    } else {
        [self.wkWebView loadHTMLString:@"" baseURL:nil];
    }
    
}

- (NSString *)formatContent:(NSString *)content withPlaceholder:(BOOL)placeholder
{
    //    if (!content || !content.length) {
    //        return nil;
    //    }
    //    if ([self.bbsTopicView.checkStatus isEqualToString:@"waiting"]) {
    //        NSString *offlineString = @"<html><head><style type=\"text/css\">p{font-size:{fontsize};}</style></head><body><p>&nbsp;&nbsp;&nbsp;该帖子已经下架</p></body></html>";
    //        NSString *fontSize = @"100%";
    //        if (IOSVersion >= 8.0 && IOSVersion < 9.0) {
    //            fontSize = @"300%";
    //        }
    //        offlineString = [offlineString stringByReplacingOccurrencesOfString:@"{fontsize}" withString:fontSize];
    //        return offlineString;
    //    }
    content = [LinHTMLEngine convertToHTML:content];
    content = [LinHTMLEngine resizeImageSize:content widthScale:1.3f];
    NSInteger emojiCount = 0;
    if ([content containsString:@"<a href="]) {
        
    }else{
        content = [LinHTMLEngine setupPlaceholderImage:content forImagesArray:self.imagesArray shitImages:self.shitImagesArray videoImages:self.videoImagesDict emojiCount:&emojiCount];
    }
    content = [LinHTMLEngine setupWithHTMLTemplate:content];
    content = [[NSString alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding]; // 重新编码
    self.emojiCount = emojiCount;
    return content;
}


#pragma mark - WebView Delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self handleWebViewDidFinishLoad];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString = navigationAction.request.URL.absoluteString;
    
    if ([urlString hasPrefix:SKGPostDetailBrowserimage] || [urlString hasPrefix:SKGPostDetailImgslocation] || [urlString hasPrefix:SKGPostDetailRestartdownload]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    // 不处理普通URL跳转
    if ([urlString hasPrefix:@"http://"]) {
        
        //[self goToWebViewControllerWithString:urlString];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }
    if ([urlString rangeOfString:@"skglifeios://"].location != NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString *messageName = message.name;
    if ([messageName isEqualToString:SKGPostDetailBrowserimage]) {
        [self browserImageWithString:message.body];
    } else if ([messageName isEqualToString:SKGPostDetailImgslocation]) {
        [self getImagesLocationsWithString:message.body];
    } else if ([messageName isEqualToString:SKGPostDetailRestartdownload]) {
        [self restartDownloadImageWithString:message.body];
    }
    NSLog(@"123+++++");
}

- (void)handleWebViewDidFinishLoad
{
    [self addJustWebViewFrameForReload:YES];
    if (!self.imagesArray.count) return;
    if (self.imagesArray.count < 4) { // 少于n张
        [self downloadAllImages];
    } else { // 多于n张
        [self downloadMustLoadImages];
    }
}


- (void)addJustWebViewFrameForReload:(BOOL)forReload
{
    UIView *webView;
    CGRect webViewFrame;
    NSInteger height = [[self.wkWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] intValue];
    if (forReload && height == 0) {
        [self.wkWebView loadHTMLString:@"" baseURL:nil];
        [self.imagesArray removeAllObjects];
        [self.shitImagesArray removeAllObjects];
        [self loadHTMLContent];
        return;
    }
    webViewFrame = self.wkWebView.frame;
    webView = self.wkWebView;
    
    
    //    if (webViewFrame.size.height == height && self.view.bounds.size.height >= GlobalViewPadding2) {
    //        return;
    //    }
    /**< 如果是空内容上面的height就是8，当数据为空时候webView会在下面被赋值为8，这里判断如果大于10才赋值，避免在上面return */
    if (height > 10) {
        webViewFrame.size.height = height;
        webView.frame = webViewFrame;
    }
    
    //!_finishLoadBlock ? : _finishLoadBlock(CGRectGetMaxY(webView.frame) + GlobalViewPadding2, _bbsTopicView ? YES : NO);
    
    //    if (!forReload || !_bbsTopicView || self.hasStartedToGetImgsLocations || self.imagesArray.count < SKGPostDetailWebViewMustLoadImageCount) return ;
    //    self.hasStartedToGetImgsLocations = YES;
    
    __block BOOL errorHappened = NO;
    [self.wkWebView evaluateJavaScript:@"getImagesLocation()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        // 失败则全部下载
        if (error) {
            errorHappened = YES;
            [self downloadTheRestImages];
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!errorHappened && (!self.imgOffsetYs || !self.imgOffsetYs.count)) {
            [self downloadTheRestImages];
        }
    });
    
}

- (void)getImagesLocationsWithString:(NSString *)locationString
{
    self.imgRects = @{}.mutableCopy;
    self.imgOffsetYs = @[].mutableCopy;
    NSArray *locations = [locationString componentsSeparatedByString:@"-TTTT-"];
    for (NSString *location in locations) {
        NSArray *contents = [location componentsSeparatedByString:@"&"];
        if (contents.count < 5) {
            continue;
        }
        NSString *imgURL = [contents[0] substringFromIndex:3];
        CGFloat x = [[contents[1] substringFromIndex:2] floatValue];
        NSString *yString = [contents[2] substringFromIndex:2];
        CGFloat y = [yString floatValue];
        CGFloat w = [[contents[3] substringFromIndex:2] floatValue];
        CGFloat h = [[contents[4] substringFromIndex:2] floatValue];
        CGRect imgRect = CGRectMake(x, y, w, h);
        [self.imgRects setObject:NSStringFromCGRect(imgRect) forKey:imgURL];
        [self.imgOffsetYs addObject:yString];
    }
    if (!self.imgOffsetYs.count || self.imgOffsetYs.count != self.imagesArray.count) {
        [self downloadTheRestImages];
    }
}

// browser image
- (void)browserImageWithString:(NSString *)imageString
{
    if (self.shouldPreventBrowserImage) {
        return;
    }
    NSUInteger imageIndex = 0;
    // 传过来的imageString包含了url和frame
    NSArray *contents = [imageString componentsSeparatedByString:@"-TTTT-"];
    if (contents.count < 2) {
        return;
    }
    NSString *realImageString = contents[0];
    // 判断是否videoURL，是则跳转视频页面
    __block NSString *realVideoURL = nil;
    __block BOOL hasVideo = NO;
    [self.videoImagesDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull imageURL, NSString * _Nonnull videoURL, BOOL * _Nonnull stop) {
        NSString *imageKey = [imageURL transformURLToImageKey];
        if ([imageKey isEqualToString:realImageString]) {
            realVideoURL = videoURL;
            hasVideo = YES;
        }
    }];
    
    NSArray *coordinates = [contents[1] componentsSeparatedByString:@"&"];
    if (coordinates.count < 4) {
        return;
    }
    CGFloat x = [[coordinates[0] substringFromIndex:2] floatValue];
    CGFloat y = [[coordinates[1] substringFromIndex:2] floatValue];
    CGFloat w = [[coordinates[2] substringFromIndex:2] floatValue];
    CGFloat h = [[coordinates[3] substringFromIndex:2] floatValue];
    self.browserImageView.frame = CGRectMake(x, y, w, h);
    for (NSString *imageURL in self.imagesArray.reverseObjectEnumerator) {
        NSString *imageKey = [imageURL transformURLToImageKey];
        if ([imageKey isEqualToString:realImageString]) {
            LinImageBrowseController *imageVC = [LinImageBrowseController new];
            imageVC.imgArr = self.imagesArray.reverseObjectEnumerator.allObjects;
            imageVC.currentIndex = imageIndex;
            
            [self presentViewController:imageVC animated:YES completion:nil];
            
            break;
        }
        imageIndex++;
    }
}

// restart download image
- (void)restartDownloadImageWithString:(NSString *)imageString
{
    NSUInteger imageIndex = 0;
    for (NSString *imageURL in self.imagesArray.reverseObjectEnumerator) {
        NSString *imageKey = [imageURL transformURLToImageKey];
        if ([imageKey isEqualToString:imageString]) {
            NSLog(@"restart--%zd--%@",imageIndex, imageURL);
            break;
        }
        imageIndex++;
    }
}


- (void)downloadImages:(NSArray *)imageNames
{
    if (!imageNames.count) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [LinHTMLEngine downloadImages:imageNames shitImages:self.shitImagesArray forWebView:self.wkWebView withShitImageBlock:^{
            // 每下载一张shitImage，重新刷新webView，使其拿到正确的高度
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addJustWebViewFrameForReload:NO];
            });
        }];
    });
}

- (void)downloadAllImages
{
    [self downloadImages:self.imagesArray.reverseObjectEnumerator.allObjects];
}

- (void)downloadMustLoadImages
{
    NSMutableArray *mustLoadImages = [NSMutableArray array];
    for (NSUInteger i = 0; i < 4; i++) {
        [mustLoadImages addObject:self.imagesArray.reverseObjectEnumerator.allObjects[i]];
    }
    [self downloadImages:mustLoadImages];
}


- (void)downloadTheRestImages
{
    NSMutableArray *restImages = [NSMutableArray array];
    for (NSUInteger i = 4 ; i < self.imagesArray.count; i++) {
        [restImages addObject:self.imagesArray.reverseObjectEnumerator.allObjects[i]];
    }
    [self downloadImages:restImages];
}

#pragma mark - Lazy Init
- (NSMutableArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (NSMutableArray *)shitImagesArray
{
    if (!_shitImagesArray) {
        _shitImagesArray = [NSMutableArray array];
    }
    return _shitImagesArray;
}

- (NSMutableDictionary *)videoImagesDict
{
    if (!_videoImagesDict) {
        _videoImagesDict = [NSMutableDictionary dictionary];
    }
    return _videoImagesDict;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
    }
    return _contentView;
}

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.preferences.minimumFontSize = 10;
        config.userContentController = [WKUserContentController new];
        NSArray *configNames = @[SKGPostDetailBrowserimage, SKGPostDetailImgslocation, SKGPostDetailRestartdownload];
        for (NSString *configName in configNames) {
            [config.userContentController addScriptMessageHandler:self name:configName];
        }
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.opaque = NO;
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.bounces = NO;
        _wkWebView.scrollView.scrollsToTop = NO;
        _wkWebView.scrollView.scrollEnabled = NO;
        _wkWebView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    }
    return _wkWebView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
