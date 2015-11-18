//
//  NSDate+JEPUtilities.m
//  Strength
//
//  Created by Julius Parishy on 11/17/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "NSDate+JEPUtilities.h"

@implementation NSDate (JEPUtilities)

- (instancetype)jep_previousDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    
    return [calendar dateByAddingComponents:components toDate:self options:kNilOptions];
}

- (instancetype)jep_nextDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    
    return [calendar dateByAddingComponents:components toDate:self options:kNilOptions];
}

- (BOOL)jep_isToday
{
    return [self jep_isSameDayAsDate:[NSDate date]];
}

- (BOOL)jep_isSameDayAsDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone systemTimeZone];
    
    NSInteger needed = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *nowComponents = [calendar components:needed fromDate:date];
    NSDateComponents *selfComponents = [calendar components:needed fromDate:self];
    
    return (nowComponents.year  == selfComponents.year)  &&
           (nowComponents.month == selfComponents.month) &&
           (nowComponents.day   == selfComponents.day);
}

- (NSString *)jep_humanReadableString
{
    if([self jep_isToday])
    {
        return NSLocalizedString(@"Today", nil);
    }
    else if([self jep_isSameDayAsDate:[[NSDate date] jep_previousDay]])
    {
        return NSLocalizedString(@"Yesterday", nil);
    }
    else
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        calendar.timeZone = [NSTimeZone systemTimeZone];
        
        NSInteger selfWeek = [calendar component:NSCalendarUnitWeekOfYear fromDate:self];
        NSInteger todayWeek = [calendar component:NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
        
        if(selfWeek == todayWeek)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.timeZone = calendar.timeZone;
            dateFormatter.dateFormat = @"EEEE";
            
            return [dateFormatter stringFromDate:self];
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.timeZone = calendar.timeZone;
            dateFormatter.dateFormat = @"MMMM d";
            
            NSString *datePart = [dateFormatter stringFromDate:self];
            
            static NSDictionary *suffixes = nil;
            if(suffixes == nil)
            {
                suffixes = @{
                    @"1" : @"st",
                    @"2" : @"nd",
                    @"3" : @"rd",
                    @"4" : @"th",
                    @"5" : @"th",
                    @"6" : @"th",
                    @"7" : @"th",
                    @"8" : @"th",
                    @"9" : @"th",
                    @"0" : @"th",
                };
            }
            
            NSString *suffix = [suffixes objectForKey:[NSString stringWithFormat:@"%c", [datePart characterAtIndex:datePart.length - 1]]];
            return [NSString stringWithFormat:@"%@%@", datePart, suffix];
        }
    }
}

@end
