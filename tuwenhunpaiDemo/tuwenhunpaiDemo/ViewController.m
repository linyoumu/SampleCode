//
//  ViewController.m
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/14.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, strong) LinHybridTextView *contentTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GlobalMainBackgroundGrayColor;
    
    [self.view addSubview:self.contentTextView];
    
    [self.contentTextView resetGifImageViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (LinHybridTextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[LinHybridTextView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
        _contentTextView.placeholder = @"描述内容";
        _contentTextView.placeholderColor = [UIColor lightGrayColor];
        _contentTextView.textColor = [UIColor blackColor];
        _contentTextView.delegate = (id<UITextViewDelegate>)self;
        _contentTextView.font = [UIFont systemFontOfSize:16.0f];
        _contentTextView.layer.cornerRadius = 4.0f;
        _contentTextView.layer.masksToBounds = YES;
        _contentTextView.backgroundColor = [UIColor colorWithHex:0xf4f4f4];
        _contentTextView.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    return _contentTextView;
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.contentTextView resetGifImageViews];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger charCount = [self.contentTextView.text contentCharCountOfString];
    if (charCount > 20000) {
        self.contentTextView.text = [self.contentTextView.text subStirngToMaxIndex:10000];
    }
    NSLog(@"%@",textView.text);
    
    [self.contentTextView resetGifImageViews];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = [self.contentTextView.text stringByAppendingString:text];
    BOOL result = YES;
    NSInteger charCount = [content contentCharCountOfString];
    NSLog(@"------%ld",charCount);
    if (charCount > 20000) {
        result = NO;
    }
    else {
        result = YES;
    }
    return result;
}


@end
