//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#define MBProgressHUDColor [UIColor blackColor]

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

- (void)showError:(NSString *)error toView:(UIView *)view{
    [self shouText:error andToView:view withIcon:@"error.png"];
    
}
- (void)showSuccess:(NSString *)success toView:(UIView *)view{
    [self shouText:success andToView:view withIcon:@"success.png"];
}
-(void)shouText:(NSString *)text andToView:(UIView*)view withIcon:(NSString*)icon{
    
//    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    self.labelText=text;
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    self.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    self.removeFromSuperViewOnHide = YES;
    
    // 颜色
    self.color = MBProgressHUDColor;
    
    // 1秒之后再消失
    [self hide:YES afterDelay:0.7];
}



#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view delay:(NSTimeInterval)delay
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 颜色
    hud.color = MBProgressHUDColor;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:delay];
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    [self show:text icon:icon view:view delay:0.7];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view delay:(NSTimeInterval)delay
{
    [self show:error icon:@"error.png" view:view delay:delay];
}

+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    // 颜色
    hud.color = MBProgressHUDColor;
    
    return hud;
}

#pragma mark - FOR SKG
+ (MBProgressHUD *)showTipMessag:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)delay {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 纯文字模式
    hud.mode = MBProgressHUDModeText;
    // delay秒之后再消失
    [hud hide:YES afterDelay:delay];
    // 颜色
    hud.color = MBProgressHUDColor;
    
    return hud;
}

+ (MBProgressHUD *)showTipMessag:(NSString *)message toView:(UIView *)view {
    return [self showTipMessag:message toView:view delay:0.7];
}


+ (void)hideOldHudsThenShowSuccess:(NSString *)success toView:(UIView *)view
{
    // 清空之前的提示
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 提示用户
        [MBProgressHUD showSuccess:success toView:view];
    });
}

+ (void)hideOldHudsThenShowError:(NSString *)error toView:(UIView *)view
{
    // 清空之前的提示
    [MBProgressHUD hideAllHUDsForView:view animated:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 提示用户
        [MBProgressHUD showError:error toView:view];
    });
}

+ (MBProgressHUD *)showMessageWithoutDim:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    // 颜色
    hud.color = MBProgressHUDColor;
    
    return hud;
}

+ (MBProgressHUD *)showHUDTo:(UIView *)view
{
    return [self showMessageWithoutDim:nil toView:view];
}

+ (MBProgressHUD *)showTipMessag:(NSString *)message offset:(CGPoint)offset toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showTipMessag:message toView:view];
    hud.xOffset += offset.x;
    hud.yOffset += offset.y;
    return hud;
}

@end
