/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

#import "FacialView.h"

@protocol DXFaceDelegate <FacialViewDelegate>

@optional
- (void)sendFace;

@required
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;

@end

@protocol DXFaceViewDelegateForContainer <NSObject>

-(void)facialViewDidScrollToPage:(NSUInteger)page;

@end

@interface DXFaceView : UIView <FacialViewDelegate>

@property (assign, nonatomic, readonly) NSUInteger totalPage;
@property (nonatomic, assign) id<DXFaceDelegate> delegate;
@property (weak, nonatomic) id<DXFaceViewDelegateForContainer> delegateForContainer;

- (BOOL)stringIsFace:(NSString *)string;
- (NSUInteger)indexOfFaces:(NSString *)string;
- (NSString *)faceStringAtIndex:(NSUInteger)index;

- (void)scroll;

@end
