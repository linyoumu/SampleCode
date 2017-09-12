//
//  LinMovieView.m
//  AVPlayerDemo
//
//  Created by Myfly on 17/9/2.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "LinMovieView.h"
#import "UIView+FSNewFrameLayoutView.h"
#import "UIView+Additon.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

#define FontOfSize(size) [UIFont systemFontOfSize:size]
#define LINMovieSetORI [@[@"setO",@"rientation",@":"] componentsJoinedByString:@""]
#define LINMovieTopShadowH 40.f
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

typedef NS_ENUM(NSUInteger, LINMovieViewVideoStatus) {
    LINMovieViewVideoStatusUnDefined,
    LINMovieViewVideoStatusPlaying,
    LINMovieViewVideoStatusPauseing,
};


@interface LinMovieView ()

@property (weak, nonatomic) UIView *movieLayerView;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (assign, nonatomic, getter=isShowingPanel) BOOL showingPanel;
@property (assign, nonatomic) NSInteger controlTimes;
@property (assign, nonatomic) LINMovieViewVideoStatus preVideoStatus;
@property (weak, nonatomic) UIImageView *posterImageView;
@property (weak, nonatomic) UIButton *playButton;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *panelView;
@property (weak, nonatomic) UIProgressView *loadedProgressView;
@property (weak, nonatomic) UISlider *timeSlider;
@property (strong, nonatomic) id hasBindTimeSlider;
@property (assign, nonatomic) BOOL dragingTimeSlider;
@property (weak, nonatomic) UILabel *currentTimeLabel;
@property (weak, nonatomic) UILabel *totalTimeLabel;
@property (weak, nonatomic) UIButton *controlButton;

@property (weak, nonatomic) UIButton *backButton;

@property (assign, nonatomic) BOOL playVideoFailed;

@end

@implementation LinMovieView

#pragma mark - Init Methods
- (void)dealloc
{
    [self clear];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBasic];
        [self setupSubviews];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.movieLayerView.bounds;
    
    CGFloat timeSliderX = self.currentTimeLabel.right + 9.f;
    CGFloat timeSliderW = (self.totalTimeLabel.left - 9.f) - timeSliderX;
    CGFloat timeSliderH = 20.f;
    CGFloat timeSliderY = self.panelView.height - (LINMovieTopShadowH + timeSliderH) * .5f;
    self.timeSlider.frame = CGRectMake(timeSliderX, timeSliderY, timeSliderW, timeSliderH);
    
    CGFloat loadedProgressX = self.timeSlider.origin.x + 2.f;
    CGFloat loadedProgressW = self.timeSlider.width - 4.f;
    CGFloat loadedProgressH = 5.f;
    CGFloat loadedProgressY = self.timeSlider.centerY - loadedProgressH * .5f + 1.5f;
    self.loadedProgressView.frame = CGRectMake(loadedProgressX, loadedProgressY, loadedProgressW, loadedProgressH);
    
    CGFloat titleX = self.backButton.right + 10;
    CGFloat titleH = self.titleLabel.font.lineHeight;
    CGFloat titleY = self.backButton.centerY - titleH * .5f;
    CGFloat titleW = self.width - titleX * 2.f;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
}

#pragma mark - Setup Basic
- (void)setupBasic
{
    self.backgroundColor = [UIColor blackColor];
    self.userInteractionEnabled = YES;
}

#pragma mark - Setup & Layout Subviews
- (void)setupSubviews
{
    [self setupMovieView];
    [self setupPanelView];
    [self setupPoster];
    self.panelView.hidden = YES;
}

- (void)setupMovieView
{
    self.movieLayerView = [self fsf_newViewWithColor:[UIColor blackColor]];
    self.movieLayerView.frame = self.bounds;
    self.movieLayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.movieLayerView.userInteractionEnabled = YES;
    [self.movieLayerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPanel:)]];
}

