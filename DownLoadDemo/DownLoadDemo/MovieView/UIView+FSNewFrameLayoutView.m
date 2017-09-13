//
//  UIView+FSNewFrameLayoutView.m
//  SKGShop
//
//  Created by Fasa Mo on 15/11/2.
//  Copyright © 2015年 LIUX. All rights reserved.
//

#import "UIView+FSNewFrameLayoutView.h"

@implementation UIView (FSNewFrameLayoutView)
#pragma mark - Layer
- (CALayer *)fsf_newLayer
{
    CALayer *layer = [CALayer layer];
    layer.opaque = YES;
    layer.contentsScale = UIScreen.mainScreen.scale;    
    [self.layer addSublayer:layer];
    return layer;
}

- (CATextLayer *)fsf_newTextLayerWithFont:(UIFont *)font color:(UIColor *)color
{
    CATextLayer *layer = [CATextLayer layer];
    layer.opaque = YES;
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    layer.font = fontRef;
    layer.fontSize = font.pointSize;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = UIScreen.mainScreen.scale;
    [self.layer addSublayer:layer];
    return layer;
}

#pragma mark - View
- (UIView *)fsf_newView
{
    UIView *view = [UIView new];
    view.opaque = YES;
    [self addSubview:view];
    return view;
}

- (UIView *)fsf_newViewWithColor:(UIColor *)bgColor
{
    UIView *view = [self fsf_newView];
    view.backgroundColor = bgColor;
    return view;
}

#pragma mark - ImageView
- (UIImageView *)fsf_newImageView
{
    UIImageView *imageView = [UIImageView new];
    imageView.opaque = YES;
    [self addSubview:imageView];
    return imageView;
}

- (UIImageView *)fsf_newImageViewWithColor:(UIColor *)bgColor
{
    UIImageView *imageView = [self fsf_newImageView];
    imageView.backgroundColor = bgColor;
    return imageView;
}

- (UIImageView *)fsf_newImageViewWithName:(NSString *)name
{
    UIImageView *imageView = [self fsf_newImageView];
    imageView.image = [UIImage imageNamed:name];
    return imageView;
}

#pragma mark - Label
- (UILabel *)fsf_newLabelWithText:(NSString *)text Font:(UIFont *)font color:(UIColor *)color
{
    UILabel *label = [UILabel new];
    label.opaque = YES;
    label.text = text;
    label.font = font;
    label.textColor = color;
    [self addSubview:label];
    return label;
}

- (UILabel *)fsf_newLabelWithFont:(UIFont *)font color:(UIColor *)color
{
    return [self fsf_newLabelWithText:nil Font:font color:color];
}

- (UILabel *)fsf_newLabelWithFont:(UIFont *)font
{
    return [self fsf_newLabelWithText:nil Font:font color:nil];
}

- (UILabel *)fsf_newLabelWithColor:(UIColor *)color
{
    return [self fsf_newLabelWithText:nil Font:nil color:color];
}

