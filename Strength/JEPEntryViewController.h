//
//  JEPEntryViewController.h
//  Strength
//
//  Created by Julius Parishy on 11/12/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JEPWorkout.h"

extern NSString *const JEPEntryViewControllerStoryboardIdentifier;

@protocol JEPEntryViewControllerDelegate;

@interface JEPEntryViewController : UIViewController

@property (nonatomic, strong) JEPWorkout *workout;
@property (nonatomic, weak) id<JEPEntryViewControllerDelegate> delegate;

@end

@protocol JEPEntryViewControllerDelegate <NSObject>

@required
- (void)entryViewController:(JEPEntryViewController *)viewController requestedCommitForChangesToWorkout:(JEPWorkout *)workout;

@end
