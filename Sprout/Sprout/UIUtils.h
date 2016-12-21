//
//  UIUtils.h
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PREF_SHOULD_SYNC_BOOL @"PREF_SHOULD_SYNC_BOOL"

@interface UIUtils : NSObject
    
+ (void)vibrate;
+ (void)hapticFeedback;

+ (UIColor*)colorNavigationBar;
+ (UIColor*)colorMenuButtonsSeparator;
+ (UIColor *)colorLightGrey;

+ (UIFont*)fontForNavBarTitle;
+ (UIFont*)fontForFAQQuestionActive;
+ (UIFont*)fontForFAQAnswerActive;
+ (UIFont*)fontRegularForSize:(CGFloat) size;
+ (UIFont*)fontBoldForSize:(CGFloat) size;

+ (NSAttributedString*)attrString:(NSString*)attrStr
                         withFont:(UIFont*)attrFont
                            color:(UIColor*)attrColor
                   andCharSpacing:(NSNumber*)attrSpace;

@end
