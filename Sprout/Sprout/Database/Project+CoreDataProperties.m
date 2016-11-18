//
//  Project+CoreDataProperties.m
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Project+CoreDataProperties.h"

@implementation Project (CoreDataProperties)

+ (NSFetchRequest<Project *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Project"];
}

@dynamic title;
@dynamic subtitle;
@dynamic notificationUUID;
@dynamic serverId;
@dynamic frontCameraEnabled;
@dynamic remindEnabled;
@dynamic repeatFrequency;
@dynamic repeatNextDate;
@dynamic transitionStyle;
@dynamic slideTime;
@dynamic playing;
@dynamic sproutSocial;
@dynamic useShadow;
@dynamic markedForDelete;
@dynamic uuid;

@dynamic videoURL;
@dynamic videoLastModified;

@dynamic created;
@dynamic lastModified;
@dynamic lastSync;

@dynamic timelines;

@end
