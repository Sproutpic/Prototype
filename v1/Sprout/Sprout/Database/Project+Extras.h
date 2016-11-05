//
//  Project.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "Project.h"

@interface Project (Extras)

+ (Project*)createNewProject:(NSString*)title
                    subTitle:(NSString*)subTitle
    withManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSArray*)sortDescriptors;

+ (NSArray*)timelinesArraySorted:(Project*)project;

@end