- (void)setupPanelView
{
    self.panelView = [self fsf_newViewWithColor:[UIColor clearColor]];
    self.panelView.frame = self.bounds;
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.panelView.userInteractionEnabled = YES;
    [self.panelView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePanel:)]];
    
    UIView *shadowView = [self.panelView fsf_newViewWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.7f]];
    
    self.controlButton = [self.panelView fsf_newButtonWithImage:@"life_movie_pause" selectedImage:@"life_movie_play"];
    [self.controlButton addTarget:self action:@selector(onControlButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UISlider *timeSlider = [UISlider new];
    [timeSlider setThumbImage:[UIImage imageNamed:@"life_movie_timeSlider_thumb"] forState:UIControlStateNormal];
    timeSlider.minimumTrackTintColor = [UIColor whiteColor];
    timeSlider.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    [timeSlider addTarget:self action:@selector(onTimeSlider:)
         forControlEvents:UIControlEventValueChanged];
    [self.panelView addSubview:timeSlider];
    self.timeSlider = timeSlider;
    
    UIProgressView *loadedProgressView = [UIProgressView new];
    loadedProgressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    loadedProgressView.trackTintColor = [UIColor clearColor];
    [self.panelView insertSubview:loadedProgressView belowSubview:self.timeSlider];
    self.loadedProgressView = loadedProgressView;
    
    self.currentTimeLabel = [self.panelView fsf_newLabelWithText:@"00:00" Font:FontOfSize(15) color:[UIColor lightGrayColor]];
    self.totalTimeLabel = [self.panelView fsf_newLabelWithText:@"00:00" Font:FontOfSize(15) color:[UIColor lightGrayColor]];
    
    self.fullScreenButton = [self.panelView fsf_newButtonWithImage:@"life_movie_fullScreen" selectedImage:@"life_movie_exitFullScreen"];
    [self.fullScreenButton addTarget:self action:@selector(onFullScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[[UIImage imageNamed:@"life_movieDetail_shadowBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:backButton];
    self.backButton = backButton;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(2, 2, 15, 15);
    [closeBtn setImage:[[UIImage imageNamed:@"life_close_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(onCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.hidden = YES;
    [self.panelView addSubview:closeBtn];
    self.closeButton = closeBtn;
    
    self.titleLabel = [self.panelView fsf_newLabelWithFont:FontOfSize(17) color:[UIColor whiteColor]];
    self.titleLabel.shadowColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    
    // frame
    CGFloat shadowH = LINMovieTopShadowH;
    shadowView.frame = CGRectMake(0, self.panelView.frame.size.height - shadowH, self.panelView.frame.size.width, shadowH);
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    CGFloat controlWH = shadowH;
    CGFloat controlX = 4.f;
    CGFloat controlY = self.frame.size.height - controlWH;
    self.controlButton.frame = CGRectMake(controlX, controlY, controlWH, controlWH);
    self.controlButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
    self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat currentH = shadowH;
    CGFloat currentW = 48.f;
    CGFloat currentX = self.controlButton.frame.origin.x + self.controlButton.frame.size.width + 0.f;
    CGFloat currentY = self.panelView.frame.size.height - currentH;
    self.currentTimeLabel.frame = (CGRect){CGPointMake(currentX, currentY),CGSizeMake(currentW, currentH)};
    self.currentTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    CGFloat fullScreenWH = shadowH;
    CGFloat fullScreenX = self.panelView.frame.size.width - 4.f - fullScreenWH;
    CGFloat fullScreenY = self.panelView.frame.size.height - fullScreenWH;
    self.fullScreenButton.frame = CGRectMake(fullScreenX, fullScreenY, fullScreenWH, fullScreenWH);
    self.fullScreenButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    self.totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat totalTimeH = shadowH;
    CGFloat totalTimeW = currentW;
    CGFloat totalTimeX = self.fullScreenButton.frame.origin.x - 0.f - totalTimeW;
    CGFloat totalTimeY = self.panelView.frame.size.height - totalTimeH;
    self.totalTimeLabel.frame = (CGRect){CGPointMake(totalTimeX, totalTimeY), CGSizeMake(totalTimeW, totalTimeH)};
    self.totalTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    backButton.frame = CGRectMake(0, 0, 44, 44);
    self.backButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    self.backButton.hidden = YES;
    
    self.titleLabel.hidden = YES;
}

- (void)setupPoster
{
    self.posterImageView = [self fsf_newImageViewWithColor:[UIColor blackColor]];
    self.posterImageView.frame = self.bounds;
    self.posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.posterImageView.clipsToBounds = YES;
    self.posterImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.playButton = [self fsf_newButtonWithImage:@"life_videoPlay_file.png"];
    CGFloat playWH = 80.f;
    CGFloat playX = self.width * .5f - playWH * .5f;
    CGFloat playY = self.height * .5f - playWH * .5f;
    self.playButton.frame = CGRectMake(playX, playY, playWH, playWH);
    self.playButton.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16);
    [self.playButton addTarget:self action:@selector(onPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void)setupAVLayer
{
    NSURL *playURL = nil;
//    if (self.urlType == LINMoviewViewURLTypeLocal) {
//        playURL = [NSURL fileURLWithPath:self.videoURL];
//    } else {
//        playURL = [NSURL URLWithString:self.videoURL];
//    }
    playURL = [NSURL URLWithString:@"http://download.3g.joy.cn/video/236/60236937/1451280942752_hd.mp4"];
    AVAsset *asset = [AVAsset assetWithURL:playURL];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.movieLayerView.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.movieLayerView.layer addSublayer:self.playerLayer];
    
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidChangeOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}



#pragma mark - UpdateUI
- (void)updateTimeSlider{
    if (self.hasBindTimeSlider) {
        return;
    }
    __weak __typeof(self) wSelf = self;
    self.hasBindTimeSlider = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(wSelf.player.currentTime);
        wSelf.timeSlider.value = currentTime;
        wSelf.currentTimeLabel.text = [wSelf timeStringWithSeconds:(NSInteger)currentTime];
    }];
}

- (void)updatePanelUI
{
    CGFloat totalTime = self.player.currentItem.duration.value / self.player.currentItem.duration.timescale;
    if (totalTime != self.timeSlider.maximumValue) {
        self.timeSlider.maximumValue = totalTime;
        self.totalTimeLabel.text = [self timeStringWithSeconds:(NSInteger)totalTime];
    }
    
    NSArray *loadedTimeRanges = self.player.currentItem.loadedTimeRanges;
    if (!loadedTimeRanges || ![loadedTimeRanges isKindOfClass:[NSArray class]] || !loadedTimeRanges.count) {
        return;
    }
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval currentDuration = startSeconds + durationSeconds;
    CGFloat bufferProgress = (CGFloat)currentDuration / self.player.currentItem.duration.value * self.player.currentItem.duration.timescale;
    self.loadedProgressView.progress = bufferProgress;
}

- (NSString *)timeStringWithSeconds:(NSInteger)seconds
{
    NSInteger min = seconds / 60;
    NSInteger sec = seconds % 60;
    return [NSString stringWithFormat:@"%.2zd:%.2zd",min,sec];
}

#pragma mark - Observe
// 键值观察
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if (!playerItem) {
        return;
    }
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerStatusReadyToPlay) {
            if(self.preVideoStatus != LINMovieViewVideoStatusPauseing && ([UIApplication sharedApplication].applicationState == UIApplicationStateActive ||  [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)) {
                if (!self.controlButton.selected) {
                    self.controlButton.selected = NO;
                    [self.player play];
                }
            } else {
                [self showPanel:nil];
                self.controlButton.selected = YES;
                [self.player pause];
            }
            self.posterImageView.hidden = YES;
            //[self.indicator stopAnimating];
            [self updateTimeSlider];
        } else {
            NSLog(@"AVPlayerStatusFailed or AVPlayerStatusUnknown");
            self.playVideoFailed = YES;
            [self.player pause];
            [self.player.currentItem removeObserver:self forKeyPath:@"status"];
            [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
            [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        [self updatePanelUI];
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
    }
}

#pragma mark - Notifications
- (void)videoDidPlayToEnd:(NSNotification *)note
{
    if ([note.object isKindOfClass:[AVPlayerItem class]] && note.object == self.player.currentItem) {
        self.videoPlayToEnd = YES;
        //        [self.controlButton setTitle:@"重播" forState:UIControlStateSelected];
        [self showPanel:nil];
        self.controlButton.selected = YES;
        [self.player pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"videoPlayEnd" object:nil];
    }
}

- (void)handleWillResignActiveNotification:(NSNotification *)note
{
    if (self.preVideoStatus != LINMovieViewVideoStatusUnDefined) {
        return;
    }
    if (!self.controlButton.selected) {
        [self showPanel:nil];
        self.controlButton.selected = YES;
        [self.player pause];
        self.preVideoStatus = LINMovieViewVideoStatusPlaying;
    } else {
        self.preVideoStatus = LINMovieViewVideoStatusPauseing;
    }
}

- (void)handleDidBecomeActiveNotification:(NSNotification *)note
{
    switch (self.preVideoStatus) {
        case LINMovieViewVideoStatusPlaying:
        {
            [self hidePanel:nil];
            self.controlButton.selected = NO;
            [self.player play];
            break;
        }
        case LINMovieViewVideoStatusPauseing:
        {
            break;
        }
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.preVideoStatus = LINMovieViewVideoStatusUnDefined;
    });
}

- (void)onDidChangeOrientation:(NSNotification *)note
{
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        //[[UIApplication sharedApplication] setStatusBarHidden:self.normalStatusBarHidden withAnimation:UIStatusBarAnimationNone];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = NO;
        appDelegate.preferRotationOrientation = UIInterfaceOrientationMaskLandscape;
        self.backButton.hidden = YES;
        self.titleLabel.hidden = YES;
        self.fullScreenButton.hidden = NO;
        [UIView animateWithDuration:.25f animations:^{
            self.frame = self.normalFrame;
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(movieViewSwitchToNormal:)]) {
            [self.delegate movieViewSwitchToNormal:self];
        }
    }
}

#pragma mark - 按键的点击事件
- (IBAction)showPanel:(UITapGestureRecognizer *)gesture
{
    if (!self.posterImageView.hidden) {
        return;
    }
    self.panelView.hidden = NO;
    self.showingPanel = YES;
    self.controlTimes++;
    if (self.delegate && [self.delegate respondsToSelector:@selector(movieViewShowPanel:)]) {
        [self.delegate movieViewShowPanel:self];
    }
}

- (IBAction)hidePanel:(UITapGestureRecognizer *)gesture
{
    if (!self.posterImageView.hidden) {
        return;
    }
    if (self.dragingTimeSlider) {
        return;
    }
    self.panelView.hidden = YES;
    self.showingPanel = NO;
    self.controlTimes++;
    if (self.delegate && [self.delegate respondsToSelector:@selector(movieViewHidePanel:)]) {
        [self.delegate movieViewHidePanel:self];
    }
}

- (IBAction)onCloseButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(movieViewSwitchToClose:)]) {
        [self.delegate movieViewSwitchToClose:self];
    }
}

- (IBAction)onPlayButton:(UIButton *)button
{
    [self play];
}

- (IBAction)onTimeSlider:(UISlider *)slider
{
    self.controlTimes++;
    [self.player pause];
    self.dragingTimeSlider = YES;
    if (self.videoPlayToEnd) {
        self.videoPlayToEnd = NO;
    }
    
    CMTime time = CMTimeMakeWithSeconds(slider.value, self.player.currentTime.timescale);
    [self.player seekToTime:time completionHandler:^(BOOL finished) {
        if (finished) {
            self.controlButton.selected = NO;
            [self.player play];
            self.dragingTimeSlider = NO;
            self.showingPanel = NO;
            NSInteger controlTimes = self.controlTimes;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (controlTimes == self.controlTimes) {
                    [self hidePanel:nil];
                }
            });
        }
    }];
    [self triggerPlayClick];
}

