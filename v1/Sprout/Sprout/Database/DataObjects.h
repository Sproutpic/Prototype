//
//  DataObjects.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CoreDataAccessKit.h"

#import "Project.h"
#import "Project+CoreDataProperties.h"
#import "Project+Extras.h"

#import "Timeline.h"
#import "Timeline+CoreDataProperties.h"
#import "Timeline+Extras.h"

#define REPEAT_FREQUENCY_STRS @[ @"Daily", @"Weekly", @"Bi-Weekley", @"Monthly" ]

typedef enum RepeatFrequency {
    RF_Daily = 0,
    RF_Weekly,
    RF_BiWeekly,
    RF_Monthly,
    RF_Count
} RepeatFrequency;


@interface NSManagedObject (Extras)

- (void)save;
- (void)deleteAndSave;

@end
