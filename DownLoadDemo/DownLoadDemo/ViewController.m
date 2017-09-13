//
//  ViewController.m
//  DownLoadDemo
//
//  Created by Myfly on 17/9/13.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "ViewController.h"
#import "DownloadManager.h"
#import "MovieViewController.h"

@interface ViewController ()<DownloadDelegate>

@property (nonatomic, strong) DownloadManager *downloadManage;

@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *downLoadProgress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.downloadManage = [DownloadManager sharedDownloadManager];
    self.downloadManage.downloadDelegate = self;
    self.downloadManage.maxCount = 1;
    
    NSLog(@"%@", NSHomeDirectory());
}

- (IBAction)downLoadAction:(id)sender {
    DownloadVideoModel *videoModel = [[DownloadVideoModel alloc] init];
    videoModel.videoURL = @"http://vid.skg.com/videoTopicVideo/2e8ea762-d478-46b5-b10f-0589bd7e0062.mp4";
    videoModel.videoImageURL = @"http://img.skg.com/videoTopicImg/3c6f8982-ea1d-4a84-aa03-21144b638c46.png";
    videoModel.videoName = @"喷香的瘦身沙拉？晚餐只吃它就够了！";
    
    [self.downloadManage downloadVideo:videoModel];
    
}

- (IBAction)puchVCAction:(id)sender {
    [self.navigationController  pushViewController:[MovieViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DownloadDelegate
// 开始下载
- (void)startDownload:(DownloadHttpRequest *)request
{
    NSLog(@"开始下载!");
}

// 下载中
- (void)updateCellProgress:(DownloadHttpRequest *)request
{
    DownloadFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

// 下载完成
- (void)finishedDownload:(DownloadHttpRequest *)request
{
    NSLog(@"下载完成");
}

// 更新下载进度
- (void)updateCellOnMainThread:(DownloadFileModel *)fileInfo
{
//    NSString *currentSize = [DownloadCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
//    NSString *totalSize = [DownloadCommonHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    self.downLoadProgress.progress = progress;
}
@end
