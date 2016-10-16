//
//  UIUtils.h
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

+ (UIColor*)colorNavigationBar;
+ (UIColor*)colorMenuButtonsSeparator;
+ (UIColor*)colorSproutGreen;

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
