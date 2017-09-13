//
//  DownloadManager.m
//  DownLoadDemo
//
//  Created by Myfly on 17/9/13.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "DownloadManager.h"

static DownloadManager *sharedDownloadManager = nil;

@interface DownloadManager ()

/** 本地临时文件夹文件的个数 */
@property (nonatomic,assign ) NSInteger      count;
/** 已下载完成的文件列表（文件对象）*/
@property (atomic,strong ) NSMutableArray *finishedlist;
/** 正在下载的文件列表(ASIHttpRequest对象)*/
@property (atomic,strong ) NSMutableArray *downinglist;
/** 未下载完成的临时文件数组（文件对象)*/
@property (atomic,strong ) NSMutableArray *filelist;
/** 下载文件的模型 */
@property (nonatomic,strong ) DownloadFileModel      *fileInfo;

@end

@implementation DownloadManager

#pragma mark - init methods

+ (DownloadManager *)sharedDownloadManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDownloadManager = [[self alloc] init];
    });
    return sharedDownloadManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * max = [userDefaults valueForKey:kMaxRequestCount];
        if (max == nil) {
            [userDefaults setObject:@"3" forKey:kMaxRequestCount];
            max = @"3";
        }
        [userDefaults synchronize];
        _maxCount = [max integerValue];
        _filelist = [[NSMutableArray alloc]init];
        _downinglist = [[NSMutableArray alloc] init];
        _finishedlist = [[NSMutableArray alloc] init];
        _count = 0;
        [self loadFinishedfiles];
        [self loadTempfiles];
    }
    return self;
}

- (void)cleanLastInfo
{
    for (DownloadHttpRequest *request in _downinglist) {
        if([request isExecuting])
            [request cancel];
    }
    [self saveFinishedFile];
    [_downinglist removeAllObjects];
    [_finishedlist removeAllObjects];
    [_filelist removeAllObjects];
}

#pragma mark - 便利方法
- (NSString *)localFilePath:(DownloadVideoModel*)videoModel
{
    NSString *url = videoModel.videoURL;
    NSString *name = [videoModel.videoName stringByAppendingPathExtension:[url lastPathComponent].pathExtension];
    if (!name) {
        name = [url lastPathComponent];
    }
    NSString *filePath = FILE_PATH(name);
    if ([DownloadCommonHelper isExistFile:filePath]) {
        return filePath;
    } else {
        return nil;
    }
}

#pragma mark - 创建一个下载任务

