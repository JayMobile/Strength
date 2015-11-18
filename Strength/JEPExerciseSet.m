//
//  JEPExerciseSet.m
//  Strength
//
//  Created by Julius Parishy on 11/2/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "JEPExerciseSet.h"

#import "NSString+JEPUtilities.h"

@implementation JEPExerciseSet

+ (JEPWeightUnit)defaultUnit
{
    return JEPWeightUnitPounds;
}

+ (nonnull NSArray *)exerciseSetsFromString:(nonnull NSString *)string
{
    NSMutableArray *sets = [[NSMutableArray alloc] init];
    NSArray *lines = [string componentsSeparatedByString:@"\n"];
   
     for(NSString *line in lines)
    {
        JEPExerciseSet *set = [[JEPExerciseSet alloc] initWithString:line];
        if(set)
        {
            [sets addObject:set];
        }
    }
    
    return [sets copy];
}

- (instancetype)initWithString:(nonnull NSString *)string
{
    if((self = [super init]))
    {
        if([self setPropertiesFromString:string] == NO)
        {
            return nil;
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSString *unit = (self.weightUnit == JEPWeightUnitPounds) ? @"lb" : @"kg";
    NSString *desc = [NSString stringWithFormat:@"<ExerciseSet: weight=%f%@, reps=%f", self.weightValue, unit, self.reps];
    
    if(self.comment.length > 0)
    {
        desc = [desc stringByAppendingFormat:@", comment=\'%@\'", self.comment];
    }
    
    desc = [desc stringByAppendingFormat:@">"];
    
    return desc;
}

- (BOOL)setPropertiesFromString:(nonnull NSString *)inString
{
    NSString *string = [inString lowercaseString];
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    scanner.charactersToBeSkipped = nil;
    
    [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:nil];
    
    BOOL foundWeight = NO;
    BOOL foundReps = NO;
    
    double weight = 0.0;
    if([scanner scanDouble:&weight])
    {
        _weightValue = weight;
        foundWeight = YES;
    }
    
    if(foundWeight)
    {
        [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:nil];
        
        NSInteger scanLocation = [scanner scanLocation];
        if(scanLocation <= (string.length - 1))
        {
            unichar currentChar = [string characterAtIndex:scanLocation];
            
            NSString *outStr = nil;
            
            if(currentChar == 'l' || currentChar == 'k')
            {
                if([scanner scanString:@"lb" intoString:&outStr])
                {
                    _weightUnit = JEPWeightUnitPounds;
                }
                else if([scanner scanString:@"kg" intoString:&outStr])
                {
                    _weightUnit = JEPWeightUnitKilograms;
                }
            }
            
            [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:nil];
        }
    }
    
    if([scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"x"] intoString:nil])
    {
        [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:nil];
        
        double reps = 0.0;
        if([scanner scanDouble:&reps])
        {
            _reps = reps;
            foundReps = YES;
        }
    }
    else
    {
        /*
         * Don't know what to do here so bail.
         */
        if([scanner isAtEnd] == NO)
        {
            return NO;
        }
    }
    
    if(foundWeight == YES && foundReps == NO)
    {
        // lol sike that's reps not weight
        _reps = _weightValue;
        _weightValue = 0.0;
    }
    else if(foundWeight == NO && foundReps == NO)
    {
        return NO;
    }
    
    if([scanner isAtEnd] == NO)
    {
        NSString *substring = [string substringFromIndex:scanner.scanLocation];
        
        NSRange newLine = [substring rangeOfString:@"\n"];
        NSInteger location = (newLine.location != NSNotFound) ? newLine.location : substring.length;
        
        NSString *restOfString = [substring substringToIndex:location];
        
        if(restOfString.length > 0)
        {
            _comment = [restOfString jep_stringByTrimmingLeadingAndTrailingWhitespace];
        }
    }
    
    return YES;
}

@end
