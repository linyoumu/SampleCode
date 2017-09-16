//
//  LinFaceView.h
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/16.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LinFaceViewDelegate <NSObject>
@optional
- (void)faceViewDidSelectFaceName:(NSString *)faceName;
- (void)faceViewDidSelectRemoveString;
@end

@protocol LinFaceViewDelegateForContainer <NSObject>

- (void)faceViewDidScrollToPage:(NSUInteger)page;

@end

@interface LinFaceView : UICollectionView

@property (weak, nonatomic) id<LinFaceViewDelegate> faceDelegate;
@property (weak, nonatomic) id<LinFaceViewDelegateForContainer> delegateForContainer;
@property (assign, nonatomic, readonly) NSUInteger totalPage;

- (IBAction)scroll;

@end
