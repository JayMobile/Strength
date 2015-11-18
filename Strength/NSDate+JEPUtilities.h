//
//  NSDate+JEPUtilities.h
//  Strength
//
//  Created by Julius Parishy on 11/17/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JEPUtilities)

- (instancetype)jep_previousDay;
- (instancetype)jep_nextDay;

- (BOOL)jep_isToday;
- (BOOL)jep_isSameDayAsDate:(NSDate *)date;

- (NSString *)jep_humanReadableString;

@end
