//
//  MBProgressHUD+Add.h
//
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

/**
 *  成功与失败HUD
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view delay:(NSTimeInterval)delay;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

- (void)showError:(NSString *)error toView:(UIView *)view;
- (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  加载中HUD，Loading+文字，需要手动Hide -- view参数有值，HUD直接加到View，导航栏可点击；view传nil，加到Window，拦阻用户其他所有操作；有蒙版
 */
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

#pragma mark - For SKG
/**
 *  短暂提示，纯文字HUD -- 无蒙版
 *
 */
+ (MBProgressHUD *)showTipMessag:(NSString *)message toView:(UIView *)view; // 默认0.7s
+ (MBProgressHUD *)showTipMessag:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)delay;

/**
 *  清空之前的HUD，再showSuccess或Error
 *
 */
+ (void)hideOldHudsThenShowSuccess:(NSString *)success toView:(UIView *)view;
+ (void)hideOldHudsThenShowError:(NSString *)error toView:(UIView *)view;

/**
 *  无蒙版
 */
+ (MBProgressHUD *)showMessageWithoutDim:(NSString *)message toView:(UIView *)view;

/**
 *  无文字、无蒙版
 */
+ (MBProgressHUD *)showHUDTo:(UIView *)view;

/**
 *  设置offset
 */
+ (MBProgressHUD *)showTipMessag:(NSString *)message offset:(CGPoint)offset toView:(UIView *)view;

@end
