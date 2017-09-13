//
//  DownloadManager.h
//  DownLoadDemo
//
//  Created by Myfly on 17/9/13.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadCommonHelper.h"
#import "DownloadDelegate.h"
#import "DownloadFileModel.h"
#import "DownloadHttpRequest.h"
#import "DownloadVideoModel.h"

#define kMaxRequestCount  @"kMaxRequestCount"

@interface DownloadManager : NSObject<HttpRequestDelegate>

/** 获得下载事件的vc，用在比如多选图片后批量下载的情况，这时需配合 allowNextRequest 协议方法使用 */
@property (nonatomic, weak  ) id<DownloadDelegate> VCdelegate;
/** 下载列表delegate */
@property (nonatomic, weak  ) id<DownloadDelegate> downloadDelegate;
/** 设置最大的并发下载个数 */
@property (nonatomic, assign) NSInteger              maxCount;
/** 已下载完成的文件列表（文件对象） */
@property (atomic, strong, readonly) NSMutableArray *finishedlist;
/** 正在下载的文件列表(ASIHttpRequest对象) */
@property (atomic, strong, readonly) NSMutableArray *downinglist;
/** 未下载完成的临时文件数组（文件对象) */
@property (atomic, strong, readonly) NSMutableArray *filelist;
/** 下载文件的模型 */
@property (nonatomic, strong, readonly) DownloadFileModel      *fileInfo;

/** 单例 */
+ (DownloadManager *)sharedDownloadManager;
/**暂停所有的请求*/
-(void)stopAllRequest;
/** 清除所有正在下载的请求 */
- (void)clearAllRquests;
/** 清除所有下载完的文件 */
- (void)clearAllFinished;
/** 恢复下载 */
- (void)resumeRequest:(DownloadHttpRequest *)request;
/** 删除这个下载请求 */
- (void)deleteRequest:(DownloadHttpRequest *)request;
/** 停止这个下载请求 */
- (void)stopRequest:(DownloadHttpRequest *)request;
/** 保存下载完成的文件信息到plist */
- (void)saveFinishedFile;
/** 删除某一个下载完成的文件 */
- (void)deleteFinishFile:(DownloadFileModel *)selectFile;
/** 下载视频时候调用 */
- (void)downloadVideo:(DownloadVideoModel*)videoModel;
/** 开始任务 */
- (void)startLoad;
/** 重新开始任务 */
- (void)restartAllRquests;
/** 返回本地文件路径 */
- (NSString *)localFilePath:(DownloadVideoModel*)videoModel;

@end
