//
//  DataObjects.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CoreDataAccessKit.h"

#import "Project+CoreDataClass.h"
#import "Project+CoreDataProperties.h"

#import "Timeline+CoreDataClass.h"
#import "Timeline+CoreDataProperties.h"

#define REPEAT_FREQUENCY_STRS @[ @"Daily", @"Weekly", @"Bi-Weekly", @"Monthly", @"* Every Hour (For Testing) *" ]

typedef enum RepeatFrequency {
    RF_Daily = 0,
    RF_Weekly = 1,
    RF_BiWeekly = 2,
    RF_Monthly = 3,
    RF_Every_Hour = 4, // Testing only...
    RF_Count
} RepeatFrequency;


@interface NSManagedObject (Extras)

- (void)save;
- (void)deleteAndSave;

@end

@interface NSManagedObjectContext (Extras)

- (void)saveAll;

@end
