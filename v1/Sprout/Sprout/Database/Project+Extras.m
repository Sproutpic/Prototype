//
//  Project.m
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "Project.h"

@implementation Project (Extras)

# pragma mark Project

+ (Project*)createNewProject:(NSString*)title
                    subTitle:(NSString*)subTitle
    withManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSDate *date = [NSDate date];
    NSDate *noonDate = [[NSCalendar currentCalendar] dateBySettingHour:12 minute:0 second:0 ofDate:date options:NSCalendarWrapComponents];
    
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:@"Project"
                                                     inManagedObjectContext:managedObjectContext];
    [project setTitle:title];
    [project setSubtitle:subTitle];
    [project setRepeatNextDate:noonDate];
    [project setCreated:date];
    [project setSlideTime:@(1)];
    [project setRepeatFrequency:@(0)];
    return project;
}

+ (NSArray*)sortDescriptors
{
    return @[
             [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO],
             [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"subtitle" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"lastModified" ascending:NO]
             ];
}

+ (NSArray*)timelinesArraySorted:(Project*)project
{
    return [[[project timelines] allObjects] sortedArrayUsingDescriptors:
            @[
              [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO],
              [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:NO],
              ]];
}

@end
