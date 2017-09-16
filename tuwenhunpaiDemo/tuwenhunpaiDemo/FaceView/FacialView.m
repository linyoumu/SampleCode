/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "FacialView.h"
#import "Emoji.h"

#define EmojiMaxRow 3
#define EmojiMaxCol 7

@interface FacialView () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@end

@implementation FacialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        [self loadFacialView];
    }
    return self;
}

- (void)loadFacialView
{
    _faces = [Emoji allEmoji];
    
    NSUInteger i;
    NSUInteger pages = _faces.count / (EmojiMaxCol * EmojiMaxRow);
    for (i = 0 ; i < pages; i++) {
        [self loadFacialView:i size:CGSizeMake(30, 30)];
    };
    if (_faces.count % (EmojiMaxCol * EmojiMaxRow)) {
        [self loadFacialView:i size:CGSizeMake(30, 30)];
        self.totalPage = i + 1;
    } else {
        self.totalPage = i;
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.totalPage, 0);
}

//给faces设置位置
-(void)loadFacialView:(int)page size:(CGSize)size
{
    CGFloat itemWidth = self.frame.size.width / EmojiMaxCol;
    CGFloat itemHeight = self.frame.size.height / EmojiMaxRow - 10.f;
    
//    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [deleteButton setBackgroundColor:[UIColor clearColor]];
//    [deleteButton setFrame:CGRectMake((maxCol - 1) * itemWidth, (maxRow - 1) * itemHeight, itemWidth, itemHeight)];
//    [deleteButton setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
//    deleteButton.tag = 10000;
//    [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:deleteButton];
    
//    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
//    [sendButton setFrame:CGRectMake((maxCol - 2) * itemWidth - 10, (maxRow - 1) * itemHeight + 5, itemWidth + 10, itemHeight - 10)];
//    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
//    [sendButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
//    [self addSubview:sendButton];
    
    for (int row = 0; row < EmojiMaxRow; row++) {
        for (int col = 0; col < EmojiMaxCol; col++) {
            int index = row * EmojiMaxCol + col + page * EmojiMaxCol * EmojiMaxRow;
            if (index < [_faces count]) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setFrame:CGRectMake(col * itemWidth + page * self.frame.size.width, row * itemHeight, itemWidth, itemHeight)];
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:30.0]];
                [button setTitle: [_faces objectAtIndex:index] forState:UIControlStateNormal];
                button.tag = index;
                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollView addSubview:button];
            }
            else{
                break;
            }
        }
    }
}


-(void)selected:(UIButton*)bt
{
    if (bt.tag == 10000 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        NSString *str = [_faces objectAtIndex:bt.tag];
        if (_delegate) {
            [_delegate selectedFacialView:str];
        }
    }
}

- (void)sendAction:(id)sender
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

#pragma mark - For PageControl
- (IBAction)scroll
{
    [self scrollViewDidScroll:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate) {
        NSUInteger page = (NSUInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.totalPage;
        [self.delegate facialViewDidScrollToPage:page];
    }
}

@end
