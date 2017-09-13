//
//  DownloadDelegate.h
//  DownLoadDemo
//
//  Created by Myfly on 17/9/13.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadHttpRequest.h"

@protocol DownloadDelegate <NSObject>

@optional

- (void)startDownload:(DownloadHttpRequest *)request;
- (void)updateCellProgress:(DownloadHttpRequest *)request;
- (void)finishedDownload:(DownloadHttpRequest *)request;
- (void)allowNextRequest;//处理一个窗口内连续下载多个文件且重复下载的情况

@end
