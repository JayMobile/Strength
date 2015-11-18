//
//  NSString+JEPUtilities.m
//  Strength
//
//  Created by Julius Parishy on 11/17/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "NSString+JEPUtilities.h"

@implementation NSString (JEPUtilities)

- (NSString *)jep_stringByTrimmingLeadingAndTrailingWhitespace
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSInteger front = 0;
    for(NSInteger i = front; i < self.length; ++i)
    {
        front = i;
        
        if([whitespace characterIsMember:[self characterAtIndex:i]] == NO)
        {
            break;
        }
    }
    
    NSString *suffix = [self substringFromIndex:front];
    
    NSInteger end = suffix.length - 1;
    for(NSInteger i = end; i >= 0; --i)
    {
        end = i;
        
        if([whitespace characterIsMember:[suffix characterAtIndex:i]] == NO)
        {
            break;
        }
    }
    
    return [suffix substringToIndex:end + 1];
}

@end
