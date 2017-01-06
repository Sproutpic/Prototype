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

@interface CoreDataAccessKit ()
@property (strong, nonatomic) NSManagedObjectContext *privateManagedObjectContext; // Only to be used for major data migrations.
@end

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
    @synchronized(self) {
        if (_managedObjectContext != nil) {
            return _managedObjectContext;
        }
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            NSManagedObjectContext *pmoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [pmoc setPersistentStoreCoordinator:coordinator];
            [pmoc setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
            [pmoc setAutomaticallyMergesChangesFromParent:YES];
            [pmoc setName:@"PrivateMainContext"];
            _privateManagedObjectContext = pmoc;
            
            NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [moc setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
            [moc setParentContext:_privateManagedObjectContext];
            [moc setName:@"MainContext"];
            _managedObjectContext = moc;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(mergeChangesWithParent:)
                                                         name:NSManagedObjectContextDidSaveNotification
                                                       object:moc];
        }
        return _managedObjectContext;
    }
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    @synchronized(self) {
        if (_managedObjectModel != nil) {
            return _managedObjectModel;
        }
        NSURL *modelURL = [self modelURL];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        return _managedObjectModel;
    }
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    @synchronized(self) {
        if (_persistentStoreCoordinator != nil) {
            return _persistentStoreCoordinator;
        }
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
        return _persistentStoreCoordinator;
    }
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// Create a new NSManagedObjectContext
- (NSManagedObjectContext *)createNewManagedObjectContextwithName:(NSString*)name andConcurrency:(NSManagedObjectContextConcurrencyType)concurrency
{
    @synchronized(self) {
        NSManagedObjectContext *moc = nil;
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrency];
            [moc setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
            [moc setParentContext:[self managedObjectContext]];
            if (name) [moc setName:name];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(mergeChangesWithParent:)
                                                         name:NSManagedObjectContextDidSaveNotification
                                                       object:moc];
        }
        return moc;
    }
}

- (NSArray*)findObjects:(NSString*)entityType forPredicate:(NSPredicate*)predicate withSort:(NSArray*)sortDescriptors inMOC:(NSManagedObjectContext*)moc
{
    if (!moc) {
        NSLog(@"Dev Error: Fetching all objects with out a NSManagedObjectContext instance!");
        return nil;
    }
    if (!entityType) {
        NSLog(@"Dev Error: No entity name to fetch!");
        return nil;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityType inManagedObjectContext:moc]];
    [request setPredicate:predicate];
    if (sortDescriptors) [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (error != nil) {
        NSLog(@"NSManagedObject - Find Objects Error: %@",[error description]);
    }
    return ([results count]>0) ? results : @[];
}

- (NSManagedObject*)findAnObject:(NSString*)entityType
                    forPredicate:(NSPredicate*)predicate
                        withSort:(NSArray*)sortDescriptors
                           inMOC:(NSManagedObjectContext*)moc
{
    NSArray *objs = [self findObjects:entityType forPredicate:predicate withSort:sortDescriptors inMOC:moc];
    if ([objs count]>0) {
        return [objs firstObject];
    }
    return nil;
}

- (void)mergeChangesWithParent:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:[NSManagedObjectContext class]]) {
        NSManagedObjectContext *moc = (NSManagedObjectContext*)[notification object];
        if (moc) {
            NSManagedObjectContext *parent = moc.parentContext;
            [parent performBlockAndWait:^{
                NSError *error = nil;
                if ([parent hasChanges]) {
                    if (![parent save:&error]) {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                }
            }];
        }
    }
}

- (void)mergeChanges:(NSNotification *)notification
{
    // Merge changes into the main context on the main thread
    [[self managedObjectContext] performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                                  withObject:notification
                                               waitUntilDone:YES];
}

@end
