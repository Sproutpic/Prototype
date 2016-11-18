//
//  DateSelectorViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/29/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "DateSelectorViewController.h"

@interface DateSelectorViewController ()

- (IBAction)dateChanged:(id)sender;

@end

@implementation DateSelectorViewController

# pragma mark Private

- (IBAction)dateChanged:(id)sender
{
    if ([self dateDelegate]) {
        [[self dateDelegate] dateChanged:[self datePicker] withTag:[self tag]];
    }
}

@end