- (IBAction)onControlButton:(UIButton *)button
{
    self.controlTimes++;
    self.fullScreenButton.hidden = NO;
    [button setShowsTouchWhenHighlighted:YES];
    if (button.selected) {
        if (self.videoPlayToEnd) {
            self.videoPlayToEnd = NO;
            //            [self.controlButton setTitle:@"播放" forState:UIControlStateSelected];
            self.timeSlider.value = 0.f;
            [self onTimeSlider:self.timeSlider];
        } else {
            self.playing = YES;
            [self.player play];
        }
        self.showingPanel = NO;
        NSInteger controlTimes = self.controlTimes;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (controlTimes == self.controlTimes) {
                [self hidePanel:nil];
            }
        });
        [self triggerPlayClick];
    } else {
        self.playing = NO;
        [self.player pause];
    }
    
    button.selected = !button.selected;
}

- (IBAction)onBackButton:(UIButton *)button
{
    switch (self.showType) {
        case LINMoviewViewShowTypeLandscapeRight:
        {
            __weak __typeof(self) wSelf = self;
            [self setNormalScreenWithAnimations:^{
                wSelf.alpha = 0.f;
            } completion:^{
                [wSelf removeFromSuperview];
            }];
            break;
        }
        default:
        {
            [self onFullScreenButton:self.fullScreenButton];
            break;
        }
    }
}

