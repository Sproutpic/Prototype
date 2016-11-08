//
//  Timeline+CoreDataProperties.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Timeline+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Timeline (CoreDataProperties)

+ (NSFetchRequest<Timeline *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *lastModified;
@property (nullable, nonatomic, copy) NSDate *lastSync;
@property (nullable, nonatomic, copy) NSString *localURL;
@property (nullable, nonatomic, copy) NSString *localThumbnailURL;
@property (nullable, nonatomic, copy) NSNumber *order;
@property (nullable, nonatomic, copy) NSNumber *serverId;
@property (nullable, nonatomic, copy) NSString *serverURL;
@property (nullable, nonatomic, retain) Project *project;

@end

NS_ASSUME_NONNULL_END
