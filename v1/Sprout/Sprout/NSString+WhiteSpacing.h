//
//  NSString+WhiteSpacing.h
//
//  Created by Jeff Morris on 5/23/12.
//

#import <Foundation/Foundation.h>

@interface NSString (WhiteSpacing)

- (NSString*)stringByTrimmingLeadingWhitespace;
- (NSString*)stringByTrimmingTailingWhitespace;
- (NSString*)stringByTrimmingLeadingAndTailingWhitespace;

- (NSString *)stringByStrippingHTML;

@end
