//
//  UIUtils.m
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils
- (UIColor *)colorNavigationBar{
    return [UIColor colorWithRed:101.0f/255.0f green:179.0f/255.0f blue:179.0f/255.0f alpha:1.0f];
}
- (UIColor *)colorMenuButtonsSeparator{
    return [UIColor colorWithRed:206.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
}
- (UIColor *)colorSproutGreen{
    return [UIColor colorWithRed:216.0f/255.0f green:215.0f/255.0f blue:206.0f/255.0f alpha:1.0f];
}

-(NSAttributedString *)attrString:(NSString *) attrStr withFont:(UIFont *) attrFont color:(UIColor *)attrColor andCharSpacing:(NSNumber *) attrSpace{
    return [[NSAttributedString alloc] initWithString:attrStr attributes:@{NSFontAttributeName: attrFont,
                                                                           NSForegroundColorAttributeName: attrColor,
                                                                           NSKernAttributeName: attrSpace}];
}

- (UIFont *)fontForNavBarTitle{
    return [self fontRegularForSize:17];
}
- (UIFont *)fontForFAQQuestionActive{
    return [self fontBoldForSize:16];
}
- (UIFont *)fontForFAQAnswerActive{
    return [self fontRegularForSize:14];
}

- (UIFont *)fontRegularForSize:(CGFloat) size{
    return [UIFont systemFontOfSize:size];
}
- (UIFont *)fontBoldForSize:(CGFloat) size{
    return [UIFont boldSystemFontOfSize:size];
}
- (UIFont *)fontItalicForSize:(CGFloat) size{
    return [UIFont italicSystemFontOfSize:size];
}
@end
