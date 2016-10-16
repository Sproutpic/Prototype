//
//  CoreDataAccessKit.m
//  Sprout
//
//  Created by Jeff Morris on 10/11/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "CoreDataAccessKit.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define NAME_OF_DB_MODEL    @"DatabaseModel"
#define NAME_OF_SQL_DB      @"SproutPicDB.sqlite"

static CoreDataAccessKit *shared = nil;

@implementation CoreDataAccessKit

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

# pragma mark Public

+ (CoreDataAccessKit*)sharedInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[CoreDataAccessKit alloc] init];
    });
    return shared;
}

+ (NSURL*)storeURL
{
    return [[CoreDataAccessKit sharedInstance] storeURL];
}

- (NSURL*)storeURL
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:NAME_OF_SQL_DB];
}

+ (NSURL*)modelURL
{
    return [[CoreDataAccessKit sharedInstance] modelURL];
}

- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:NAME_OF_DB_MODEL withExtension:@"momd"];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext*)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    @synchronized(self) {
        _managedObjectContext = [self createNewManagedObjectContext];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    @synchronized(self) {
        NSURL *modelURL = [self modelURL];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    @synchronized(self) {
        NSURL *storeURL = [self storeURL];
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil URL:storeURL
                                                             options:@{
                                                                       NSMigratePersistentStoresAutomaticallyOption:@YES,
                                                                       NSInferMappingModelAutomaticallyOption:@YES}
                                                               error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// Create a new NSManagedObjectContext
- (NSManagedObjectContext *)createNewManagedObjectContext
{
    NSManagedObjectContext *moc = nil;
    @synchronized(self) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [moc setPersistentStoreCoordinator:coordinator];
            [moc setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
            [moc setUndoManager:nil];
        }
    }
    return moc;
}

@end