- (void)downloadVideo:(DownloadVideoModel*)videoModel
{
    // 因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
    NSString *url = videoModel.videoURL;
    NSString *name = [videoModel.videoName stringByAppendingPathExtension:[url lastPathComponent].pathExtension]; //拼接后罪名
    
    _fileInfo = [[DownloadFileModel alloc]init];
    if (!name) {
        name = [url lastPathComponent];
    }
    _fileInfo.fileName = name;
    _fileInfo.fileURL = url;
    _fileInfo.videoImageURL = videoModel.videoImageURL;
    
    NSDate *myDate = [NSDate date];
    _fileInfo.time = [DownloadCommonHelper dateToString:myDate];
    _fileInfo.fileType = [name pathExtension];
    
    _fileInfo.fileimage = nil;
    _fileInfo.downloadState = Downloading;
    _fileInfo.error = NO;
    _fileInfo.tempPath = TEMP_PATH(name);
    if ([DownloadCommonHelper isExistFile:FILE_PATH(name)]) { // 已经下载过一次
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该视频已下载完成" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
        return;
    }
    // 存在于临时文件夹里
    NSString *tempfilePath = [TEMP_PATH(name) stringByAppendingString:@".plist"];
    if ([DownloadCommonHelper isExistFile:tempfilePath]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该视频已在您的下载列表中" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
        return;
    }
    
    // 若不存在文件和临时文件，则是新的下载
    [self.filelist addObject:_fileInfo];
    
    [self startLoad];
    if(self.VCdelegate != nil && [self.VCdelegate respondsToSelector:@selector(allowNextRequest)]) {
        [self.VCdelegate allowNextRequest];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已添加至缓存列表，请到我的缓存中查看" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
    return;
    
}

#pragma mark - 下载开始

- (void)beginRequest:(DownloadFileModel *)fileInfo isBeginDown:(BOOL)isBeginDown
{
    for(DownloadHttpRequest *tempRequest in self.downinglist)
    {
        /**
         注意这里判读是否是同一下载的方法，asihttprequest
         **/
        if([[[tempRequest.url absoluteString] lastPathComponent] isEqualToString:[fileInfo.fileURL lastPathComponent]])
        {
            if ([tempRequest isExecuting]&&isBeginDown) {
                return;
            }else if ([tempRequest isExecuting]&&!isBeginDown)
            {
                [tempRequest setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];
                [tempRequest cancel];
                [self.downloadDelegate updateCellProgress:tempRequest];
                return;
            }
        }
    }
    
    [self saveDownloadFile:fileInfo];
    
    // 按照获取的文件名获取临时文件的大小，即已下载的大小
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *fileData = [fileManager contentsAtPath:fileInfo.tempPath];
    NSInteger receivedDataLength = [fileData length];
    fileInfo.fileReceivedSize = [NSString stringWithFormat:@"%zd", receivedDataLength];
    
    NSLog(@"start down:已经下载：%@",fileInfo.fileReceivedSize);
    DownloadHttpRequest *midRequest = [[DownloadHttpRequest alloc]initWithURL: [NSURL URLWithString:fileInfo.fileURL]];
    midRequest.downloadDestinationPath = FILE_PATH(fileInfo.fileName);
    midRequest.temporaryFileDownloadPath = fileInfo.tempPath;
    midRequest.delegate = self;
    [midRequest setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    if (isBeginDown) {
        [midRequest startAsynchronous];
    }
    
    // 如果文件重复下载或暂停、继续，则把队列中的请求删除，重新添加
    BOOL exit = NO;
    for (DownloadHttpRequest *tempRequest in self.downinglist) {
        if([[[tempRequest.url absoluteString] lastPathComponent] isEqualToString:[fileInfo.fileURL lastPathComponent]])
        {
            [self.downinglist replaceObjectAtIndex:[_downinglist indexOfObject:tempRequest] withObject:midRequest];
            exit = YES;
            break;
        }
    }
    
    if (!exit) {
        [self.downinglist addObject:midRequest];
    }
    [self.downloadDelegate updateCellProgress:midRequest];
    
}
#pragma mark - 存储下载信息到一个plist文件

- (void)saveDownloadFile:(DownloadFileModel*)fileinfo
{
    NSData *imagedata = UIImagePNGRepresentation(fileinfo.fileimage);
    NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:fileinfo.fileName,@"filename",
                             fileinfo.fileURL,@"fileurl",
                             fileinfo.time,@"time",
                             fileinfo.fileSize,@"filesize",
                             fileinfo.fileReceivedSize,@"filerecievesize",
                             
                             fileinfo.videoImageURL,@"videoImageURL",
                             imagedata,@"fileimage",
                             nil];
    
    NSString *plistPath = [fileinfo.tempPath stringByAppendingPathExtension:@"plist"];
    if (![filedic writeToFile:plistPath atomically:YES]) {
        NSLog(@"write plist fail");
    }
}

#pragma mark - 自动处理下载状态的算法

/*下载状态的逻辑是这样的：三种状态，下载中，等待下载，停止下载
 
 当超过最大下载数时，继续添加的下载会进入等待状态，当同时下载数少于最大限制时会自动开始下载等待状态的任务。
 可以主动切换下载状态
 所有任务以添加时间排序。
 */

- (void)startLoad
{
    NSInteger num = 0;
    NSInteger max = _maxCount;
    for (DownloadFileModel *file in _filelist) {
        if (!file.error) {
            if (file.downloadState == Downloading) {
                
                if (num>=max) {
                    file.downloadState=WillDownload;
                }else
                    num++;
                
            }
        }
    }
    if (num < max) {
        for (DownloadFileModel *file in _filelist) {
            if (!file.error) {
                if (file.downloadState == WillDownload) {
                    num++;
                    if (num>max) {
                        break;
                    }
                    file.downloadState = Downloading;
                }
            }
        }
        
    }
    for (DownloadFileModel *file in _filelist) {
        if (!file.error) {
            if (file.downloadState == Downloading) {
                [self beginRequest:file isBeginDown:YES];
            }else
                [self beginRequest:file isBeginDown:NO];
        }
    }
    self.count = [_filelist count];
}


#pragma mark - 恢复下载

- (void)resumeRequest:(DownloadHttpRequest *)request
{
    NSInteger max = _maxCount;
    DownloadFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    NSInteger downingcount = 0;
    NSInteger indexmax = -1;
    for (DownloadFileModel *file in _filelist) {
        if (file.downloadState == Downloading) {
            downingcount++;
            if (downingcount==max) {
                indexmax = [_filelist indexOfObject:file];
            }
        }
    } //此时下载中数目是否是最大，并获得最大时的位置Index
    if (downingcount == max) {
        DownloadFileModel *file  = [_filelist objectAtIndex:indexmax];
        if (file.downloadState == Downloading) {
            file.downloadState = WillDownload;
        }
    }//中止一个进程使其进入等待
    
    for (DownloadFileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.downloadState = Downloading;
            file.error = NO;
        }
    }//重新开始此下载
    [self startLoad];
}

