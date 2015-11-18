//
//  UIViewController+JEPUtilities.m
//  Strength
//
//  Created by Julius Parishy on 11/17/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "UIViewController+JEPUtilities.h"

@implementation UIViewController (JEPUtilities)

- (void)jep_disableBackButtonText
{
    UIBarButtonItemStyle style = self.navigationItem.backBarButtonItem.style;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:style target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = item;
}

@end
