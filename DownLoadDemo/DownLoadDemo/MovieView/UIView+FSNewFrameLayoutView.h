//
//  UIView+FSNewFrameLayoutView.h
//  SKGShop
//
//  Created by Fasa Mo on 15/11/2.
//  Copyright © 2015年 LIUX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FSNewFrameLayoutView)
#pragma mark - Layer
- (CALayer *)fsf_newLayer;
- (CATextLayer *)fsf_newTextLayerWithFont:(UIFont *)font color:(UIColor *)color;

#pragma mark - View
- (UIView *)fsf_newView;
- (UIView *)fsf_newViewWithColor:(UIColor *)bgColor;

#pragma mark - ImageView
- (UIImageView *)fsf_newImageView;
- (UIImageView *)fsf_newImageViewWithColor:(UIColor *)bgColor;
- (UIImageView *)fsf_newImageViewWithName:(NSString *)name;

#pragma mark - Label
- (UILabel *)fsf_newLabelWithText:(NSString *)text Font:(UIFont *)font color:(UIColor *)color;
- (UILabel *)fsf_newLabelWithFont:(UIFont *)font color:(UIColor *)color;
- (UILabel *)fsf_newLabelWithFont:(UIFont *)font;
- (UILabel *)fsf_newLabelWithColor:(UIColor *)color;

#pragma mark - Button
- (UIButton *)fsf_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color image:(NSString *)image selectedImage:(NSString *)selectedImage highlightedImage:(NSString *)highlightedImage;
/**
 *  title
 */
- (UIButton *)fsf_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color;
- (UIButton *)fsf_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle font:(UIFont *)font color:(UIColor *)color;
- (UIButton *)fsf_newButtonWithTitle:(NSString *)title highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color;

- (UIButton *)fsf_newButtonWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color;
- (UIButton *)fsf_newButtonWithTitle:(NSString *)title font:(UIFont *)font;
- (UIButton *)fsf_newButtonWithTitle:(NSString *)title;

/**
 *  image
 */
- (UIButton *)fsf_newButtonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage highlightedImage:(NSString *)highlightedImage;
- (UIButton *)fsf_newButtonWithImage:(NSString *)image highlightImage:(NSString *)highlightImage;
- (UIButton *)fsf_newButtonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage;
- (UIButton *)fsf_newButtonWithImage:(NSString *)image;

#pragma mark - TextField
- (UITextField *)fsf_newTextFieldWithFont:(UIFont *)font textColor:(UIColor *)color placeholder:(NSString *)placeholder;
- (UITextField *)fsf_newTextFieldWithFont:(UIFont *)font textColor:(UIColor *)color;
- (UITextField *)fsf_newTextFieldWithFont:(UIFont *)font;
- (UITextField *)fsf_newTextFieldWithPlaceholder:(NSString *)placeholder;

#pragma mark - TextView
- (UITextView *)fsf_newTextViewWithFont:(UIFont *)font textColor:(UIColor *)color;
- (UITextView *)fsf_newTextViewWithFont:(UIFont *)font;
@end

@interface UITableViewCell (FSNewFrameLayoutView)
#pragma mark - View
- (UIView *)fsfCell_newView;
- (UIView *)fsfCell_newViewWithColor:(UIColor *)bgColor;

#pragma mark - ImageView
- (UIImageView *)fsfCell_newImageView;
- (UIImageView *)fsfCell_newImageViewWithColor:(UIColor *)bgColor;
- (UIImageView *)fsfCell_newImageViewWithName:(NSString *)name;

#pragma mark - Label
- (UILabel *)fsfCell_newLabelWithText:(NSString *)text Font:(UIFont *)font color:(UIColor *)color;
- (UILabel *)fsfCell_newLabelWithFont:(UIFont *)font color:(UIColor *)color;
- (UILabel *)fsfCell_newLabelWithFont:(UIFont *)font;
- (UILabel *)fsfCell_newLabelWithColor:(UIColor *)color;

#pragma mark - Button
- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color image:(NSString *)image selectedImage:(NSString *)selectedImage highlightedImage:(NSString *)highlightedImage;
/**
 *  title
 */
- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color;
- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle font:(UIFont *)font color:(UIColor *)color;
- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color;

- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color;
- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title font:(UIFont *)font;
- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title;

/**
 *  image
 */
- (UIButton *)fsfCell_newButtonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage highlightedImage:(NSString *)highlightedImage;
- (UIButton *)fsfCell_newButtonWithImage:(NSString *)image highlightImage:(NSString *)highlightImage;
- (UIButton *)fsfCell_newButtonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage;
- (UIButton *)fsfCell_newButtonWithImage:(NSString *)image;

#pragma mark - TextField
- (UITextField *)fsfCell_newTextFieldWithFont:(UIFont *)font textColor:(UIColor *)color placeholder:(NSString *)placeholder;
- (UITextField *)fsfCell_newTextFieldWithFont:(UIFont *)font textColor:(UIColor *)color;
- (UITextField *)fsfCell_newTextFieldWithFont:(UIFont *)font;
- (UITextField *)fsfCell_newTextFieldWithPlaceholder:(NSString *)placeholder;

#pragma mark - TextView
- (UITextView *)fsfCell_newTextViewWithFont:(UIFont *)font textColor:(UIColor *)color;
- (UITextView *)fsfCell_newTextViewWithFont:(UIFont *)font;

@end
