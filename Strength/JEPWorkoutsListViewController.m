//
//  JEPWorkoutsListViewController.m
//  Strength
//
//  Created by Julius Parishy on 11/16/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "JEPWorkoutsListViewController.h"

#import <YapDatabase/YapDatabase.h>

#import "JEPWorkout.h"

#import "JEPEntryViewController.h"
#import "JEPExercisesViewController.h"

#import "UIViewController+JEPUtilities.h"

NSString *const JEPWorkoutsCollectionName = @"workouts";
NSString *const JEPWorkoutCellIdentifier = @"JEPWorkoutCellIdentifier";

static NSString *JEPPathForDatabase()
{
    NSArray *results = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [results.firstObject stringByAppendingPathComponent:@"workouts.db"];
}

@interface JEPWorkoutsListViewController () <UITableViewDelegate, UITableViewDataSource,
                                             JEPEntryViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YapDatabase *database;
@property (nonatomic, strong) YapDatabaseConnection *databaseConnection;

@property (nonatomic, copy) NSArray *allWorkouts;

@end

@implementation JEPWorkoutsListViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        self.title = NSLocalizedString(@"Strength", @"App Title in Navigation Bar");
        
        self.database = [[YapDatabase alloc] initWithPath:JEPPathForDatabase()];
        self.databaseConnection = [self.database newConnection];
        
        [self reloadWorkouts];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self jep_disableBackButtonText];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JEPWorkoutCellIdentifier];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Stats", nil) style:UIBarButtonItemStylePlain target:self action:@selector(statsButtonPressed:)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
}

#pragma mark - Actions

- (void)statsButtonPressed:(id)sender
{
    JEPExercisesViewController *viewController = (JEPExercisesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:JEPExercisesViewControllerStoryboardIdentifier];
    viewController.databaseConnection = self.databaseConnection;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)addButtonPressed:(id)sender
{
    [self insertNewWorkout];
    [self reloadWorkouts];
}

#pragma mark - Data

- (JEPWorkout *)insertNewWorkout
{
    JEPWorkout *workout = [[JEPWorkout alloc] init];
    workout.identifier = [[NSUUID UUID] UUIDString];
    workout.date = [NSDate date];
    
    [self commitChangesForWorkout:workout];
    
    return workout;
}

- (void)reloadWorkouts
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
        
        NSArray *descriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO] ];
        self.allWorkouts = [workouts sortedArrayUsingDescriptors:descriptors];
        
    } completionBlock:^{
        
        __strong typeof(self) self = weakSelf;
        [self.tableView reloadData];
    }];
}

- (void)showWorkout:(JEPWorkout *)workout
{
    JEPEntryViewController *viewController = (JEPEntryViewController *)[self.storyboard instantiateViewControllerWithIdentifier:JEPEntryViewControllerStoryboardIdentifier];
    
    viewController.workout = workout;
    viewController.delegate = self;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)commitChangesForWorkout:(JEPWorkout *)workout
{
    UIBackgroundTaskIdentifier identifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Failed to write workout after app backgrounded.");
    }];
    
    [self.databaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        
        NSString *key = workout.identifier;
        [transaction setObject:workout forKey:key inCollection:JEPWorkoutsCollectionName];
        
    } completionBlock:^{
        
        [[UIApplication sharedApplication] endBackgroundTask:identifier];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    JEPWorkout *workout = self.allWorkouts[index];
    
    [self showWorkout:workout];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allWorkouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    JEPWorkout *workout = self.allWorkouts[index];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JEPWorkoutCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = workout.title;
    
    return cell;
}

#pragma mark - JEPEntryViewControllerDelegate

- (void)entryViewController:(JEPEntryViewController *)viewController requestedCommitForChangesToWorkout:(JEPWorkout *)workout
{
    [self commitChangesForWorkout:workout];
}

@end
