//
//  CoreDataAccessKit.h
//  Sprout
//
//  Created by Jeff Morris on 10/11/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataAccessKit : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataAccessKit*)sharedInstance;
+ (NSURL*)storeURL;
+ (NSURL*)modelURL;

- (NSURL*)applicationDocumentsDirectory;
- (NSManagedObjectContext*)createNewManagedObjectContext;

@end
