//
//  LinHybridTextView.m
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/14.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#define TextViewFont [UIFont systemFontOfSize:15]
#define PlaceholerTextColor [UIColor lightGrayColor]

#import "LinHybridTextView.h"
#import "NSAttributedString+ImageExtension.h"
#import "LinGifIamgeView.h"
#import "UIImage+GIF.h"


@interface LinHybridTextView ()

@property (weak, nonatomic) UILabel *placeholderLabel;
@property (weak, nonatomic) UIButton *accessoryView;
@property (weak, nonatomic) UIImageView *leftAccessoryView;

@property (nonatomic, strong) NSMutableArray *gifImageViews;

@end

@implementation LinHybridTextView

#pragma mark - Life Cycle Method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gifImageViews = [NSMutableArray array];
        [self baseBuild];
        
        [self buildPlaceholderLabel];
        
        [self buildAccessoryView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self baseBuild];
    
    [self buildPlaceholderLabel];
    
    [self buildAccessoryView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 基本设置
- (void)baseBuild
{
    // 1.设置border
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    
    // 2.设置代理
    //    self.delegate = self;
    
    // 3.设置属性
    self.font = TextViewFont;
    self.alwaysBounceVertical = YES;
    
    // 4.监听textView文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    
    // 5.ScrollsTopTop
    self.scrollsToTop = NO;
}

#pragma mark - 添加placeholderLabel
- (void)buildPlaceholderLabel
{
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.font = self.font;
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.hidden = YES;
    placeholderLabel.numberOfLines = 0;
    [self insertSubview:placeholderLabel atIndex:0];
    self.placeholderLabel = placeholderLabel;
}

#pragma mark - 添加accessoryView
- (void)buildAccessoryView
{
    UIButton *accessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
    accessoryView.hidden = YES;
    accessoryView.enabled = NO;
    accessoryView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self insertSubview:accessoryView atIndex:0];
    self.accessoryView = accessoryView;
    
    UIImageView *leftAccessoryView = [UIImageView new];
    leftAccessoryView.hidden = YES;
    [self insertSubview:leftAccessoryView atIndex:0];
    self.leftAccessoryView = leftAccessoryView;
}

#pragma mark - LayoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat placeholderLabelX = 5;
    CGFloat placeholderLabelY = 7;
    
    if (self.leftAccessoryImage && !self.text.length) {
        [self.leftAccessoryView sizeToFit];
        CGRect frame = self.leftAccessoryView.frame;
        frame.size.width = 16;
        frame.size.height = 16;
        frame.origin.x = 12;
        frame.origin.y = CGRectGetMinY(self.placeholderLabel.frame);
        self.leftAccessoryView.frame = frame;
        self.leftAccessoryView.hidden = NO;
        
        placeholderLabelX = CGRectGetMaxX(self.leftAccessoryView.frame) + 9;
    } else {
        self.leftAccessoryView.hidden = YES;
    }
    
    CGFloat placeholderLabelWidth = self.bounds.size.width - placeholderLabelX * 2;
    CGSize placeholderSize = [self.placeholderLabel sizeThatFits:CGSizeMake(placeholderLabelWidth, CGFLOAT_MAX)];
    
    self.placeholderLabel.frame = CGRectMake(placeholderLabelX, placeholderLabelY, placeholderLabelWidth, placeholderSize.height);
}


- (void)resetGifImageViews
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LinGifIamgeView class]]) {
            [view removeFromSuperview];
        }
    }
    NSMutableArray *gifFrameArray = [self.attributedText getGifImageFramsWithTextView:self];
    [gifFrameArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *gifName = [[obj allKeys] firstObject];
        CGRect gifRect = CGRectFromString([[obj allValues] firstObject]);
        LinGifIamgeView *gifImageView = nil;
        if (idx < self.gifImageViews.count) {
            gifImageView = self.gifImageViews[idx];
        } else {
            gifImageView = [LinGifIamgeView new];
            [self.gifImageViews addObject:gifImageView];
        }
        [self addSubview:gifImageView];
        gifImageView.frame = gifRect;
        gifImageView.image = [UIImage sd_animatedGIFNamed:gifName];
    }];
}


#pragma mark - 设置文字
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
    
    if (placeholder.length > 0 && self.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    self.placeholder = self.placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setAccessoryImage:(UIImage *)accessoryImage
{
    _accessoryImage = accessoryImage;
    
    if (accessoryImage) {
        [self.accessoryView setBackgroundImage:accessoryImage forState:UIControlStateNormal];
        [self.accessoryView sizeToFit];
        CGRect frame = self.accessoryView.frame;
        frame.size.width = 17;
        frame.size.height = 16;
        CGFloat accessoryMargin = 5;
        frame.origin.x = self.frame.size.width - frame.size.width - accessoryMargin;
        frame.origin.y = self.frame.size.height - frame.size.height - accessoryMargin;
        self.accessoryView.frame = frame;
        self.accessoryView.hidden = NO;
    } else {
        self.accessoryView.hidden = YES;
    }
}

- (void)setLeftAccessoryImage:(UIImage *)leftAccessoryImage
{
    _leftAccessoryImage = leftAccessoryImage;
    
    self.leftAccessoryView.image = _leftAccessoryImage;
}

#pragma mark - 通知方法

- (void)dismissKeyBoard
{
    [self resignFirstResponder];
}

- (void)textDidChange{
    BOOL shouldHidden = (self.text.length != 0);
    self.placeholderLabel.hidden = shouldHidden;
    self.leftAccessoryView.hidden = shouldHidden;
    self.accessoryView.hidden = shouldHidden;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}


@end
