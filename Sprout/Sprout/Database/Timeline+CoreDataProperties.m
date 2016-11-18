//
//  Timeline+CoreDataProperties.m
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Timeline+CoreDataProperties.h"

@implementation Timeline (CoreDataProperties)

+ (NSFetchRequest<Timeline *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Timeline"];
}

@dynamic created;
@dynamic lastModified;
@dynamic lastSync;
@dynamic localURL;
@dynamic localThumbnailURL;
@dynamic order;
@dynamic serverId;
@dynamic serverURL;
@dynamic project;

@end
