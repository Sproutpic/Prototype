//
//  Timeline+CoreDataClass.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

NS_ASSUME_NONNULL_BEGIN

@interface Timeline : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Timeline+CoreDataProperties.h"
#import "Timeline+Extras.h"
