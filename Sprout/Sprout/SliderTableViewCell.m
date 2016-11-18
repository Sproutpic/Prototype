//
//  SliderTableViewCell.m
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SliderTableViewCell.h"

@implementation SliderTableViewCell

- (IBAction)sliderChanged:(id)sender
{
    if ([self sliderCallback]) self.sliderCallback([self slider],self);
}

@end
