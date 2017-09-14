//
//  LinHybridTextView.h
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/14.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinHybridTextView : UITextView

@property (copy, nonatomic) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (strong, nonatomic) UIImage *accessoryImage;
@property (strong, nonatomic) UIImage *leftAccessoryImage;

- (void) resetGifImageViews;

@end
