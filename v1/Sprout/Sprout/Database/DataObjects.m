//
//  DataObjects.m
//  Sprout
//
//  Created by Jeff Morris on 10/27/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <CoreData/CoreData.h>

@implementation NSManagedObject (Extras)

- (void)save
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSError *error = nil;
    if ([moc hasChanges]) {
        if (![moc save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)deleteAndSave
{
    [[self managedObjectContext] deleteObject:self];
    [self save];
}

@end