- (IBAction)onFullScreenButton:(UIButton *)button
{
    if (self.showType == LINMoviewViewShowTypeLandscapeRight) {
        [self onBackButton:self.backButton];
        return;
    }
    if (button.selected) { // 退出全屏
        if (self.delegate && [self.delegate respondsToSelector:@selector(movieViewSwitchToNormal:)]) {
            [self.delegate movieViewSwitchToNormal:self];
        }
        button.selected = !button.selected;
        [self setNormalScreenWithAnimations:nil completion:nil];
    } else { // 进入全屏
        if (self.delegate && [self.delegate respondsToSelector:@selector(movieViewSwitchToFullScreen:)]) {
            [self.delegate movieViewSwitchToFullScreen:self];
        }
        button.selected = !button.selected;
        [self setFullScreen];
    }
}

#pragma mark - pubicMethod
// 开始播放
- (void)play{
    self.playing = YES;
    self.playButton.hidden = YES;
    [self setupAVLayer];
}

//清除资源
- (void)clear{
    if (self.player) {
        [self.player pause];
        self.player.rate = 0;
        if (!self.playVideoFailed) {
            [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
            [self.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
            [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
            [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
        }
        [self.player replaceCurrentItemWithPlayerItem:nil];
        if (self.hasBindTimeSlider) {
            [self.player removeTimeObserver:self.hasBindTimeSlider];
        }
        self.player = nil;
    }
    self.playerLayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 暂停播放
- (void)pause{
    [self showPanel:nil];
    self.playing = NO;
    self.controlButton.selected = YES;
    [self.player pause];
    [self.player cancelPendingPrerolls];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resume{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidChangeOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - privateMethod
//恢复原来大小
- (void)setNormalScreenWithAnimations:(void (^)())animations completion:(void (^)())completion
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
    appDelegate.preferRotationOrientation = UIInterfaceOrientationMaskLandscape;
    self.backButton.hidden = YES;
    self.titleLabel.hidden = YES;
    [self setIRToPWithString:LINMovieSetORI target:[UIDevice currentDevice] val:UIInterfaceOrientationPortrait];
    [UIView animateWithDuration:.25f animations:^{
        self.frame = self.normalFrame;
        !animations ? : animations();
    } completion:^(BOOL finished) {
        !completion ? : completion();
    }];
}

// 设置全屏播放
- (void)setFullScreen{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.normalFrame = self.frame;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
    appDelegate.preferRotationOrientation = UIInterfaceOrientationMaskLandscape;
    self.backButton.hidden = NO;
    self.titleLabel.hidden = NO;
    [UIView animateWithDuration:.25f animations:^{
        self.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
    } completion:^(BOOL finished) {
    }];
    [self setIRToPWithString:LINMovieSetORI target:[UIDevice currentDevice] val:UIInterfaceOrientationLandscapeRight];
}

//切换横竖屏
- (void)setIRToPWithString:(NSString *)selectorString target:(id)target val:(int)value
{
    SEL selector = NSSelectorFromString(selectorString);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:target];
    int val = value;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

// 进入全屏播放
- (void)showFullScreenToView:(UIView *)view withInitView:(UIView *)initView{
    UIView *superView = view;
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    }
    CGRect initFrame = CGRectZero;
    if (initView && initView.superview) {
        initFrame = [initView.superview convertRect:initView.frame toView:superView];
    }
    self.frame = initFrame;
    self.showType = LINMoviewViewShowTypeLandscapeRight;
    [superView addSubview:self];
    [self setFullScreen];
    [self play];
}

- (void)showFullScreen{
    [self showFullScreenToView:nil withInitView:nil];
}

- (void)triggerPlayClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(movieViewDidTriggerPlay:)]) {
        [self.delegate movieViewDidTriggerPlay:self];
    }
}


@end
