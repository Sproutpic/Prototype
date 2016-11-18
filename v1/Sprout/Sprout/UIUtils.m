//
//  UIUtils.m
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "UIUtils.h"
#import <AudioToolbox/AudioServices.h>

@implementation UIUtils
    
+ (void)vibrate;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)hapticFeedback;
{
    if (NSStringFromClass([UISelectionFeedbackGenerator class])!=nil) {
        [[[UISelectionFeedbackGenerator alloc] init] selectionChanged];
    }
}

+ (UIColor *)colorNavigationBar
{
    return [UIColor colorWithRed:101.0f/255.0f green:179.0f/255.0f blue:179.0f/255.0f alpha:1.0f];
}

+ (UIColor *)colorMenuButtonsSeparator
{
    return [UIColor colorWithRed:206.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
}

+ (UIColor *)colorSproutGreen
{
    return [UIColor colorWithRed:216.0f/255.0f green:215.0f/255.0f blue:206.0f/255.0f alpha:1.0f];
}

+ (UIFont *)fontForNavBarTitle
{
    return [self fontRegularForSize:17];
}

+ (UIFont *)fontForFAQQuestionActive
{
    return [self fontBoldForSize:16];
}

+ (UIFont *)fontForFAQAnswerActive
{
    return [self fontRegularForSize:14];
}

+ (UIFont *)fontRegularForSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)fontBoldForSize:(CGFloat)size
{
    return [UIFont boldSystemFontOfSize:size];
}

+ (UIFont *)fontItalicForSize:(CGFloat)size
{
    return [UIFont italicSystemFontOfSize:size];
}

+ (NSAttributedString *)attrString:(NSString *)attrStr
                          withFont:(UIFont *)attrFont
                             color:(UIColor *)attrColor
                    andCharSpacing:(NSNumber *)attrSpace{
    return [[NSAttributedString alloc] initWithString:attrStr
                                           attributes:@{NSFontAttributeName:attrFont,
                                                        NSForegroundColorAttributeName:attrColor,
                                                        NSKernAttributeName:attrSpace}];
}

@end
