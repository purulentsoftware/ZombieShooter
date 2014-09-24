//
//  AppDelegate.h
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/17/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MCManager *mcManager;

@end
