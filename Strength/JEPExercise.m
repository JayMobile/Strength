//
//  JEPExercise.m
//  Strength
//
//  Created by Julius Parishy on 11/2/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "JEPExercise.h"

#import "JEPExerciseSet.h"
#import "NSString+JEPUtilities.h"

@implementation JEPExercise

- (instancetype)initWithBodyString:(NSString *)string
{
    if((self = [super init]))
    {
        NSRange range = [string rangeOfString:@"\n"];
        if(range.location == NSNotFound)
            return nil;
        
        NSString *name = [string substringToIndex:range.location];
        
        NSInteger restLocation = range.location;
        if(restLocation + 1 <= string.length - 1)
        {
            restLocation++;
        }
        
        NSString *setsString = [string substringFromIndex:restLocation];
        NSArray *sets = [JEPExerciseSet exerciseSetsFromString:setsString];
        
        _name = name;
        _sets = sets;
    }
    
    return self;
}

+ (nullable NSArray *)exercisesFromString:(nonnull NSString *)string
{
    if(string.length == 0)
    {
        return nil;
    }
    
    NSMutableArray *exercises = [[NSMutableArray alloc] init];
    
    NSString *restOfString = nil;
    NSString *currentBody = string;
    
    do
    {
        NSString *exerciseString = [JEPExercise stringForNextExerciseInParentString:currentBody restOfString:&restOfString];
        
        JEPExercise *exercise = [[JEPExercise alloc] initWithBodyString:exerciseString];
        if(exercise != nil)
        {
            [exercises addObject:exercise];
        }
        
        currentBody = restOfString;
    }
    while(restOfString != nil);
    
    return [exercises copy];
}

/*
 * Takes a whole string and looks for a substring that represents an exercise.
 */
+ (nullable NSString *)stringForNextExerciseInParentString:(nonnull NSString *)string restOfString:(NSString **)outRestOfString
{
    *outRestOfString = nil;
    
    NSInteger startLocation = 0;
    
    for(NSInteger i = startLocation; i < string.length; ++i)
    {
        unichar c = [string characterAtIndex:i];
        if(isblank(c))
        {
            continue;
        }
        else if(isalpha(c))
        {
            startLocation = i;
            break;
        }
    }
    
    unichar c = [string characterAtIndex:startLocation];
    if(isalpha(c) && string.length > (startLocation + 1))
    {
        for(NSInteger i = startLocation + 1; i < string.length; ++i)
        {
            unichar c1 = [string characterAtIndex:i];
            if(i + 1 <= string.length - 1)
            {
                unichar c2 = [string characterAtIndex:i + 1];
                if(c1 == '\n' && c2 == '\n')
                {
                    if(i + 2 <= string.length - 1)
                    {
                        BOOL validRestOfString = NO;
                        
                        NSString *restOfString = [string substringFromIndex:i + 2];
                        for(NSInteger i = 0; i < restOfString.length; ++i)
                        {
                            if(isalnum([restOfString characterAtIndex:i]))
                            {
                                validRestOfString = YES;
                            }
                        }
                        
                        if(validRestOfString)
                        {
                            *outRestOfString = restOfString;
                        }
                    }
                    
                    NSRange range = NSMakeRange(startLocation, i - startLocation);
                    return [string substringWithRange:range];
                }
            }
            else
            {
                if(i == string.length - 1)
                {
                    *outRestOfString = nil;
                    
                    NSInteger chopLastChar = (c1 == '\n') ? 1 : 0;
                    NSRange range = NSMakeRange(startLocation, string.length - startLocation - chopLastChar);
                    return [string substringWithRange:range];
                }
            }
        }
    }
    
    return nil;
}

- (nonnull NSString *)canonicalName
{
    NSString *basic = self.name.lowercaseString;
    
    NSDictionary *fullWordReplacements = @{
        @"dead lift" : @"deadlift"
    };
    
    for(NSString *key in fullWordReplacements)
    {
        basic = [basic stringByReplacingOccurrencesOfString:key withString:fullWordReplacements[key]];
    }
    
    NSDictionary *abbreviations = @{
        @"bb" : @"barbell",
        @"db" : @"dumbbell",
        @"bp" : @"bench press",
        @"dl" : @"deadlift",
    };
    
    NSArray *components = [[basic componentsSeparatedByString:@" "] bk_map:^id(NSString *c) {
    
        NSString *word = [c jep_stringByTrimmingLeadingAndTrailingWhitespace];
        if(word.length > 0)
        {
            return word;
        }
        else
        {
            return nil;
        }
    }];
    
    components = [components bk_map:^id(NSString *c) {
        NSString *nc = abbreviations[c] ?: c;
        return nc;
    }];
    
    NSString *final = [components componentsJoinedByString:@" "];
    
    /*
     * Default ambiguous names like "deadlift" to the barbell variants.
     */
    NSDictionary *finalWordReplacements = @{
        @"deadlift" : @"barbell deadlift",
        @"bench press" : @"barbell bench press",
        @"squat" : @"barbell squat"
    };
    
    for(NSString *key in finalWordReplacements)
    {
        if([final isEqualToString:key])
        {
            final = finalWordReplacements[key];
        }
    }
    
    return final;
}


- (nonnull NSString *)displayableCanonicalName
{
    NSString *name = [self canonicalName];
    NSArray *components = [[name componentsSeparatedByString:@" "] bk_map:^id(NSString *word) {
    
        NSMutableString *mword = [word mutableCopy];
        unichar c = [mword characterAtIndex:0];
        if(islower(c))
        {
            c = toupper(c);
        }
        
        return [NSString stringWithFormat:@"%c%@", c, [mword substringFromIndex:1]];
    }];
    
    return [components componentsJoinedByString:@" "];
}

@end
