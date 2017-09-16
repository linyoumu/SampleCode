//
//  LinFaceViewContainer.h
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/16.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXFaceView.h"
#import "LinFaceView.h"

@class LinFaceViewContainer;

@protocol LinFaceViewContainerDelegate <NSObject>

- (void)faceViewContainerDidClickDeleteButton:(LinFaceViewContainer *)container;

@end

@interface LinFaceViewContainer : UIView

+ (instancetype)faceView;
@property (assign, nonatomic) BOOL onlyFace;
@property (assign, nonatomic) BOOL onlyEmoji;
@property (strong, nonatomic) DXFaceView *emojiView;
@property (strong, nonatomic) LinFaceView *faceView;
@property (weak, nonatomic) id<LinFaceViewContainerDelegate> delegate;

@end

@interface LinFaceViewContainerButton : UIButton

+ (instancetype)buttonWithImageName:(NSString *)imageName;

@end
