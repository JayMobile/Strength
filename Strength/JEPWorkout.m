//
//  JEPWorkout.m
//  Strength
//
//  Created by Julius Parishy on 11/16/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "JEPWorkout.h"

#import "NSDate+JEPUtilities.h"

@implementation JEPWorkout

- (NSString *)title
{
    return [self.date jep_humanReadableString];
}

@end
