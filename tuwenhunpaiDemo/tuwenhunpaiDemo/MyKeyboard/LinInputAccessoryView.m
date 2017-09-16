//
//  LinInputAccessoryView.m
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/16.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "LinInputAccessoryView.h"

@interface LinInputAccessoryView ()

@property (nonatomic, strong)UIButton *changeInputModeButton;
@property (nonatomic, strong)UIButton *selectedButton;

@end

@implementation LinInputAccessoryView

#pragma mark - life init setup

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupCommonInit];
    }
    
    return self;
}

#pragma mark - commont Init

- (void)setupCommonInit
{
    self.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    
    [self setupSubviews];
}

#pragma mark -
#pragma mark - Setup UI createSubviews

- (void)setupSubviews
{
    UIImageView * overlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, GlobalSeperateLineWH)];
    overlineImageView.backgroundColor = GlobalMainLineGrayColor;
    [self addSubview:overlineImageView];
    
    self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.frame = CGRectMake(5, 1, 44, 44);
    [_selectedButton setImage:[UIImage imageNamed:@"life_post_selected_image"] forState:UIControlStateNormal];
    [_selectedButton addTarget:self action:@selector(handleSelectedImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectedButton];
    
    self.changeInputModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeInputModeButton.frame = CGRectMake(_selectedButton.right + 8, 1, 44, 44);
    [_changeInputModeButton setImage:[UIImage imageNamed:@"life_addCommentDock_emoji"] forState:UIControlStateNormal];
    [_changeInputModeButton setImage:[UIImage imageNamed:@"life_addCommentDock_keyboard"] forState:UIControlStateSelected];
    [_changeInputModeButton addTarget:self action:@selector(handleChangeInputModeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_changeInputModeButton];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(self.width - 50, 1, 50, 44);
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:GlobalTextBlackColor forState:UIControlStateNormal];
    [completeButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [completeButton addTarget:self action:@selector(handleInputCompleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:completeButton];
    
    UIImageView * underlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - GlobalSeperateLineWH, self.width, GlobalSeperateLineWH)];
    underlineImageView.backgroundColor = GlobalMainLineGrayColor;
    [self addSubview:underlineImageView];
}

- (void)createSelectedImageButton
{
    
}

#pragma mark - Layout UpdateConstraints


#pragma mark - Event response

- (void)handleSelectedImageAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSelectedImage)]) {
        [self.delegate handleSelectedImage];
    }
    
}

- (void)handleInputCompleteAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleInputComplete)]) {
        [self.delegate handleInputComplete];
    }
}

- (void)handleChangeInputModeButtonAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleChangeInputModeWithButton:)]) {
        [self.delegate handleChangeInputModeWithButton:button];
    }
    
}

#pragma mark - Public Method


#pragma mark - Private Method


#pragma mark - Delegate


#pragma mark - Setters and Getters

- (void)setHasSelected:(BOOL)hasSelected
{
    _hasSelected = hasSelected;
    _changeInputModeButton.selected = hasSelected;
}

- (void)setHasHidden:(BOOL)hasHidden
{
    _hasHidden = hasHidden;
    _changeInputModeButton.hidden = hasHidden;
    
}

- (void)setHanHiddenImage:(BOOL)hanHiddenImage
{
    _hanHiddenImage = hanHiddenImage;
    self.selectedButton.hidden = hanHiddenImage;
    _changeInputModeButton.frame = _selectedButton.frame;
}

@end
