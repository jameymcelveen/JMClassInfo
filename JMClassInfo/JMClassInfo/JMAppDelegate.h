//
//  JMAppDelegate.h
//  JMClassInfo
//
//  Created by Jamey McElveen on 5/9/13.
//  Copyright (c) 2013 Jamey McElveen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMViewController;

@interface JMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JMViewController *viewController;

@end
