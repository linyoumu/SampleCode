//
//  LinFaceViewContainer.m
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/16.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#define SKGFaceViewContainerBarHeight 40.f
#define SKGFaceViewContainerFaceViewHeight 200.f

#import "LinFaceViewContainer.h"

@interface LinFaceViewContainer () <LinFaceViewDelegateForContainer, DXFaceViewDelegateForContainer>
@property (weak, nonatomic) UIView *containerBar;
@property (weak, nonatomic) LinFaceViewContainerButton *emojiButton;
@property (weak, nonatomic) LinFaceViewContainerButton *faceButton;
@property (weak, nonatomic) UIButton *deleteButton;
@property (weak, nonatomic) UIView *separateView;
@property (weak, nonatomic) UIPageControl *pageControl;
@end

@implementation LinFaceViewContainer

+ (instancetype)faceView
{
    LinFaceViewContainer *faceViewContainer = [LinFaceViewContainer new];
    faceViewContainer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SKGFaceViewContainerFaceViewHeight + SKGFaceViewContainerBarHeight);
    return faceViewContainer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupPageControl];
    }
    return self;
}

- (void)setupSubviews
{
    self.backgroundColor = GlobalMainBackgroundGrayColor;
    
    self.containerBar = [self fsf_newViewWithColor:[UIColor whiteColor]];
    LinFaceViewContainerButton *emojiButton = [LinFaceViewContainerButton buttonWithImageName:@"life_emojiPanel"];
    [self.containerBar addSubview:emojiButton];
    self.emojiButton = emojiButton;
    LinFaceViewContainerButton *faceButton = [LinFaceViewContainerButton buttonWithImageName:@"life_facePanel"];
    [self.containerBar addSubview:faceButton];
    self.faceButton = faceButton;
    self.deleteButton = [self.containerBar fsf_newButtonWithImage:@"FaceViewDeleteIcon"];
    self.separateView = [self.containerBar fsf_newViewWithColor:GlobalBarLineGrayColor];
    UIView *verticalSeparateView = [self.containerBar fsf_newViewWithColor:GlobalBarLineGrayColor];
    
    self.containerBar.frame = CGRectMake(0, SKGFaceViewContainerFaceViewHeight, ScreenWidth, SKGFaceViewContainerBarHeight);
    self.faceButton.frame = CGRectMake(0, 0, 50, SKGFaceViewContainerBarHeight);
    self.emojiButton.frame = CGRectMake(CGRectGetMaxX(self.faceButton.frame), 0, 50, SKGFaceViewContainerBarHeight);
    self.deleteButton.frame = CGRectMake(ScreenWidth - 50, 0, 50, SKGFaceViewContainerBarHeight);
    self.separateView.frame = CGRectMake(0, 0, ScreenWidth, GlobalSeperateLineWH);
    verticalSeparateView.frame = CGRectMake(CGRectGetMinX(self.deleteButton.frame) - GlobalSeperateLineWH, 0, GlobalSeperateLineWH, SKGFaceViewContainerBarHeight);
    
    [self.emojiButton addTarget:self action:@selector(onEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.faceButton addTarget:self action:@selector(onFaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.emojiView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    self.emojiView.delegateForContainer = self;
    [self addSubview:self.emojiView];
    
    self.faceView = [[LinFaceView alloc] initWithFrame:self.emojiView.frame];
    self.faceView.delegateForContainer = self;
    [self addSubview:self.faceView];
    
}

- (void)setupPageControl
{
    UIPageControl *pageControl = [UIPageControl new];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    [self setOnlyFace:self.onlyFace];
}

- (void)setOnlyFace:(BOOL)onlyFace
{
    _onlyFace = onlyFace;
    
    if (_onlyFace) {
        self.emojiButton.selected = NO;
        self.faceButton.selected = YES;
        self.emojiView.hidden = YES;
        self.faceView.hidden = NO;
        self.emojiButton.hidden = YES;
        self.faceButton.hidden = YES;
        [self configPageControlWithTotalPage:self.faceView.totalPage currentPage:0];
    } else {
        self.emojiButton.selected = NO;
        self.faceButton.selected = YES;
        self.emojiView.hidden = YES;
        self.faceView.hidden = NO;
        self.emojiButton.hidden = NO;
        self.faceButton.hidden = NO;
        [self configPageControlWithTotalPage:self.faceView.totalPage currentPage:0];
    }
}

- (void)setOnlyEmoji:(BOOL)onlyEmoji
{
    _onlyEmoji = onlyEmoji;
    if (_onlyEmoji) {
        self.emojiButton.selected = YES;
        self.faceButton.selected = NO;
        self.emojiView.hidden = NO;
        self.faceView.hidden = YES;
        self.emojiButton.hidden = YES;
        self.faceButton.hidden = YES;
        [self configPageControlWithTotalPage:self.faceView.totalPage currentPage:0];
    } else {
        self.emojiButton.selected = NO;
        self.faceButton.selected = YES;
        self.emojiView.hidden = YES;
        self.faceView.hidden = NO;
        self.emojiButton.hidden = NO;
        self.faceButton.hidden = NO;
        [self configPageControlWithTotalPage:self.faceView.totalPage currentPage:0];
    }
    
}

- (void)onEmojiButton:(UIButton *)sender
{
    self.emojiButton.selected = YES;
    self.faceButton.selected = NO;
    self.emojiView.hidden = NO;
    self.faceView.hidden = YES;
    [self.emojiView scroll];
}

- (void)onFaceButton:(UIButton *)sender
{
    self.emojiButton.selected = NO;
    self.faceButton.selected = YES;
    self.emojiView.hidden = YES;
    self.faceView.hidden = NO;
    [self.faceView scroll];
}

- (void)onDeleteButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceViewContainerDidClickDeleteButton:)]) {
        [self.delegate faceViewContainerDidClickDeleteButton:self];
    }
}

- (void)configPageControlWithTotalPage:(NSUInteger)totalPage currentPage:(NSUInteger)currentPage
{
    self.pageControl.numberOfPages = totalPage;
    self.pageControl.currentPage = currentPage;
    self.pageControl.hidden = NO;
}

- (void)facialViewDidScrollToPage:(NSUInteger)page
{
    [self configPageControlWithTotalPage:self.emojiView.totalPage currentPage:page];
}

- (void)faceViewDidScrollToPage:(NSUInteger)page
{
    [self configPageControlWithTotalPage:self.faceView.totalPage currentPage:page];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pageControl.frame = CGRectMake(0, SKGFaceViewContainerFaceViewHeight - 30, ScreenWidth, 30);
}

@end

@implementation LinFaceViewContainerButton


+ (instancetype)buttonWithImageName:(NSString *)imageName
{
    LinFaceViewContainerButton *button = [LinFaceViewContainerButton new];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImage *bgImage = [UIImage imageWithColor:GlobalMainLineGrayColor];
        [self setBackgroundImage:bgImage forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
