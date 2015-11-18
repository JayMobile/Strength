//
//  JEPNavigationController.m
//  Strength
//
//  Created by Julius Parishy on 11/16/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "JEPNavigationController.h"

@implementation JEPNavigationController

+ (void)load
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor whiteColor]
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return self.topViewController.preferredStatusBarUpdateAnimation;
}

- (BOOL)prefersStatusBarHidden
{
    return self.topViewController.prefersStatusBarHidden;
}

@end
