//
//  SproutDisplayTableViewCell.m
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SproutDisplayTableViewCell.h"
#import "SproutView.h"
#import "DataObjects.h"

@implementation SproutDisplayTableViewCell

# pragma mark Public

- (void)setProject:(Project *)project
{
    _project = project;
    [[self sproutView] setProject:project];
}

@end
