//
//  LinFaceViewCell.m
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/16.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "LinFaceViewCell.h"
#import "LinFaceViewCellButton.h"

@interface LinFaceViewCell ()

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSArray *emojis;

@end

@implementation LinFaceViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self baseBuild];
        
        [self setupSubviews];
    }
    return self;
}


#pragma mark - 基本设置
- (void)baseBuild
{
    
}

#pragma mark - SetupSubviews
- (void)setupSubviews
{
    self.buttonArray = [NSMutableArray arrayWithCapacity:kEmojiInputViewCellRowCount * kEmojiInputViewCellColCount];
    
    for (NSUInteger i = 0; i < kEmojiInputViewCellRowCount * kEmojiInputViewCellColCount; i ++) {
        LinFaceViewCellButton *button = [LinFaceViewCellButton new];
        button.tag = i;
        [button addTarget:self action:@selector(clickEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [self.buttonArray addObject:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat horizonMargin = (self.contentView.bounds.size.width - kEmojiInputViewCellColCount * kEmojiInputViewCellButtonSize.width) / (kEmojiInputViewCellColCount + 1);
    CGFloat verticalMargin = (self.contentView.bounds.size.height - kEmojiInputViewCellRowCount * kEmojiInputViewCellButtonSize.height) / (kEmojiInputViewCellRowCount) ;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * __nonnull stop) {
        NSUInteger row = idx / kEmojiInputViewCellColCount;
        NSUInteger column = idx % kEmojiInputViewCellColCount;
        button.frame = CGRectMake(horizonMargin + column * (kEmojiInputViewCellButtonSize.width + horizonMargin), verticalMargin + row * (kEmojiInputViewCellButtonSize.height), kEmojiInputViewCellButtonSize.width, kEmojiInputViewCellButtonSize.height);
    }];
}

#pragma mark - Set Data
- (void)setEmojis:(NSArray *)emojis emojiPlistDic:(NSDictionary *)emojiPlistDic
{
    self.emojis = emojis;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * __nonnull stop) {
        if (idx < emojis.count) {
            button.hidden = NO;
            NSString *emojiName = emojis[idx];
            NSString *emojiImageName = [emojiPlistDic[emojiName] stringByDeletingPathExtension];
            emojiName = [[LinEmojiTool faceNameDictionary] objectForKey:emojiName];
            UIImage *emojiImage = [UIImage imageNamed:emojiImageName];
            [button setImage:emojiImage forState:UIControlStateNormal];
            emojiName = [emojiName stringByReplacingOccurrencesOfString:@"[" withString:@""];
            emojiName = [emojiName stringByReplacingOccurrencesOfString:@"]" withString:@""];
            [button setTitle:emojiName forState:UIControlStateNormal];
        } else {
            button.hidden = YES;
        }
    }];
}

#pragma mark - 表情按钮点击事件
- (void)clickEmoji:(UIButton *)button
{
    NSLog(@"%zd",button.tag);
    if ([self.delegate respondsToSelector:@selector(faceViewCellDidSelectFaceName:)]) {
        NSString *emojiName = self.emojis[button.tag];
        [self.delegate faceViewCellDidSelectFaceName:emojiName];
    }
}

@end
