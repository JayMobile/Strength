//
//  JEPExerciseTests.m
//  Strength
//
//  Created by Julius Parishy on 11/13/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "JEPExercise.h"
#import "JEPExercise+Private.h"

#import "JEPExerciseSet.h"

@interface JEPExerciseTests : XCTestCase

@end

@implementation JEPExerciseTests

- (void)testExerciseDetection
{
    {
        NSString *bodyString = @"BB Bench Press\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        
        XCTAssertEqual(exercises.count, 1);
        
        JEPExercise *exercise = exercises.firstObject;
        XCTAssertEqualObjects(exercise.name, @"BB Bench Press");
        XCTAssertEqual(exercise.sets.count, 3);
        
        for(JEPExerciseSet *set in exercise.sets)
        {
            XCTAssertEqual(set.weightValue, 150.0);
            XCTAssertEqual(set.reps, 5);
        }
    }
}

- (void)testStringExtraction
{
    {
        NSString *bodyString = @"BB Bench Press\n150x5\n150x5\n150x5\n";
        NSString *restOfString = @"";
        
        NSString *bbBenchPress = [JEPExercise stringForNextExerciseInParentString:bodyString restOfString:&restOfString];
        
        XCTAssertEqualObjects(bbBenchPress, @"BB Bench Press\n150x5\n150x5\n150x5");
        XCTAssertNil(restOfString);
    }
    
    {
        NSString *bodyString = @"BB Bench Press\n150x5\n150x5\n150x5\n\nAnother Exercise\n15x5";
        NSString *restOfString = @"";
        
        NSString *bbBenchPress = [JEPExercise stringForNextExerciseInParentString:bodyString restOfString:&restOfString];
        
        XCTAssertEqualObjects(bbBenchPress, @"BB Bench Press\n150x5\n150x5\n150x5");
        XCTAssertEqualObjects(restOfString, @"Another Exercise\n15x5");
    }
    
    {
        NSString *bodyString = @"BB Bench Press\n150x5\n150x5\n150x5\n\nAnother Exercise\n15x5";
        NSString *restOfString = @"";
        
        NSString *bbBenchPress = [JEPExercise stringForNextExerciseInParentString:bodyString restOfString:&restOfString];
        
        XCTAssertEqualObjects(bbBenchPress, @"BB Bench Press\n150x5\n150x5\n150x5");
        
        NSString *nextRestOfString = @"";
        NSString *anotherExercise = [JEPExercise stringForNextExerciseInParentString:restOfString restOfString:&nextRestOfString];
        
        XCTAssertEqualObjects(anotherExercise, @"Another Exercise\n15x5");
        XCTAssertNil(nextRestOfString);
    }
    
    {
        NSString *bodyString = @"BB Bench Press\n150x5\n150x5\n150x5\n\nAnother Exercise\n15x5\n\nOne More\n25x5\n35x5\n15x5";
        NSString *restOfString = @"";
        
        NSString *bbBenchPress = [JEPExercise stringForNextExerciseInParentString:bodyString restOfString:&restOfString];
        
        XCTAssertEqualObjects(bbBenchPress, @"BB Bench Press\n150x5\n150x5\n150x5");
        
        NSString *nextRestOfString = @"";
        NSString *anotherExercise = [JEPExercise stringForNextExerciseInParentString:restOfString restOfString:&nextRestOfString];
        
        XCTAssertEqualObjects(anotherExercise, @"Another Exercise\n15x5");
        
        NSString *lastRestOfString = @"";
        NSString *lastExercise = [JEPExercise stringForNextExerciseInParentString:nextRestOfString restOfString:&lastRestOfString];
        
        XCTAssertEqualObjects(lastExercise, @"One More\n25x5\n35x5\n15x5");
        XCTAssertNil(lastRestOfString);
    }
    
    {
        NSString *bodyString = @"  BB Bench Press\n150x5\n150x5\n150x5\n\n  Another Exercise\n15x5\n\n\n\n One More\n25x5\n35x5\n15x5\n\n\n";
        NSString *restOfString = @"";
        
        NSString *bbBenchPress = [JEPExercise stringForNextExerciseInParentString:bodyString restOfString:&restOfString];
        
        XCTAssertEqualObjects(bbBenchPress, @"BB Bench Press\n150x5\n150x5\n150x5");
        
        NSString *nextRestOfString = @"";
        NSString *anotherExercise = [JEPExercise stringForNextExerciseInParentString:restOfString restOfString:&nextRestOfString];
        
        XCTAssertEqualObjects(anotherExercise, @"Another Exercise\n15x5");
        
        NSString *lastRestOfString = @"";
        NSString *lastExercise = [JEPExercise stringForNextExerciseInParentString:nextRestOfString restOfString:&lastRestOfString];
        
        XCTAssertEqualObjects(lastExercise, @"One More\n25x5\n35x5\n15x5");
        XCTAssertNil(lastRestOfString);
    }
}