#pragma mark - Button
- (UIButton *)fsf_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color image:(NSString *)image selectedImage:(NSString *)selectedImage highlightedImage:(NSString *)highlightedImage
{
    UIButton *button = [UIButton new];
    button.opaque = YES;
    if (title && title.length) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (selectedTitle && selectedTitle.length) {
        [button setTitle:selectedTitle forState:UIControlStateSelected];
    }
    if (highlightedTitle && highlightedTitle.length) {
        [button setTitle:highlightedTitle forState:UIControlStateHighlighted];
    }
    
    if (font) {
        button.titleLabel.font = font;
    }
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (image && image.length) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (selectedImage && selectedImage.length) {
        [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    }
    if (highlightedImage && highlightedImage.length) {
        [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
    [self addSubview:button];
    return button;
}

/**
 *  title
 */
- (UIButton *)fsf_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color
{
    return [self fsf_newButtonWithTitle:title selectedTitle:selectedTitle highlightedTitle:highlightedTitle font:font color:color image:nil selectedImage:nil highlightedImage:nil];
}

- (UIButton *)fsf_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle font:(UIFont *)font color:(UIColor *)color
{
    return [self fsf_newButtonWithTitle:title selectedTitle:selectedTitle highlightedTitle:nil font:font color:color image:nil selectedImage:nil highlightedImage:nil];
}

- (UIButton *)fsf_newButtonWithTitle:(NSString *)title highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color
{
    return [self fsf_newButtonWithTitle:title selectedTitle:nil highlightedTitle:highlightedTitle font:font color:color image:nil selectedImage:nil highlightedImage:nil];
}

- (UIButton *)fsf_newButtonWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color
{
    return [self fsf_newButtonWithTitle:title selectedTitle:nil highlightedTitle:nil font:font color:color image:nil selectedImage:nil highlightedImage:nil];
}

- (UIButton *)fsf_newButtonWithTitle:(NSString *)title font:(UIFont *)font
{
    return [self fsf_newButtonWithTitle:title font:font color:nil];
}

- (UIButton *)fsf_newButtonWithTitle:(NSString *)title
{
    return [self fsf_newButtonWithTitle:title font:nil color:nil];
}

/**
 *  image
 */
- (UIButton *)fsf_newButtonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage highlightedImage:(NSString *)highlightedImage
{
    return [self fsf_newButtonWithTitle:nil selectedTitle:nil highlightedTitle:nil font:nil color:nil image:image selectedImage:selectedImage highlightedImage:highlightedImage];
}

- (UIButton *)fsf_newButtonWithImage:(NSString *)image highlightImage:(NSString *)highlightImage
{
    return [self fsf_newButtonWithImage:image selectedImage:nil highlightedImage:highlightImage];
}

- (UIButton *)fsf_newButtonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage
{
    return [self fsf_newButtonWithImage:image selectedImage:selectedImage highlightedImage:nil];
}

- (UIButton *)fsf_newButtonWithImage:(NSString *)image
{
    return [self fsf_newButtonWithImage:image selectedImage:nil highlightedImage:nil];
}

#pragma mark - TextField
- (UITextField *)fsf_newTextFieldWithFont:(UIFont *)font textColor:(UIColor *)color placeholder:(NSString *)placeholder
{
    UITextField *textField = [UITextField new];
    textField.opaque = YES;
    if (font) {
        textField.font = font;
    }
    if (color) {
        textField.textColor = color;
    }
    if (placeholder && placeholder.length) {
        textField.placeholder = placeholder;
    }
    [self addSubview:textField];
    return textField;
}

- (UITextField *)fsf_newTextFieldWithFont:(UIFont *)font textColor:(UIColor *)color
{
    return [self fsf_newTextFieldWithFont:font textColor:color placeholder:nil];
}

- (UITextField *)fsf_newTextFieldWithFont:(UIFont *)font
{
    return [self fsf_newTextFieldWithFont:font textColor:nil placeholder:nil];
}

- (UITextField *)fsf_newTextFieldWithPlaceholder:(NSString *)placeholder
{
    return [self fsf_newTextFieldWithFont:nil textColor:nil placeholder:placeholder];
}

#pragma mark - TextView
- (UITextView *)fsf_newTextViewWithFont:(UIFont *)font textColor:(UIColor *)color
{
    UITextView *textView = [UITextView new];
    textView.opaque = YES;
    if (font) {
        textView.font = font;
    }
    if (color) {
        textView.textColor = color;
    }
    [self addSubview:textView];
    return textView;
}

- (UITextView *)fsf_newTextViewWithFont:(UIFont *)font
{
    return [self fsf_newTextViewWithFont:font textColor:nil];
}

@end

@implementation UITableViewCell (FSNewFrameLayoutView)
#pragma mark - View
- (UIView *)fsfCell_newView
{
    return [self.contentView fsf_newView];
}

- (UIView *)fsfCell_newViewWithColor:(UIColor *)bgColor
{
    UIView *view = [self fsfCell_newView];
    view.backgroundColor = bgColor;
    return view;
}

#pragma mark - ImageView
- (UIImageView *)fsfCell_newImageView
{
    return [self.contentView fsf_newImageView];
}

- (UIImageView *)fsfCell_newImageViewWithColor:(UIColor *)bgColor
{
    UIImageView *imageView = [self fsfCell_newImageView];
    imageView.backgroundColor = bgColor;
    return imageView;
}

- (UIImageView *)fsfCell_newImageViewWithName:(NSString *)name
{
    UIImageView *imageView = [self fsfCell_newImageView];
    imageView.image = [UIImage imageNamed:name];
    return imageView;
}

#pragma mark - Label
- (UILabel *)fsfCell_newLabelWithText:(NSString *)text Font:(UIFont *)font color:(UIColor *)color
{
    return [self.contentView fsf_newLabelWithText:text Font:font color:color];
}

- (UILabel *)fsfCell_newLabelWithFont:(UIFont *)font color:(UIColor *)color
{
    return [self fsfCell_newLabelWithText:nil Font:font color:color];
}

- (UILabel *)fsfCell_newLabelWithFont:(UIFont *)font
{
    return [self fsfCell_newLabelWithText:nil Font:font color:nil];
}

- (UILabel *)fsfCell_newLabelWithColor:(UIColor *)color
{
    return [self fsfCell_newLabelWithText:nil Font:nil color:color];
}

#pragma mark - Button
- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color image:(NSString *)image selectedImage:(NSString *)selectedImage highlightedImage:(NSString *)highlightedImage
{
    return [self.contentView fsf_newButtonWithTitle:title selectedTitle:selectedTitle highlightedTitle:highlightedTitle font:font color:color image:image selectedImage:selectedImage highlightedImage:highlightedImage];
}

/**
 *  title
 */
- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color
{
    return [self fsfCell_newButtonWithTitle:title selectedTitle:selectedTitle highlightedTitle:highlightedTitle font:font color:color image:nil selectedImage:nil highlightedImage:nil];
}

- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle font:(UIFont *)font color:(UIColor *)color
{
    return [self fsfCell_newButtonWithTitle:title selectedTitle:selectedTitle highlightedTitle:nil font:font color:color image:nil selectedImage:nil highlightedImage:nil];
}

- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title highlightedTitle:(NSString *)highlightedTitle font:(UIFont *)font color:(UIColor *)color
{
    return [self fsfCell_newButtonWithTitle:title selectedTitle:nil highlightedTitle:highlightedTitle font:font color:color image:nil selectedImage:nil highlightedImage:nil];
}

- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color
{
    return [self fsfCell_newButtonWithTitle:title selectedTitle:nil highlightedTitle:nil font:font color:color image:nil selectedImage:nil highlightedImage:nil];
}

- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title font:(UIFont *)font
{
    return [self fsfCell_newButtonWithTitle:title font:font color:nil];
}

- (UIButton *)fsfCell_newButtonWithTitle:(NSString *)title
{
    return [self fsfCell_newButtonWithTitle:title font:nil color:nil];
}

/**
 *  image
 */
- (UIButton *)fsfCell_newButtonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage highlightedImage:(NSString *)highlightedImage
{
    return [self fsfCell_newButtonWithTitle:nil selectedTitle:nil highlightedTitle:nil font:nil color:nil image:image selectedImage:selectedImage highlightedImage:highlightedImage];
}

- (UIButton *)fsfCell_newButtonWithImage:(NSString *)image highlightImage:(NSString *)highlightImage
{
    return [self fsfCell_newButtonWithImage:image selectedImage:nil highlightedImage:highlightImage];
}

- (UIButton *)fsfCell_newButtonWithImage:(NSString *)image selectedImage:(NSString *)selectedImage
{
    return [self fsfCell_newButtonWithImage:image selectedImage:selectedImage highlightedImage:nil];
}

- (UIButton *)fsfCell_newButtonWithImage:(NSString *)image
{
    return [self fsfCell_newButtonWithImage:image selectedImage:nil highlightedImage:nil];
}

#pragma mark - TextField
- (UITextField *)fsfCell_newTextFieldWithFont:(UIFont *)font textColor:(UIColor *)color placeholder:(NSString *)placeholder
{
    return [self.contentView fsf_newTextFieldWithFont:font textColor:color placeholder:placeholder];
}

- (UITextField *)fsfCell_newTextFieldWithFont:(UIFont *)font textColor:(UIColor *)color
{
    return [self fsfCell_newTextFieldWithFont:font textColor:color placeholder:nil];
}

- (UITextField *)fsfCell_newTextFieldWithFont:(UIFont *)font
{
    return [self fsfCell_newTextFieldWithFont:font textColor:nil placeholder:nil];
}

- (UITextField *)fsfCell_newTextFieldWithPlaceholder:(NSString *)placeholder
{
    return [self fsfCell_newTextFieldWithFont:nil textColor:nil placeholder:placeholder];
}

#pragma mark - TextView
- (UITextView *)fsfCell_newTextViewWithFont:(UIFont *)font textColor:(UIColor *)color
{
    return [self fsf_newTextViewWithFont:font textColor:color];
}

- (UITextView *)fsfCell_newTextViewWithFont:(UIFont *)font
{
    return [self fsfCell_newTextViewWithFont:font textColor:nil];
}

@end