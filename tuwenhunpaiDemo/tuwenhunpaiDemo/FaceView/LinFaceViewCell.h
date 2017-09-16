//
//  LinFaceViewCell.h
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/16.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#define kEmojiInputViewCellRowCount   2
#define kEmojiInputViewCellColCount   4
#define kEmojiInputViewCellButtonSize CGSizeMake(60, 80)

#import <UIKit/UIKit.h>

@protocol LinFaceViewCellDelegate <NSObject>

- (void)faceViewCellDidSelectFaceName:(NSString *)faceName;
- (void)faceViewCellDidSelectRemoveString;

@end

@interface LinFaceViewCell : UICollectionViewCell

- (void)setEmojis:(NSArray *)emojis emojiPlistDic:(NSDictionary *)emojiPlistDic;

@property (weak, nonatomic) id<LinFaceViewCellDelegate> delegate;

@end
