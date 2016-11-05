//
//  Project+CoreDataProperties.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Project.h"


NS_ASSUME_NONNULL_BEGIN

@interface Project (CoreDataProperties)

+ (NSFetchRequest<Project *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *subtitle;
@property (nullable, nonatomic, copy) NSNumber *serverId;
@property (nullable, nonatomic, copy) NSNumber *frontCameraEnabled;
@property (nullable, nonatomic, copy) NSNumber *remindEnabled;
@property (nullable, nonatomic, copy) NSNumber *repeatFrequency;
@property (nullable, nonatomic, copy) NSDate *repeatNextDate;
@property (nullable, nonatomic, copy) NSNumber *transitionStyle;
@property (nullable, nonatomic, copy) NSNumber *slideTime;
@property (nullable, nonatomic, copy) NSNumber *playing;
@property (nullable, nonatomic, copy) NSNumber *sproutSocial;


@property (nullable, nonatomic, copy) NSString *videoURL;
@property (nullable, nonatomic, copy) NSDate *videoLastModified;

@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *lastModified;
@property (nullable, nonatomic, copy) NSDate *lastSync;

@property (nullable, nonatomic, retain) NSSet<Timeline *> *timelines;

@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addTimelinesObject:(Timeline *)value;
- (void)removeTimelinesObject:(Timeline *)value;
- (void)addTimelines:(NSSet<Timeline *> *)values;
- (void)removeTimelines:(NSSet<Timeline *> *)values;

@end

NS_ASSUME_NONNULL_END