- (void)testMultipleSetsWithNotes
{
    {
        NSString *bodyString = @"BB Bench Press\n150x5\n150x5 second set was hard\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        
        XCTAssertEqual(exercises.count, 1);
        
        JEPExercise *exercise = exercises.firstObject;
        XCTAssertEqualObjects(exercise.name, @"BB Bench Press");
        XCTAssertEqual(exercise.sets.count, 3);
        
        for(JEPExerciseSet *set in exercise.sets)
        {
            XCTAssertEqual(set.weightValue, 150.0);
            XCTAssertEqual(set.reps, 5);
        }
        
        XCTAssertEqualObjects([exercise.sets[1] comment], @"second set was hard");
    }
}

- (void)testCanonicalNames
{
    {
        NSString *bodyString = @"BB Bench Press\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.canonicalName, @"barbell bench press");
    }
    
    {
        NSString *bodyString = @"BB BP\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.canonicalName, @"barbell bench press");
    }
    
    {
        NSString *bodyString = @"DB BP\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.canonicalName, @"dumbbell bench press");
    }
    
    {
        NSString *bodyString = @"DB bench press\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.canonicalName, @"dumbbell bench press");
    }
    
    {
        NSString *bodyString = @"DL\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.canonicalName, @"barbell deadlift");
    }
    
    {
        NSString *bodyString = @"dumbell DL\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.canonicalName, @"dumbell deadlift");
    }
    
    {
        NSString *bodyString = @"Romanian DL\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.canonicalName, @"romanian deadlift");
    }

    {
        NSString *bodyString = @"dead lift\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.canonicalName, @"barbell deadlift");
    }
}

- (void)testDisplayableCanonicalNames
{
    {
        NSString *bodyString = @"B\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.displayableCanonicalName, @"B");
    }
    
    {
        NSString *bodyString = @"BB Bench Press\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.displayableCanonicalName, @"Barbell Bench Press");
    }
    
    {
        NSString *bodyString = @"BB BP\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.displayableCanonicalName, @"Barbell Bench Press");
    }
    
    {
        NSString *bodyString = @"DB BP\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.displayableCanonicalName, @"Dumbbell Bench Press");
    }
    
    {
        NSString *bodyString = @"DB bench press\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.displayableCanonicalName, @"Dumbbell Bench Press");
    }
    
    {
        NSString *bodyString = @"DL\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.displayableCanonicalName, @"Barbell Deadlift");
    }
    
    {
        NSString *bodyString = @"dumbbell DL\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.displayableCanonicalName, @"Dumbbell Deadlift");
    }
    
    {
        NSString *bodyString = @"Romanian DL\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.displayableCanonicalName, @"Romanian Deadlift");
    }
    
    {
        NSString *bodyString = @"dead lift\n150x5\n150x5\n150x5\n";
        NSArray *exercises = [JEPExercise exercisesFromString:bodyString];
        JEPExercise *exercise = exercises.firstObject;
        
        XCTAssertEqualObjects(exercise.displayableCanonicalName, @"Barbell Deadlift");
    }
}

@end
