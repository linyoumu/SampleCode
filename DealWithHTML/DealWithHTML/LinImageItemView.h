//
//  LinImageItemView.h
//  DealWithHTML
//
//  Created by Myfly on 17/9/18.
//  Copyright © 2017年 Myfly. All rights reserved.
//
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@protocol LinImageItemViewDelegate <NSObject>
- (void)disMissImageBrowseController;
@end

@interface LinImageItemView : UIView

/**
 *  添加的图片
 */
@property(nonatomic, strong) UIImageView *imageView;
//2.
/**
 *  代理
 */
@property(nonatomic, assign) id<LinImageItemViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withPhotoUrl:(NSString *)photoUrl;

-(id)initWithFrame:(CGRect)frame withPhotoImage:(UIImage *)image;

@property (nonatomic,strong) NSString * photoUrl;

@end
