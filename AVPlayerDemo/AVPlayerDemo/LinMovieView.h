//
//  LinMovieView.h
//  AVPlayerDemo
//
//  Created by Myfly on 17/9/2.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#define LINMovieViewHeight (ScreenWidth * 380.f / 640.f)

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LINMoviewViewShowType) {
    LINMoviewViewShowTypeNormal,
    LINMoviewViewShowTypeLandscapeRight
};

typedef NS_ENUM(NSUInteger, LINMoviewViewURLType) {
    LINMoviewViewURLTypeNet,
    LINMoviewViewURLTypeLocal
};

@class LinMovieView;

@protocol LINMovieViewDelegate <NSObject>

@optional

- (void)movieViewSwitchToFullScreen:(LinMovieView *) movieView;
- (void)movieViewSwitchToNormal:(LinMovieView *) movieView;
- (void)movieViewShowPanel:(LinMovieView *) movieView;
- (void)movieViewHidePanel:(LinMovieView *) movieView;
- (void)movieViewDidTriggerPlay:(LinMovieView *) movieView;
- (void)movieViewSwitchToClose:(LinMovieView *) movieView;

@end

@interface LinMovieView : UIView
@property (assign, nonatomic) LINMoviewViewShowType showType;
@property (assign, nonatomic) LINMoviewViewURLType urlType;

@property (assign, nonatomic, getter=isPlaying) BOOL playing;
@property (assign, nonatomic, getter=isVideoPlayToEnd) BOOL videoPlayToEnd;

@property (weak, nonatomic) UIButton *fullScreenButton;
@property (weak, nonatomic) UIButton *closeButton;
@property (assign, nonatomic) CGRect normalFrame;
@property (copy, nonatomic) NSString *videoURL;
@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *title;
@property (weak, nonatomic) id<LINMovieViewDelegate> delegate;


- (void)play;
- (void)clear;
- (void)pause;
- (void)resume;
- (void)setFullScreen;

- (void)showFullScreenToView:(UIView *)view withInitView:(UIView *)initView;

- (void)showFullScreen;

@end
