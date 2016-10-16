//
//  Timeline.h
//  Sprout
//
//  Created by Jeff Morris on 10/10/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "ServerRecord.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Timeline : ServerRecord

@property (nonatomic, retain) NSString *serverURL;
@property (nonatomic, retain) NSNumber *order;
@property (nonatomic, retain) NSString *localURL;
@property (nonatomic, retain) Project *project;

+ (Timeline*)createNewTimelineWithServerURL:(NSString*)serverURL
                                 forProject:(Project*)project
                   withManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
