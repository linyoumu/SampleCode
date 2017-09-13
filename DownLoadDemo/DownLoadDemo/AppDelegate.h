//
//  AppDelegate.h
//  DownLoadDemo
//
//  Created by Myfly on 17/9/13.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


// Allow Rotation
@property (nonatomic, assign) BOOL allowRotation;
@property (assign, nonatomic) UIInterfaceOrientationMask preferRotationOrientation;

@end

