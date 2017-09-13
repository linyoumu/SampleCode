//
//  DownloadHttpRequest.h
//  DownLoadDemo
//
//  Created by Myfly on 17/9/13.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadHttpRequest;

@protocol HttpRequestDelegate <NSObject>

- (void)requestFailed:(DownloadHttpRequest *)request;
- (void)requestStarted:(DownloadHttpRequest *)request;
- (void)request:(DownloadHttpRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)request:(DownloadHttpRequest *)request didReceiveBytes:(long long)bytes;
- (void)requestFinished:(DownloadHttpRequest *)request;
@optional
- (void)request:(DownloadHttpRequest *)request willRedirectToURL:(NSURL *)newURL;

@end

@interface DownloadHttpRequest : NSObject

@property (weak, nonatomic  ) id<HttpRequestDelegate> delegate;
@property (strong, nonatomic) NSURL                  *url;
@property (strong, nonatomic) NSURL                  *originalURL;
@property (strong, nonatomic) NSDictionary           *userInfo;
@property (assign, nonatomic) NSInteger              tag;
@property (strong, nonatomic) NSString               *downloadDestinationPath;
@property (strong, nonatomic) NSString               *temporaryFileDownloadPath;
@property (strong,readonly,nonatomic) NSError *error;

- (instancetype)initWithURL:(NSURL*)url;
- (void)startAsynchronous;
- (BOOL)isFinished;
- (BOOL)isExecuting;
- (void)cancel;


@end
