//
//  JEPExerciseSet.h
//  Strength
//
//  Created by Julius Parishy on 11/2/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger, JEPWeightUnit)
{
    JEPWeightUnitPounds,
    JEPWeightUnitKilograms
};

@interface JEPExerciseSet : MTLModel

+ (JEPWeightUnit)defaultUnit;

@property (nonatomic, assign, readonly) double reps;

@property (nonatomic, assign, readonly) double weightValue;
@property (nonatomic, assign, readonly) JEPWeightUnit weightUnit;

@property (nonatomic, copy, readonly, nullable) NSString *comment;

- (nullable instancetype)initWithString:(nonnull NSString *)string;

+ (nonnull NSArray *)exerciseSetsFromString:(nonnull NSString *)string;

@end
