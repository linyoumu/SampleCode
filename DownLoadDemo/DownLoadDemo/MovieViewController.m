//
//  MovieViewController.m
//  DownLoadDemo
//
//  Created by Myfly on 17/9/13.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "MovieViewController.h"
#import "DownloadManager.h"
#import "LinMovieView.h"

@interface MovieViewController ()
@property (nonatomic, strong) LinMovieView *movieView;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    LinMovieView *movieView = [[LinMovieView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    
    [self.view addSubview:movieView];
    
    self.movieView = movieView;
    
    [self configMovieView];
}

- (void)configMovieView
{
    DownloadVideoModel *videoModel = [[DownloadVideoModel alloc] init];
    videoModel.videoURL = @"http://vid.skg.com/videoTopicVideo/2e8ea762-d478-46b5-b10f-0589bd7e0062.mp4";
    videoModel.videoImageURL = @"http://img.skg.com/videoTopicImg/3c6f8982-ea1d-4a84-aa03-21144b638c46.png";
    videoModel.videoName = @"喷香的瘦身沙拉？晚餐只吃它就够了！";
    NSString *finalVideoURL = [[DownloadManager sharedDownloadManager] localFilePath:videoModel];
    LINMoviewViewURLType urlType = LINMoviewViewURLTypeLocal;
    if (!finalVideoURL) {
        finalVideoURL = @"http://vid.skg.com/videoTopicVideo/2e8ea762-d478-46b5-b10f-0589bd7e0062.mp4";
        urlType = LINMoviewViewURLTypeNet;
    }
    self.movieView.urlType = urlType;
    self.movieView.videoURL = finalVideoURL;
    self.movieView.imageURL = videoModel.videoImageURL;
    self.movieView.title = videoModel.videoName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
