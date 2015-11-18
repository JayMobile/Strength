//
//  JEPEntryViewController.m
//  Strength
//
//  Created by Julius Parishy on 11/12/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "JEPEntryViewController.h"

#import "JEPExercise.h"
#import "JEPExerciseSet.h"

NSString *const JEPEntryViewControllerStoryboardIdentifier = @"JEPEntryViewController";

@interface JEPEntryViewController () <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) NSTimer *setScanTimer;

@end

@implementation JEPEntryViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = self.workout.title;
    self.textView.text = self.workout.originalText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    [self registerForTextChangedNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self unregisterForKeyboardNotifications];
    [self unregisterForTextChangedNotification];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.delegate entryViewController:self requestedCommitForChangesToWorkout:self.workout];
}

#pragma mark - Data

- (void)commitWorkoutChanges
{
    NSString *text = self.textView.text;
    
    self.workout.originalText = text;
    self.workout.exercises = [JEPExercise exercisesFromString:text];
}

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect frame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:animationCurve animations:^{
        
        UIEdgeInsets keyboardInset = UIEdgeInsetsMake(0.0, 0.0, (CGRectGetMaxY(self.view.frame) - CGRectGetMinY(frame)), 0.0);
        
        [self.textView setContentInset:keyboardInset];
        [self.textView setScrollIndicatorInsets:keyboardInset];
        
    } completion:nil];
}

#pragma mark - Text handling

- (void)registerForTextChangedNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
}

- (void)unregisterForTextChangedNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.textView];
}

- (void)textDidChange:(NSNotification *)notification
{
    [self resetScanForSetsTimer];
}

- (void)resetScanForSetsTimer
{
    [self.setScanTimer invalidate];
    
    self.setScanTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scanForSets:) userInfo:nil repeats:NO];
}

- (void)scanForSets:(NSTimer *)timer
{
    [self commitWorkoutChanges];
}

@end
