//
//  Project+CoreDataClass.m
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "Project.h"
#import "Timeline.h"

@implementation Project

# pragma mark NSManagedObject

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *now = [NSDate date];
    [self setCreated:now];
    [self setLastModified:now];
}

@end
