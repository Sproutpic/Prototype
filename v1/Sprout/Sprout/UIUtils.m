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
    return [UIColor colorWithRed:54.0f/255.0f green:55.0f/255.0f blue:54.0f/255.0f alpha:1.0f];
}
- (UIColor *)colorMenuButtonsSeparator{
    return [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
}

-(NSAttributedString *)attrString:(NSString *) attrStr withFont:(UIFont *) attrFont color:(UIColor *)attrColor andCharSpacing:(NSNumber *) attrSpace{
    return [[NSAttributedString alloc] initWithString:attrStr attributes:@{NSFontAttributeName: attrFont,
                                                                           NSForegroundColorAttributeName: attrColor,
                                                                           NSKernAttributeName: attrSpace}];
}

- (UIFont *)fontForNavBarTitle{
    return [self fontRegularForSize:16];
}

- (UIFont *)fontRegularForSize:(CGFloat) size{
    return [UIFont systemFontOfSize:size];
}
@end
