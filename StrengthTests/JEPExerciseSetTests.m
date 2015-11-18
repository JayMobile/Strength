//
//  JEPExerciseSetTests.m
//  Strength
//
//  Created by Julius Parishy on 11/12/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "JEPExerciseSet.h"

@interface JEPExerciseSetTests : XCTestCase

@end

@implementation JEPExerciseSetTests

- (void)testBasicWeightByReps
{
    JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150x5"];
    
    XCTAssert(set.weightValue == 150.0);
    XCTAssert(set.weightUnit == JEPWeightUnitPounds);
    XCTAssert(set.reps == 5.0);
}

- (void)testUnitDetection
{
    JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150lb x 5"];
    XCTAssert(set.weightValue == 150.0);
    XCTAssert(set.weightUnit == JEPWeightUnitPounds);
    XCTAssert(set.reps == 5.0);
    
    set = [[JEPExerciseSet alloc] initWithString:@"150kg x 5"];
    XCTAssert(set.weightValue == 150.0);
    XCTAssert(set.weightUnit == JEPWeightUnitKilograms);
    XCTAssert(set.reps == 5.0);
}

- (void)testSpaces
{
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150x5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 x5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 x 5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150x 5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150lb x 5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 lb x 5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 kg x 5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitKilograms);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150    lb x 5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 lb   x 5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 lb   x    5"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 lb   x    5    "];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"  150 lb   x    5    "];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
    }
}

- (void)testSetComments
{
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 lb x 5 this is a note"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
        XCTAssertEqualObjects(set.comment, @"this is a note");
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 lb x 5 this is a note\nblah blah this is nothing"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
        XCTAssertEqualObjects(set.comment, @"this is a note");
    }
    
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:@"150 lb x 5       this is a note\n"];
        
        XCTAssert(set.weightValue == 150.0);
        XCTAssert(set.weightUnit == JEPWeightUnitPounds);
        XCTAssert(set.reps == 5.0);
        XCTAssertEqualObjects(set.comment, @"this is a note");
    }
}

- (void)testInvalidStrings
{
    XCTAssertNil([[JEPExerciseSet alloc] initWithString:@"alksdjf"]);
    XCTAssertNil([[JEPExerciseSet alloc] initWithString:@"150 5"]);
    XCTAssertNil([[JEPExerciseSet alloc] initWithString:@"150 a"]);
    XCTAssertNil([[JEPExerciseSet alloc] initWithString:@"a 30"]);
}

- (void)testMultipleSetDetection
{
    {
        NSString *body = \
        @"\n" \
        "150x5\n" \
        "";
        
        XCTAssertEqual([JEPExerciseSet exerciseSetsFromString:body].count, 1);
    }
    
    {
        NSString *body = \
        @"\n"   \
        "150x5\n"   \
        "150 x 5\n" \
        "";
        
        XCTAssertEqual([JEPExerciseSet exerciseSetsFromString:body].count, 2);
    }
    
    {
        NSString *body = \
        @"\n"   \
        "150x5\n"   \
        "150 x 5\n" \
        "150 a 5\n" \
        "";
        
        XCTAssertEqual([JEPExerciseSet exerciseSetsFromString:body].count, 2);
    }
    
    {
        NSString *body = \
        @"\n"   \
        "150x5\n"   \
        "150 x 5\n" \
        "150 a 5\n" \
        "150 x 5\n" \
        "";
        
        XCTAssertEqual([JEPExerciseSet exerciseSetsFromString:body].count, 3);
    }
}

@end
