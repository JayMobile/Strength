//
//  JEPExerciseStatsViewController.h
//  Strength
//
//  Created by Julius Parishy on 11/16/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JEPExerciseSet.h"

@class JEPExerciseEntry;

extern NSString *const JEPExerciseStatsViewControllerStoryboardIdentifier;

@interface JEPExerciseStatsViewController : UIViewController

@property (nonatomic, strong) JEPExerciseEntry *entry;

@end
