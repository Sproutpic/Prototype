//
//  NSString+WhiteSpacing.m
//
//  Created by Jeff Morris on 5/23/12.
//

#import "NSString+WhiteSpacing.h"

@implementation NSString (WhiteSpacing)

- (NSString*)stringByTrimmingLeadingWhitespace
{
    if ([self length]==0) return self;
    NSInteger i = 0;
    while ((i < [self length]) && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

- (NSString*)stringByTrimmingTailingWhitespace
{
    if ([self length]==0) return self;
    NSInteger i = 0;
    while ((i < [self length]) && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:[self length]-1-i]]) {
        i++;
    }
    return [self substringWithRange:NSMakeRange(0,[self length]-i)];
}

- (NSString*)stringByTrimmingLeadingAndTailingWhitespace
{
    return [[self stringByTrimmingLeadingWhitespace] stringByTrimmingTailingWhitespace];
}

- (NSString*)stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
