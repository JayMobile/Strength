//
//  JEPExercisesViewController.h
//  Strength
//
//  Created by Julius Parishy on 11/16/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <YapDatabase/YapDatabase.h>

extern NSString *const JEPExercisesViewControllerStoryboardIdentifier;


@interface JEPExerciseEntry : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *allSets;

- (CGFloat)maximumValue;

@end


@interface JEPExercisesViewController : UIViewController

@property (nonatomic, strong) YapDatabaseConnection *databaseConnection;

@end
