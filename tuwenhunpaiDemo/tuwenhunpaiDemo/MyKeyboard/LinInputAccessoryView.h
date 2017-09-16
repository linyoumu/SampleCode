//
//  LinInputAccessoryView.h
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/16.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LinInputAccessoryViewDelegate <NSObject>

@optional

- (void)handleSelectedImage;

- (void)handleInputComplete;

- (void)handleChangeInputModeWithButton:(UIButton *)button;

@end

@interface LinInputAccessoryView : UIView

@property (nonatomic, assign)BOOL hasSelected;
@property (nonatomic, assign)BOOL hasHidden;
@property (nonatomic, assign)BOOL hanHiddenImage;
@property (nonatomic, weak)id<LinInputAccessoryViewDelegate>delegate;

@end
