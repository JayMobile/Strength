//
//  JEPExercisesViewController.m
//  Strength
//
//  Created by Julius Parishy on 11/16/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "JEPExercisesViewController.h"

#import "JEPWorkout.h"
#import "JEPExercise.h"

#import "JEPWorkoutsListViewController.h"
#import "JEPExerciseStatsViewController.h"

#import "UIViewController+JEPUtilities.h"

NSString *const JEPExercisesViewControllerStoryboardIdentifier = @"JEPExercisesViewController";
NSString *const JEPExerciseCellIdentifier = @"JEPExerciseCellIdentifier";


@interface JEPExercisesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *exerciseEntries;

@end


@implementation JEPExercisesViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        self.title = NSLocalizedString(@"Stats Tho", nil);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self jep_disableBackButtonText];
    
    [self reloadAllExercises];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JEPExerciseCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
}

- (void)reloadAllExercises
{
    __weak typeof(self) weakSelf = self;
    
    [self.databaseConnection asyncReadWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
    
        __strong typeof(self) self = weakSelf;
        
        NSArray *keys = [transaction allKeysInCollection:JEPWorkoutsCollectionName];
        
        NSMutableArray *workouts = [[NSMutableArray alloc] init];
        for(NSString *key in keys)
        {
            [workouts addObject:[transaction objectForKey:key inCollection:JEPWorkoutsCollectionName]];
        }
        
        NSMutableDictionary *exercises = [[NSMutableDictionary alloc] init];
        
        for(JEPWorkout *workout in workouts)
        {
            for(JEPExercise *exercise in workout.exercises)
            {
                JEPExerciseEntry *entry = exercises[exercise.canonicalName];
                if(entry == nil)
                {
                    entry = [[JEPExerciseEntry alloc] init];
                    entry.name = exercise.displayableCanonicalName;
                    entry.allSets = [[NSArray alloc] init];
                    
                    exercises[exercise.canonicalName] = entry;
                }
                
                NSMutableArray *sets = [entry.allSets mutableCopy];
                
                for(JEPExerciseSet *set in exercise.sets)
                {
                    [sets addObject:set];
                }
                
                entry.allSets = sets;
            }
        }
        
        NSArray *descriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES] ];
        NSArray *sortedKeys = [exercises.allKeys sortedArrayUsingDescriptors:descriptors];
        
        NSMutableArray *exerciseEntries = [[NSMutableArray alloc] init];
        for(NSString *key in sortedKeys)
        {
            [exerciseEntries addObject:[exercises objectForKey:key]];
        }
        
        self.exerciseEntries = exerciseEntries;
        
    } completionBlock:^{
        
        __strong typeof(self) self = weakSelf;
        [self.tableView reloadData];
    }];
}

- (void)showExerciseEntry:(JEPExerciseEntry *)entry
{
    JEPExerciseStatsViewController *viewController = (JEPExerciseStatsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:JEPExerciseStatsViewControllerStoryboardIdentifier];
    viewController.entry = entry;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    JEPExerciseEntry *entry = self.exerciseEntries[index];
    
    [self showExerciseEntry:entry];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exerciseEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    JEPExerciseEntry *entry = self.exerciseEntries[index];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JEPExerciseCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = entry.name;
    
    return cell;
}

@end


@implementation JEPExerciseEntry

- (CGFloat)maximumValue
{
    CGFloat max = 0.0;
    
    for(JEPExerciseSet *set in self.allSets)
    {
        max = MAX(max, set.weightValue);
    }
    
    return max;
}

@end
