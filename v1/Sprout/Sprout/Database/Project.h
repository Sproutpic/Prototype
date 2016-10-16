//
//  Project.h
//  Sprout
//
//  Created by Jeff Morris on 10/10/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "ServerRecord.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Timeline;

@interface Project : ServerRecord

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSDate * repeatNextDate;
@property (nonatomic, retain) NSNumber * repeatFrequency;
@property (nonatomic, retain) NSDate * repeatEndDate;
@property (nonatomic, retain) NSNumber * remindEnabled;
@property (nonatomic, retain) NSSet * timelines;

+ (Project*)createNewProject:(NSString*)title
                    subTitle:(NSString*)subTitle
    withManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSArray*)sortDescriptors;

@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addTimelinesObject:(Timeline *)value;
- (void)removeTimelinesObject:(Timeline *)value;
- (void)addTimelines:(NSSet *)values;
- (void)removeTimelines:(NSSet *)values;

@end
