//
//  Timeline.h
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "Timeline.h"
#import <UIKit/UIKit.h>

@interface Timeline (Extras)

+ (Timeline*)createNewTimelineWithServerURL:(NSString*)serverURL
                                 forProject:(Project*)project
                                    withMOC:(NSManagedObjectContext*)moc;

+ (NSString*)saveImage:(UIImage*)img;
+ (NSString*)saveThumbnailImage:(UIImage*)img;

+ (UIImage*)image:(Timeline*)timeline;
+ (UIImage*)imageOrTempImage:(Timeline*)timeline;

+ (UIImage*)imageThumbnail:(Timeline*)timeline;
+ (UIImage*)imageThumbnailOrTempImage:(Timeline*)timeline;

@end
