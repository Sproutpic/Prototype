//
//  NoDataView.m
//  Sprout
//
//  Created by Jeff Morris on 11/20/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([self button]) {
        [[[self button] layer] setMasksToBounds:YES];
        [[[self button] layer] setCornerRadius:5.0];
    }
}

@end
