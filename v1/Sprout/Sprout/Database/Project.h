//
//  Project+CoreDataClass.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Timeline;

NS_ASSUME_NONNULL_BEGIN

@interface Project : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Project+CoreDataProperties.h"
#import "Project+Extras.h"
