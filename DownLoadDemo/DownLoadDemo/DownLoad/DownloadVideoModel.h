//
//  DownloadVideoModel.h
//  DownLoadDemo
//
//  Created by Myfly on 17/9/13.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadVideoModel : NSObject

@property(copy,nonatomic)NSString *videoURL; //视频地址
@property(copy,nonatomic)NSString *videoImageURL;//视频封面
@property(copy,nonatomic)NSString *videoName;//视频名字

@end
