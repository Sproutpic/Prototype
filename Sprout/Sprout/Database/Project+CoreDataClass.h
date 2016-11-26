//
//  Project+CoreDataClass.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define NOTIFICATION_KEY_PROJECT_UUID    @"NOTIFICATION_KEY_PROJECT_UUID"

@class Timeline;

NS_ASSUME_NONNULL_BEGIN

@interface Project : NSManagedObject

+ (Project*)createNewProject:(NSString*)title
                    subTitle:(NSString*)subTitle
    withManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (Project*)findByUUID:(NSString*)uuid
               withMOC:(NSManagedObjectContext*)moc;

+ (NSArray*)sortDescriptors;

- (NSArray*)timelinesArraySorted;
- (NSArray*)timelinesArraySortedOldestToNewest;

- (void)updateScheduledNotification;

+ (void)updateAllProjectNotifications;

@end

NS_ASSUME_NONNULL_END

#import "Project+CoreDataProperties.h"
