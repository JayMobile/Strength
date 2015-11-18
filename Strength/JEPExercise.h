//
//  JEPExercise.h
//  Strength
//
//  Created by Julius Parishy on 11/2/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>

@interface JEPExercise : MTLModel

@property (nonatomic, copy, readonly, nonnull) NSString *name;
@property (nonatomic, copy, readonly, nonnull) NSArray *sets;
@property (nonatomic, copy, readonly, nullable) NSString *notes;

+ (nullable NSArray *)exercisesFromString:(nonnull NSString *)string;

/*
 * Used for matching exercises with names that are typed similarly
 * but are intended to be the same. Ex:
 * `bb bp`, `bb bench press` `barbell bench press`
 * all resolve to the same canonical name: `barbell bench press`
 */
- (nonnull NSString *)canonicalName;

/*
 * Prettified `canonicalName` for being shown in UI
 */
- (nonnull NSString *)displayableCanonicalName;

@end