#pragma mark 暂停all下载
-(void)stopAllRequest{
    
    [self.downinglist enumerateObjectsUsingBlock:^(DownloadHttpRequest  *request, NSUInteger idx, BOOL * _Nonnull stop) {
        [self stopRequest:request];
    }];
}
#pragma mark - 暂停下载

- (void)stopRequest:(DownloadHttpRequest *)request
{
    NSInteger max = self.maxCount;
    if([request isExecuting]) { [request cancel]; }
    DownloadFileModel *fileInfo =  [request.userInfo objectForKey:@"File"];
    for (DownloadFileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.downloadState = StopDownload;
            break;
        }
    }
    NSInteger downingcount = 0;
    
    for (DownloadFileModel *file in _filelist) {
        if (file.downloadState == Downloading) {
            downingcount++;
        }
    }
    if (downingcount<max) {
        for (DownloadFileModel *file in _filelist) {
            if (file.downloadState == WillDownload){
                file.downloadState = Downloading;
                break;
            }
        }
    }
    
    [self startLoad];
}

#pragma mark - 删除下载

- (void)deleteRequest:(DownloadHttpRequest *)request
{
    for (DownloadHttpRequest *obj in self.downinglist) {
        if ([request.userInfo objectForKey:@"File"] == [obj.userInfo objectForKey:@"File"]) {
            request = obj;
        }
    }
    
    BOOL isexecuting = NO;
    if([request isExecuting]) {
        [request cancel];
        isexecuting = YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    DownloadFileModel *fileInfo = (DownloadFileModel*)[request.userInfo objectForKey:@"File"];
    NSString *path = fileInfo.tempPath;
    
    NSString *configPath = [NSString stringWithFormat:@"%@.plist",path];
    [fileManager removeItemAtPath:path error:&error];
    [fileManager removeItemAtPath:configPath error:&error];
    
    if(!error){ NSLog(@"%@",[error description]);}
    
    NSInteger delindex = -1;
    for (DownloadFileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            delindex = [_filelist indexOfObject:file];
            break;
        }
    }
    if (delindex != NSNotFound)
        [_filelist removeObjectAtIndex:delindex];
    
    [_downinglist removeObject:request];
    
    if (isexecuting) {
        [self startLoad];
    }
    self.count = [_filelist count];
}

#pragma mark - 可能的UI操作接口

- (void)clearAllFinished
{
    [_finishedlist removeAllObjects];
}

- (void)clearAllRquests
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    for (DownloadHttpRequest *request in _downinglist) {
        if([request isExecuting])
            [request cancel];
        DownloadFileModel *fileInfo = (DownloadFileModel*)[request.userInfo objectForKey:@"File"];
        NSString *path = fileInfo.tempPath;;
        NSString *configPath = [NSString stringWithFormat:@"%@.plist",path];
        [fileManager removeItemAtPath:path error:&error];
        [fileManager removeItemAtPath:configPath error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
        
    }
    [_downinglist removeAllObjects];
    [_filelist removeAllObjects];
}

- (void)restartAllRquests
{
    
    for (DownloadHttpRequest *request in _downinglist) {
        if([request isExecuting])
            [request cancel];
    }
    
    [self startLoad];
}

#pragma mark - 从这里获取上次未完成下载的信息
/*
 将本地的未下载完成的临时文件加载到正在下载列表里,但是不接着开始下载
 
 */
