//
//  LinImageBrowseController.h
//  DealWithHTML
//
//  Created by Myfly on 17/9/18.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinImageBrowseController : UIViewController

/**
 *  接收图片数组，数组类型可以是url数组，image数组
 */
@property(nonatomic, strong) NSArray *imgArr;

/**
 *  model数组
 */
@property(nonatomic, strong) NSArray *modelArr;
/**
 *  数组中的哪个key
 */
@property(nonatomic,copy) NSString * key;

/**
 *  显示scrollView
 */
@property(nonatomic, strong) UIScrollView *scrollView;
/**
 *  显示下标
 */
@property(nonatomic, strong) UILabel *sliderLabel;
/**
 *  接收当前图片的序号,默认的是0
 */
@property(nonatomic, assign) NSInteger currentIndex;

@property (assign, nonatomic) BOOL isOpenUrl;

@property (weak, readonly, nonatomic) UIViewController *rootViewController;
@property (assign, nonatomic) BOOL lastStatusBarHidden;
- (void)presentFromRootViewControllerWithController:(UIViewController *)supViewController;

@end
