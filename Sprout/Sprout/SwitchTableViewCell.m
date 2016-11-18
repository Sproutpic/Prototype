//
//  SwitchTableViewCell.m
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SwitchTableViewCell.h"

@implementation SwitchTableViewCell

- (IBAction)switchChanged:(id)sender
{
    if ([self switchCallback]) self.switchCallback([self switchView]);
}

@end