- (void)loadTempfiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist = [fileManager contentsOfDirectoryAtPath:TEMP_FOLDER error:&error];
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }
    NSMutableArray *filearr = [[NSMutableArray alloc]init];
    for(NSString *file in filelist) {
        NSString *filetype = [file  pathExtension];
        if([filetype isEqualToString:@"plist"])
            [filearr addObject:[self getTempfile:TEMP_PATH(file)]];
    }
    
    NSArray* arr =  [self sortbyTime:(NSArray *)filearr];
    [_filelist addObjectsFromArray:arr];
    
    [self startLoad];
}

- (DownloadFileModel *)getTempfile:(NSString *)path
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    DownloadFileModel *file = [[DownloadFileModel alloc]init];
    file.fileName = [dic objectForKey:@"filename"];
    file.fileType = [file.fileName pathExtension ];
    file.fileURL = [dic objectForKey:@"fileurl"];
    file.videoImageURL = [dic objectForKey:@"videoImageURL"];
    file.fileSize = [dic objectForKey:@"filesize"];
    file.fileReceivedSize = [dic objectForKey:@"filerecievesize"];
    
    file.tempPath = TEMP_PATH(file.fileName);
    file.time = [dic objectForKey:@"time"];
    file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
    file.downloadState = StopDownload;
    file.error = NO;
    
    NSData *fileData = [[NSFileManager defaultManager ] contentsAtPath:file.tempPath];
    NSInteger receivedDataLength = [fileData length];
    file.fileReceivedSize = [NSString stringWithFormat:@"%zd",receivedDataLength];
    return file;
}

- (NSArray *)sortbyTime:(NSArray *)array
{
    NSArray *sorteArray1 = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        DownloadFileModel *file1 = (DownloadFileModel *)obj1;
        DownloadFileModel *file2 = (DownloadFileModel *)obj2;
        NSDate *date1 = [DownloadCommonHelper makeDate:file1.time];
        NSDate *date2 = [DownloadCommonHelper makeDate:file2.time];
        if ([[date1 earlierDate:date2]isEqualToDate:date2]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[date1 earlierDate:date2]isEqualToDate:date1]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    return sorteArray1;
}

#pragma mark - 已完成的下载任务在这里处理
/*
	将本地已经下载完成的文件加载到已下载列表里
 */
- (void)loadFinishedfiles
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:PLIST_PATH]) {
        NSMutableArray *finishArr = [[NSMutableArray alloc] initWithContentsOfFile:PLIST_PATH];
        for (NSDictionary *dic in finishArr) {
            DownloadFileModel *file = [[DownloadFileModel alloc]init];
            file.fileName = [dic objectForKey:@"filename"];
            file.videoImageURL = [dic objectForKey:@"videoImageURL"];
            file.fileType = [file.fileName pathExtension];
            file.fileSize = [dic objectForKey:@"filesize"];
            file.time = [dic objectForKey:@"time"];
            file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
            [_finishedlist addObject:file];
        }
    }
    
}

- (void)saveFinishedFile
{
    if (_finishedlist == nil) { return; }
    NSMutableArray *finishedinfo = [[NSMutableArray alloc] init];
    
    for (DownloadFileModel *fileinfo in _finishedlist) {
        NSData *imagedata = UIImagePNGRepresentation(fileinfo.fileimage);
        NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys: fileinfo.fileName,@"filename",
                                 fileinfo.time,@"time",
                                 fileinfo.fileSize,@"filesize",
                                 
                                 fileinfo.videoImageURL,@"videoImageURL",
                                 imagedata,@"fileimage", nil];
        [finishedinfo addObject:filedic];
    }
    
    if (![finishedinfo writeToFile:PLIST_PATH atomically:YES]) {
        NSLog(@"write plist fail");
    }
}

- (void)deleteFinishFile:(DownloadFileModel *)selectFile
{
    [_finishedlist removeObject:selectFile];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = FILE_PATH(selectFile.fileName);
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
    [self saveFinishedFile];
}

#pragma mark -- ASIHttpRequest回调委托 --

// 出错了，如果是等待超时，则继续下载
- (void)requestFailed:(DownloadHttpRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
    if (error.code==4) { return; }
    if ([request isExecuting]) { [request cancel]; }
    DownloadFileModel *fileInfo =  [request.userInfo objectForKey:@"File"];
    fileInfo.downloadState = StopDownload;
    fileInfo.error = YES;
    for (DownloadFileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.downloadState = StopDownload;
            file.error = YES;
        }
    }
    [self.downloadDelegate updateCellProgress:request];
}

- (void)requestStarted:(DownloadHttpRequest *)request
{
    NSLog(@"开始了!");
}

