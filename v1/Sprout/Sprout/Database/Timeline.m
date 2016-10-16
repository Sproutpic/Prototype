//
//  Timeline.m
//  Sprout
//
//  Created by Jeff Morris on 10/10/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "Timeline.h"
#import "Project.h"

@implementation Timeline

@dynamic serverURL;
@dynamic order;
@dynamic localURL;
@dynamic project;

+ (Timeline*)createNewTimelineWithServerURL:(NSString*)serverURL
                                 forProject:(Project*)project
                   withManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    Timeline *timeline = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Timeline class])
                                                       inManagedObjectContext:managedObjectContext];
    [timeline setServerURL:serverURL];
    [timeline setOrder:@([[project timelines] count]+1)];
    [timeline setProject:project];
    [project addTimelinesObject:timeline];
    [timeline setCreated:[NSDate date]];
    return timeline;
}

@end
