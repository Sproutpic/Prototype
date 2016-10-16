//
//  Project.m
//  Sprout
//
//  Created by Jeff Morris on 10/10/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "Project.h"

@implementation Project

@dynamic title;
@dynamic subtitle;
@dynamic repeatNextDate;
@dynamic repeatFrequency;
@dynamic repeatEndDate;
@dynamic remindEnabled;
@dynamic timelines;

+ (Project*)createNewProject:(NSString*)title
                    subTitle:(NSString*)subTitle
    withManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Project class])
                                                     inManagedObjectContext:managedObjectContext];
    [project setTitle:title];
    [project setSubtitle:subTitle];
    [project setCreated:[NSDate date]];
    return project;
}

+ (NSArray*)sortDescriptors
{
    return @[
             [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"subtitle" ascending:YES]
             ];
}

@end