- (void)request:(DownloadHttpRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"收到回复了！");
    
    DownloadFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    fileInfo.isFirstReceived = YES;
    
    NSString *len = [responseHeaders objectForKey:@"Content-Length"];
    // 这个信息头，首次收到的为总大小，那么后来续传时收到的大小为肯定小于或等于首次的值，则忽略
    if ([fileInfo.fileSize longLongValue] > [len longLongValue]){ return; }
    
    fileInfo.fileSize = [NSString stringWithFormat:@"%lld", [len longLongValue]];
    [self saveDownloadFile:fileInfo];
}

- (void)request:(DownloadHttpRequest *)request didReceiveBytes:(long long)bytes
{
    DownloadFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    //    NSLog(@"%@,%lld",fileInfo.fileReceivedSize,bytes);
    if (fileInfo.isFirstReceived) {
        fileInfo.isFirstReceived = NO;
        fileInfo.fileReceivedSize = [NSString stringWithFormat:@"%lld",bytes];
    } else if(!fileInfo.isFirstReceived) {
        fileInfo.fileReceivedSize = [NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
    }
    
    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)]) {
        [self.downloadDelegate updateCellProgress:request];
    }
    
}

// 将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
- (void)requestFinished:(DownloadHttpRequest *)request
{
    DownloadFileModel *fileInfo = (DownloadFileModel *)[request.userInfo objectForKey:@"File"];
    [_finishedlist addObject:fileInfo];
    NSString *configPath = [fileInfo.tempPath stringByAppendingString:@".plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:configPath]) //如果存在临时文件的配置文件
    {
        [fileManager removeItemAtPath:configPath error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
    }
    
    [_filelist removeObject:fileInfo];
    [_downinglist removeObject:request];
    [self saveFinishedFile];
    [self startLoad];
    
    if([self.downloadDelegate respondsToSelector:@selector(finishedDownload:)]) {
        [self.downloadDelegate finishedDownload:request];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 确定按钮
    if( buttonIndex == 1 ) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSInteger delindex = -1;
        NSString *path = FILE_PATH(_fileInfo.fileName);
        if([DownloadCommonHelper isExistFile:path]) { //已经下载过一次该文件
            for (DownloadFileModel *info in _finishedlist) {
                if ([info.fileName isEqualToString:_fileInfo.fileName]) {
                    // 删除文件
                    [self deleteFinishFile:info];
                }
            }
        } else { // 如果正在下载中，择重新下载
            for(DownloadHttpRequest *request in self.downinglist)
            {
                DownloadFileModel *ZFFileModel = [request.userInfo objectForKey:@"File"];
                if([ZFFileModel.fileName isEqualToString:_fileInfo.fileName])
                {
                    if ([request isExecuting]) {
                        [request cancel];
                    }
                    delindex = [_downinglist indexOfObject:request];
                    break;
                }
            }
            [_downinglist removeObjectAtIndex:delindex];
            
            for (DownloadFileModel *file in _filelist) {
                if ([file.fileName isEqualToString:_fileInfo.fileName]) {
                    delindex = [_filelist indexOfObject:file];
                    break;
                }
            }
            [_filelist removeObjectAtIndex:delindex];
            // 存在于临时文件夹里
            NSString * tempfilePath = [_fileInfo.tempPath stringByAppendingString:@".plist"];
            if([DownloadCommonHelper isExistFile:tempfilePath])
            {
                if (![fileManager removeItemAtPath:tempfilePath error:&error]) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
                
            }
            if([DownloadCommonHelper isExistFile:_fileInfo.tempPath])
            {
                if (![fileManager removeItemAtPath:_fileInfo.tempPath error:&error]) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
            }
            
        }
        
        self.fileInfo.fileReceivedSize = [DownloadCommonHelper getFileSizeString:@"0"];
        [_filelist addObject:_fileInfo];
        [self startLoad];
    }
    if (self.VCdelegate!=nil && [self.VCdelegate respondsToSelector:@selector(allowNextRequest)]) {
        [self.VCdelegate allowNextRequest];
    }
}

#pragma mark - setter

- (void)setMaxCount:(NSInteger)maxCount
{
    _maxCount = maxCount;
    [[NSUserDefaults standardUserDefaults] setValue:@(maxCount) forKey:kMaxRequestCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[DownloadManager sharedDownloadManager] startLoad];
}

@end
