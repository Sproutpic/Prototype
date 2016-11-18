//
//  Timeline+CoreDataClass.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class Project;

NS_ASSUME_NONNULL_BEGIN

@interface Timeline : NSManagedObject

+ (Timeline*)createNewTimelineWithServerURL:(NSString*)serverURL
                                 forProject:(Project*)project
                                    withMOC:(NSManagedObjectContext*)moc;

- (NSString*)saveImage:(UIImage*)img;
- (NSString*)saveThumbnailImage:(UIImage*)img;

- (UIImage*)image;
- (UIImage*)imageOrTempImage;

- (UIImage*)imageThumbnail;
- (UIImage*)imageThumbnailOrTempImage;

@end

NS_ASSUME_NONNULL_END

#import "Timeline+CoreDataProperties.h"
