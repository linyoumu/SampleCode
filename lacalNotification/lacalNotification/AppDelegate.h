//
//  AppDelegate.h
//  lacalNotification
//
//  Created by Myfly on 17/8/9.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

