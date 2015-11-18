//
//  JEPWorkout.h
//  Strength
//
//  Created by Julius Parishy on 11/16/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>

@interface JEPWorkout : MTLModel

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) NSString *originalText;
@property (nonatomic, copy) NSArray *exercises;

- (NSString *)title;

@end
